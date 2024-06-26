import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          TextField(
              controller: _email,
              enableSuggestions: false,
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                  hintText: "Enter your email",
                  contentPadding: EdgeInsets.fromLTRB(8.0, 4.0, 0, 4.0))),
          TextField(
              controller: _password,
              obscureText: true,
              enableSuggestions: false,
              autocorrect: false,
              decoration: const InputDecoration(
                  hintText: "Enter your password",
                  contentPadding: EdgeInsets.fromLTRB(8.0, 4.0, 0, 4.0))),
          Column(
            children: [
              TextButton(
                  onPressed: () async {
                    final email = _email.text;
                    final password = _password.text;

                    try {
                      final userCredential = await FirebaseAuth.instance
                          .createUserWithEmailAndPassword(
                              email: email, password: password);

                      devtools.log(userCredential.toString());
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'weak-password') {
                        devtools.log("This password is a weak password!");
                      } else if (e.code == 'email-already-in-use') {
                        devtools.log("Email is already in use!");
                      }
                    }
                  },
                  child: const Text("Register",
                      style: TextStyle(color: Colors.blue, fontSize: 20.0))),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already registered?",
                      style: TextStyle(color: Colors.blue, fontSize: 20.0)),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            '/login/', (route) => false);
                      },
                      child: const Text("login",
                          style: TextStyle(color: Colors.blue, fontSize: 20.0)))
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
