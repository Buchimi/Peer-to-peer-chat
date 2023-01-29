import 'package:a_talk_plus/services/constants.dart';
import 'package:a_talk_plus/services/db.dart';
import 'package:a_talk_plus/services/helper.dart';
import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart' as chat_lib;
import 'package:flutter_chat_types/flutter_chat_types.dart' as chat_types;
import 'package:nearby_connections/nearby_connections.dart';
import 'package:uuid/uuid.dart';
import '../models/user.dart';

class Chat extends StatefulWidget {
  const Chat({super.key, required this.recieverID});

  final String recieverID;

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  List<chat_types.TextMessage> displayMessages() {
    if (DB.getMessages(widget.recieverID) != null) {
      return DB.getMessages(widget.recieverID)!.map((msg) {
        if (msg.author.id != Constants.myID) {
          return chat_types.TextMessage(
              author: chat_types.User(id: widget.recieverID),
              id: msg.id,
              text: msg.text);
        }
        return msg;
      }).toList();
    }

    return [
      chat_types.TextMessage(
          id: "1",
          author: chat_types.User(id: Constants.myID),
          text: "Start a chat")
    ];
  }

  @override
  Widget build(BuildContext context) {
    return chat_lib.Chat(
      theme: const chat_lib.DarkChatTheme(),
      
      messages: displayMessages(),
      onSendPressed: (txt) {
        final chat_types.TextMessage msgToBeSaved =
            chat_types.TextMessage.fromPartial(
                author: chat_types.User(id: Constants.myID),
                id: const Uuid().v4(),
                partialText: txt);
        final chat_types.TextMessage msgToBeSent =
            chat_types.TextMessage.fromPartial(
                author: chat_types.User(id: const Uuid().v4()),
                id: const Uuid().v4(),
                partialText: txt);

        setState(() {
          DB.addMessage(widget.recieverID, msgToBeSaved);
          try {
            Nearby().sendBytesPayload(
              widget.recieverID,
              Helper.stringToBytes(
                msgToBeSent.toJson().toString(),
              ),
            );
          } catch (_) {}
        });
      },
      user: chat_types.User(id: Constants.myID),
    );
  }
}
