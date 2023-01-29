import 'package:a_talk_plus/extra.dart';
import 'package:a_talk_plus/login/attendant.dart';
import 'package:a_talk_plus/services/constants.dart';
import 'package:flutter/material.dart';

TextEditingController _seatNumberTEC = TextEditingController();
TextEditingController _usernameTEC = TextEditingController();

String _seatNumber = "";
String _flightNumber = "";

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        debugShowCheckedModeBanner: false, home: LoginExt());
  }
}

class LoginExt extends StatefulWidget {
  const LoginExt({Key? key}) : super(key: key); // Constructor

  @override
  _LoginExtState createState() => _LoginExtState(); // Override our app
}

class _LoginExtState extends State<LoginExt> {
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
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            //Login
            const Text(
              'Passenger Login',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 50,
              ),
            ),
            const SizedBox(height: 20),

            //Seat number
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: TextField(
                    controller: _seatNumberTEC,
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Enter seat number'),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            //Flight number
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: TextField(
                    controller: _usernameTEC,
                    decoration: const InputDecoration(
                        border: InputBorder.none, hintText: 'Username'),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            //signin button
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _seatNumber = _seatNumberTEC.text;
                    _flightNumber = _usernameTEC.text;
                    Constants.myUserName = _usernameTEC.text;
                  });

                  _seatNumber != "" && _flightNumber != ""
                      ? Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MyHomePage(),
                          ))
                      : Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Login(),
                          ));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: const Center(
                  child: Text('Chat',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      )),
                ),
              ),
            ),
            const SizedBox(height: 10),
          ]),
        ),
      ),
    );
  }
}
