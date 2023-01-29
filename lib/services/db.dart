import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:nearby_connections/nearby_connections.dart';

import '../models/message.dart';
import '../models/user.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as chat_types;

class DB {
  static final Map<String, User> _connectedPeers = <String, User>{};
  static final Map<String, List<chat_types.TextMessage>> _messageDB =
      <String, List<chat_types.TextMessage>>{};
  static addPeer(String peerName, String userID) {
    _connectedPeers["d"] = User(name: peerName, userID: userID);
  }

  static removePeer(String peerName) {
    _connectedPeers.remove(peerName);
  }

  static removeAllPeers() {
    _connectedPeers.clear();
  }

  static addMessage(String peer, chat_types.TextMessage message) {
    if (_messageDB[peer] == null) {
      _messageDB[peer] = [message];
    } else {
      _messageDB[peer]!.insert(0, message);

    }
  }

  static List<chat_types.TextMessage>? getMessages(String peer) {
    return _messageDB[peer];
  }

  static String? getPeerNameFromID(String id) {
    return _connectedPeers[id]?.name;
  }
}
