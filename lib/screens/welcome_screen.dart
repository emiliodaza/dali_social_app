import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:untitled/screens/home_screen.dart';
import 'package:untitled/screens/register_screen.dart';
import '../widgets.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class WelcomeScreen extends StatefulWidget {
  static final String route = "welcome_screen";
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _claimCodeController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _claimCodeController.dispose();
    super.dispose();
  }

  Future<void> _claimAndRegister() async {
    final code = _claimCodeController.text.trim();
    final password = _passwordController.text;
    final email = _emailController.text.trim();

    if (code.isEmpty || password.isEmpty || email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'To claim and get the account you must enter claim code, desired email and desired password',
          ),
        ),
      );
      return;
    }
    try {
      final q = await FirebaseFirestore.instance
          .collection('users')
          .where('code_to_claim', isEqualTo: code)
          .limit(1)
          .get();

      if (q.docs.isEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Invalid claim code')));
        return;
      }

      final doc = q.docs.first;
      final data = doc.data();

      final alreadyClaimed = data['claimed'];

      if (alreadyClaimed) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('The claim code provided has already been used'),
          ),
        );
        return;
      }

      final cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = cred.user!.uid;

      await doc.reference.update({
        'claimed': true,
        'authUid': uid,
        'email': email,
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Your account has been successfully claimed')),
      );

      Navigator.pushReplacementNamed(context, HomeScreen.route);
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      final msg = switch (e.code) {
        'email-already-in-use' =>
          'That email is already in use, try logging in normally instead',
        'invalid-email' => 'Invalid email format.',
        'weak-password' => 'Password is too weak (try 6+ characters).',
        _ => e.message ?? 'Claim failed',
      };
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Unexpected error')));
    }
  }

  Future<void> _login() async {
    final String email = _emailController.text.trim();
    final String password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Email and password entries are empty')),
      );
      return;
    }

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, HomeScreen.route);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Try again or use a claim code since the credentials are incorrect',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.all(20),
              height: double.infinity,
              width: 100,
              decoration: BoxDecoration(color: Colors.black45),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,

                    children: [
                      TypewriterAnimatedTextKit(
                        text: ['Welcome!'],
                        textStyle: TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        speed: Duration(milliseconds: 150),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.engineering,
                        color: Color.fromRGBO(255, 232, 168, 1),
                      ),
                      SizedBox(width: 5),
                      Icon(
                        Icons.computer,
                        color: Color.fromRGBO(0, 173, 171, 1),
                      ),
                      SizedBox(width: 5),
                      Icon(
                        Icons.design_services,
                        color: Color.fromRGBO(0, 128, 255, 1),
                      ),
                      SizedBox(width: 5),
                      Icon(
                        Icons.manage_accounts,
                        color: Color.fromRGBO(255, 143, 133, 1),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Container(color: Color.fromRGBO(61, 79, 92, 0.6), width: 2),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(40),
              color: Color.fromRGBO(61, 79, 92, 0.3),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Log into DALI Social',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Ubuntu',
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(height: 15),
                      TextFieldEmptyInside(
                        hint: 'Dartmouth email',
                        controller: _emailController,
                      ),
                      SizedBox(height: 10),
                      TextFieldEmptyInside(
                        hint: 'Password',
                        controller: _passwordController,
                        obscureText: true,
                      ),
                      SizedBox(height: 10),
                      TextFieldEmptyInside(
                        hint: 'Claim Code (optional for normal login)',
                        controller: _claimCodeController,
                      ),
                      SizedBox(height: 10),
                      daliButtonWidgetForLogin(
                        text: 'Log in',
                        onPressed: () {
                          _login();
                        },
                      ),
                      SizedBox(height: 5),
                      TextButton(
                        style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                            side: BorderSide(
                              color: Color.fromRGBO(0, 173, 171, 1),
                            ),
                          ),
                        ),
                        onPressed: () {
                          _claimAndRegister();
                        },
                        child: Text(
                          'Log in using claim code',
                          style: TextStyle(
                            fontFamily: 'Ubuntu',
                            color: Color.fromRGBO(0, 173, 171, 1),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: 5),
                      TextButton(
                        style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                            side: BorderSide(
                              color: Color.fromRGBO(0, 173, 171, 1),
                            ),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, RegisterScreen.route);
                        },
                        child: Text(
                          'Create new account',
                          style: TextStyle(
                            fontFamily: 'Ubuntu',
                            color: Color.fromRGBO(0, 173, 171, 1),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
