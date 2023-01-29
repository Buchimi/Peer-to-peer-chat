import 'package:a_talk_plus/services/helper.dart';
import 'package:a_talk_plus/services/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import 'package:nearby_connections/nearby_connections.dart';

import '../services/db.dart';

class Scanner extends StatefulWidget {
  ///when we find a peer we want to connect to, we
  ///have to make the connection, and if we are broadcasting we prolly
  ///have to end the broadcast and start broadcasting the new network
  ///depends
  const Scanner(
      {super.key,
      
      required this.nickname,
      this.onEndpointLost});

  
  final Function(String?)? onEndpointLost;
  final String nickname;

  @override
  State<Scanner> createState() => _ScannerState();
}

class _ScannerState extends State<Scanner> {
  final Strategy strategy = Strategy.P2P_CLUSTER;

  bool searching = false;
  String status = "";
  updateStatus(String str) {
    setState(() {
      status += str;
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
      setState(() {
        status += "found $endpointId\n";
      });
      Nearby().requestConnection(
        widget.nickname,
        endpointId,
        onConnectionInitiated: (endpointId, connectionInfo) {
          Nearby().acceptConnection(
            endpointId,
            onPayLoadRecieved: (endpointId, payload) {},
          );
        },
        onConnectionResult: (endpointId, status) {
          if (status == Status.CONNECTED) {
            updateStatus("connected to $endpointId\n");
          } else if (status == Status.ERROR) {
            updateStatus("errored out\n");
          }
        },
        onDisconnected: (endpointId) {
          updateStatus("disconnected from $endpointId\n");
        },
      );
    }, onEndpointLost: (endpointId) {
      updateStatus("lost connection to $endpointId");
    }, serviceId: Constants.serviceID);
  }

  hostPeers() async {
    await grabPermissions();
    Nearby().startAdvertising(widget.nickname, strategy,
        onConnectionInitiated: (endpointId, info) {
      updateStatus("Found $endpointId");
      Nearby().acceptConnection(endpointId,
          onPayLoadRecieved: (endpointID, payload) {});
    }, onConnectionResult: (endpointId, status) {
      if (status == Status.CONNECTED) {
        updateStatus("connected to $endpointId\n");
      } else if (status == Status.ERROR) {
        updateStatus("errored out\n");
      }
      // Nearby().sendBytesPayload(str, Helper.stringToBytes(str));
    }, onDisconnected: (endpointID) {
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
    Nearby().stopAllEndpoints();
  }

  @override
  Widget build(BuildContext context) {
    //search for peers

    return Column(
      children: [
        Text(status),
        CircularProgressIndicator(),
        Row(
          children: [
            ElevatedButton(
                onPressed: () {
                  setState(() {
                    status += "searching for peers\n";
                  });
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
                child: const Text("Disconnect"))
          ],
        )
      ],
    );
  }
}
