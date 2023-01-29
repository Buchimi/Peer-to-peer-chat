import 'package:a_talk_plus/services/helper.dart';
import 'package:a_talk_plus/services/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

import 'package:nearby_connections/nearby_connections.dart';

import '../services/db.dart';

class Scanner extends StatefulWidget {
  ///when we find a peer we want to connect to, we
  ///have to make the connection, and if we are broadcasting we prolly
  ///have to end the broadcast and start broadcasting the new network
  ///depends
  const Scanner({super.key, required this.nickname, this.onEndpointLost});

  final Function(String?)? onEndpointLost;
  final String nickname;

  @override
  State<Scanner> createState() => _ScannerState();
}

class _ScannerState extends State<Scanner> {
  final Strategy strategy = Strategy.P2P_CLUSTER;
  void onPayLoadRecieved(peerID, payload) {
    types.TextMessage msg = Helper.messageFromBytes(payload);
    // msg.author.id = peerID;
    DB.addMessage(peerID, msg);
  }

  String potentialPair = "";
  bool searching = false;
  String status = "Lazy";
  updateStatus(String str) {
    setState(() {
      status = str;
    });
  }

  addPeer(String name, String endpointId) {
    setState(() {
      DB.addPeer(name, endpointId);
    });
  }

  removePeer(String endpointId) {
    setState(() {
      DB.removePeer(endpointId);
    });
  }

  grabPermissions() async {
    bool hasBlueTooth = await Nearby().checkBluetoothPermission();
    bool hasLocationEnabled = await Nearby().checkLocationEnabled();
    bool hasLocationPermission = await Nearby().checkLocationPermission();
    if (!hasBlueTooth) {
      Nearby().askBluetoothPermission();
    }
    if (!hasLocationPermission || !hasLocationEnabled) {
      await Nearby().askLocationPermission();
      await Nearby().enableLocationServices();
    }
    return Future.value();
  }

  discoverPeers() async {
    await grabPermissions();
    Nearby().startDiscovery(widget.nickname, strategy,
        // onEndpointFound: widget.onEndpointFound,
        // onEndpointLost: widget.onEndpointLost ?? (endpointId) => {},
        onEndpointFound: (endpointId, endpointName, serviceId) {
      updateStatus("found $endpointId\n");
      Nearby().requestConnection(
        widget.nickname,
        endpointId,
        onConnectionInitiated: (endpointId, connectionInfo) {
          Nearby().acceptConnection(
            endpointId,
            onPayLoadRecieved: (endpointId, payload) {
              onPayLoadRecieved(endpointId, payload);
            },
          );
        },
        onConnectionResult: (endpointId, status) {
          if (status == Status.CONNECTED) {
            addPeer(endpointName, endpointId);

            updateStatus("connected to $endpointId\n");
          } else if (status == Status.ERROR) {
            updateStatus("errored out\n");
          }
        },
        onDisconnected: (endpointId) {
          updateStatus("disconnected from $endpointId\n");
          removePeer(endpointId);
        },
      );
    }, onEndpointLost: (endpointId) {
      updateStatus("lost connection to $endpointId");
      removePeer(endpointId!);
    }, serviceId: Constants.serviceID);
  }

  hostPeers() async {
    await grabPermissions();
    Nearby().startAdvertising(widget.nickname, strategy,
        onConnectionInitiated: (endpointId, info) {
      potentialPair = info.endpointName;
      updateStatus("Found $endpointId");
      Nearby().acceptConnection(endpointId,
          onPayLoadRecieved: (endpointID, payload) {
        onPayLoadRecieved(endpointID, payload);
      });
    }, onConnectionResult: (endpointId, status) {
      if (status == Status.CONNECTED) {
        addPeer(potentialPair, endpointId);

        updateStatus("connected to $endpointId\n");
      } else if (status == Status.ERROR) {
        updateStatus("errored out\n");
      }
      // Nearby().sendBytesPayload(str, Helper.stringToBytes(str));
    }, onDisconnected: (endpointID) {
      removePeer(endpointID);
      updateStatus("Disconnected from $endpointID \n");
    }, serviceId: Constants.serviceID);
  }

  stopSearching() {
    updateStatus("stopped \n");
    Nearby().stopDiscovery();
  }

  stopHosting() {
    Nearby().stopAdvertising();
  }

  disconnectAllPeers() {
    updateStatus("Disconnecting\n");
    Nearby().stopAllEndpoints().then((value) => updateStatus("Disconnected"));
  }

  @override
  Widget build(BuildContext context) {
    //search for peers

    return Scaffold(
      body: Stack(children: [
        Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 4,
              color: Color.fromRGBO(0x0d, 0x73, 0xb1, 1),

              // decoration: BoxDecoration(color: ),
            ),
            Expanded(
              child: Container(
                decoration:
                    BoxDecoration(color: Color.fromRGBO(0xc7, 0xd0, 0xd7, 1)),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 4,
              color: Color.fromRGBO(0xB6, 0x1f, 0x23, 1),
            )
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: const [
                Text("Scan for new peers"),
                Icon(
                  Icons.wifi_tethering,
                  size: 50,
                ),
              ],
            ),
            Text(
              status,
              style: const TextStyle(
                fontSize: 24,
              ),
            ),
            () {
              if (status.startsWith("searching")) {
                return CircularProgressIndicator();
              }
              return Container();
            }(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                    onPressed: () {
                      updateStatus("searching for peers\n");
                      hostPeers();
                      discoverPeers();
                    },
                    child: const Text("Find peers")),
                ElevatedButton(
                    onPressed: () {
                      setState(() {
                        searching = true;
                      });
                      stopSearching();
                      stopHosting();
                    },
                    child: const Text("Stop Searching")),
                ElevatedButton(
                    onPressed: () {
                      setState(() {
                        searching = false;
                        disconnectAllPeers();
                        Helper.connected = false;
                      });
                    },
                    child: const Text("Disconnect")),
                
              ],
            )
          ],
        ),
      ]),
    );
  }
}
