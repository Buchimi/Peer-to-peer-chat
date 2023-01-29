import 'package:flutter/material.dart';

import '../login/attendant.dart';
import '../login/login.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({
    super.key,
  });

  @override
  State<LoginPage> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
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
    final Size buttonSize =
        Size(MediaQuery.of(context).size.width * 8 / 10, 50);
    const double fontSize = 20;
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
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
                        fontSize: 40,
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
                      minimumSize: buttonSize,
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
                      style: TextStyle(
                          fontSize: fontSize, fontFamily: 'RobotoMono'),
                    ), // Child of button (not constant of variable can change)
                  ), // First button

                  const SizedBox(
                    height: 20,
                  ),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.red,
                      minimumSize: buttonSize,
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
                      style: TextStyle(
                          fontSize: fontSize, fontFamily: 'RobotoMono'),
                    ), // Child of button (not constant of variable can change)
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
