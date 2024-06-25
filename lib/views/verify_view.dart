import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewwState();
}

class _VerifyEmailViewwState extends State<VerifyEmailView> {
  late bool _isLoading;
  late String? _message;

  @override
  void initState() {
    _isLoading = false;
    _message = null;
    super.initState();
  }

  Future<void> handleVerifyEmail() async {
    setState(() {
      _isLoading = true;
      _message = null;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      await user?.sendEmailVerification();

      setState(() {
        _message = "Verification email has been sent.";
      });
    } catch (e) {
      setState(() {
        _message = "Failed to send verification email: $e";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text("please verify your email address:"),
        TextButton(
          onPressed: _isLoading ? null : handleVerifyEmail,
          child: _isLoading
              ? const CircularProgressIndicator()
              : const Text("Verify Email"),
        ),
        if (_message != null) Text(_message!),
      ],
    );
  }
}
