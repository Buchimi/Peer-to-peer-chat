import 'package:a_talk_plus/login/login.dart';
import 'package:flutter/material.dart';

TextEditingController _usernameTEC = TextEditingController();
TextEditingController _passwordTEC = TextEditingController();

String _username = "";
String _password = "";

class Attendant extends StatefulWidget {
  const Attendant({super.key});

  @override
  State<Attendant> createState() => _AttendantState();
}

class _AttendantState extends State<Attendant> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: AttendantExt());
  }
}

class AttendantExt extends StatefulWidget {
  AttendantExt({Key? key}) : super(key: key); // Constructor

  @override
  _AttendantExtState createState() => _AttendantExtState(); // Override our app
}

class _AttendantExtState extends State<AttendantExt> {
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
              'Flight Attendant Login',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 50,
              ),
            ),
            const SizedBox(height: 20),

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
                        border: InputBorder.none,
                        hintText: 'Enter employee username'),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

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
                    controller: _passwordTEC,
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Enter employee password'),
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            //signin button
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _username = _usernameTEC.text;
                  _password = _passwordTEC.text;
                });

                _username != "" && _password != ""
                    ? Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const Login()))
                    : Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Attendant()),
                      );
              },
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Text('Check In',
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
