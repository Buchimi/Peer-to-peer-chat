import 'package:a_talk_plus/pages/chat_screen.dart';
import 'package:a_talk_plus/pages/home_screen.dart';
import 'package:a_talk_plus/services/constants.dart';
import 'package:a_talk_plus/services/db.dart';
import 'package:a_talk_plus/services/helper.dart';
import 'package:a_talk_plus/pages/Scanner.dart';
import 'package:flutter/material.dart';
import 'package:nearby_connections/nearby_connections.dart';

import 'models/user.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  User user = User(name: "Bee", userID: Constants.myID);
  String activeUser = "";
  final GlobalKey<ScaffoldState> _scafoldState = GlobalKey<ScaffoldState>();
  Widget widx = const DrawerHeader(
    decoration: BoxDecoration(
      color: Colors.blue,
    ),
    child: Text(
      'American Airlines Chat',
      style: TextStyle(
        color: Colors.white,
        fontSize: 24,
      ),
    ),
  );
  List<Widget> generateList() {
    List<Widget> list = [widx];

    DB.getPeers().values.forEach((element) {
      list.add(ListTile(
        title: Text(
          element.name,
          //style: TextStyle(color: Colors.white),
        ),
        onTap: () => setState(() {
          activeUser = element.userID;
          _scafoldState.currentState?.closeDrawer();
        }),
      ));
    });
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scafoldState,
      drawer: Drawer(
        // backgroundColor: Color.fromARGB(255, 22, 11, 51),
        child: ListView(
          padding: EdgeInsets.zero,
          children: generateList(),
        ),
      ),
      appBar: AppBar(
        title: Text(activeUser != ""
            ? DB.getPeers().containsKey(activeUser)
                ? DB.getPeers()[activeUser]!.name
                : activeUser
            : "Chat"),
      ),
      body: () {
        if (activeUser != "") {
          return Chat(recieverID: activeUser);
        }
        return Center(child: Text("Find a peer by searching", style: TextStyle(fontSize: 28),));
      }(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (ctx) => const Scanner(
                nickname: 'Eli',
              ),
            ),
          );
        },
        child: const Icon(Icons.search),
      ),
    );
  }
}
