import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
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
        title: const Text("Login", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          TextField(
              controller: _email,
              enableSuggestions: false,
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(hintText: "Enter your email")),
          TextField(
              controller: _password,
              obscureText: true,
              enableSuggestions: false,
              autocorrect: false,
              decoration:
                  const InputDecoration(hintText: "Enter your password")),
          Column(
            children: [
              TextButton(
                  onPressed: () async {
                    final email = _email.text;
                    final password = _password.text;

                    try {
                      await FirebaseAuth.instance.signInWithEmailAndPassword(
                          email: email, password: password);

                      if (mounted) {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            '/notes/', (route) => false);
                      }
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'invalid-credential') {
                        devtools.log("User not Found");
                      } else {
                        devtools.log("SOMETHING ELSE HAPPENED");
                        devtools.log(e.code);
                      }
                    }
                  },
                  child: const Text("Login",
                      style: TextStyle(color: Colors.blue, fontSize: 20.0))),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Not register yet?",
                      style: TextStyle(color: Colors.blue, fontSize: 20.0)),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            '/register/', (route) => false);
                      },
                      child: const Text("Register here",
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
