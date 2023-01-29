import 'package:a_talk_plus/pages/chat_screen.dart';
import 'package:a_talk_plus/services/db.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart' as chat_ui;

import '../components.dart';
import '../models/user.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String activeUser = "";

  @override
  Widget build(BuildContext context) {
    print(DB.getPeers());
    print(DB.getPeers().length);
    return Row(
      children: [
        
        () {
          if (DB.getPeers().isEmpty) {
            return const Text("Haven't found any peers");
          } else {
            return Chat(recieverID: DB.getPeers().values.toList()[0].userID);
          }
        }()
      ],
    );
  }
}
