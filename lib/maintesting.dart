
import 'package:a_talk_plus/login/attendant.dart';
import 'package:a_talk_plus/login/login.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp(title: "Welcome Page"));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key, required this.title});

  final String title;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: MyAppExt());
  }
}

class MyAppExt extends StatefulWidget {
  MyAppExt({Key? key}) : super(key: key); // Constructor

  @override
  _MyAppExtState createState() => _MyAppExtState(); // Override our app
}

class _MyAppExtState extends State<MyAppExt> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("images/sky.jpg"),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "ChatAA",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 200,
                      fontWeight: FontWeight.bold,
                      color: Colors.red.withOpacity(1.0)),
                ),

                const SizedBox(
                  height: 20,
                ),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.white,
                    minimumSize: const Size(400, 100),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                  ),

                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Login()),
                    );
                  },

                  child: const Text(
                    'Passenger',
                    style: TextStyle(fontSize: 50, fontFamily: 'RobotoMono'),
                  ), // Child of button (not constant of variable can change)
                ), // First button

                const SizedBox(
                  height: 20,
                ),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.red,
                    minimumSize: const Size(400, 100),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                  ),

                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Attendant()),
                    );
                  },

                  child: const Text(
                    'Flight Attendant',
                    style: TextStyle(fontSize: 50, fontFamily: 'RobotoMono'),
                  ), // Child of button (not constant of variable can change)
                ),
              ],
            )),

      ),
    );
  }
}
