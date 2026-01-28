import 'dart:typed_data';
import 'package:mime/mime.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:untitled/screens/home_screen.dart';
import 'package:untitled/screens/welcome_screen.dart';
import 'package:choice/choice.dart';
import 'package:file_picker/file_picker.dart';

import '../widgets.dart';

class RegisterScreen extends StatefulWidget {
  static final String route = "register_screen";
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _majorController = TextEditingController();
  final _minorController = TextEditingController();
  final _classYearController = TextEditingController();
  final _homeController = TextEditingController();
  final _fav1Controller = TextEditingController();
  final _fav2Controller = TextEditingController();
  final _fav3Controller = TextEditingController();
  final _quoteController = TextEditingController();
  final _funFactController = TextEditingController();
  final _traditionController = TextEditingController();

  List<String> role_choices = ['dev', 'des', 'pm', 'core', 'mentor'];
  final Set<String> selectedRoles = {};

  late DateTime? date;
  String displayDate = '';
  Uint8List? pickedImageBytes;
  PlatformFile? pickedFileRegister;
  FilePickerResult? resultRegister;
  String filenameRegister = '';

  bool _isSubmitting = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _majorController.dispose();
    _minorController.dispose();
    _classYearController.dispose();
    _homeController.dispose();
    _fav1Controller.dispose();
    _fav2Controller.dispose();
    _fav3Controller.dispose();
    _quoteController.dispose();
    _funFactController.dispose();
    _traditionController.dispose();
    super.dispose();
  }

  Map<String, bool> _buildRoleMap() {
    return {for (final r in role_choices) r: selectedRoles.contains(r)};
  }

  String _safeTrim(TextEditingController c) => c.text.trim();

  Future<void> _submit() async {
    if (_isSubmitting) return;
    final email = _safeTrim(_emailController);
    final password = _passwordController.text;
    final name = _safeTrim(_nameController);

    if (email.isEmpty || password.isEmpty || name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Email, password, and name are required fields.'),
        ),
      );
      return;
    }
    setState(() => _isSubmitting = true);
    try {
      final cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final uid = cred.user!.uid;
      String? profilePicUrl;
      if (pickedImageBytes != null) {
        try {
          final extension = (pickedFileRegister?.extension?.isNotEmpty ?? false)
              ? pickedFileRegister!.extension!
              : 'jpg';
          final ref = FirebaseStorage.instance
              .ref()
              .child('users')
              .child(uid)
              .child('profile.$extension');
          await ref.putData(
            pickedImageBytes!,
            SettableMetadata(
              contentType:
                  lookupMimeType(pickedFileRegister!.name) ?? 'image/jpeg',
            ),
          );
          profilePicUrl = await ref.getDownloadURL();
        } catch (e) {
          profilePicUrl = null;
        }
      }

      final roles = _buildRoleMap();

      final userDoc = <String, dynamic>{
        'email': email,
        'name': name,
        'major': _safeTrim(_majorController),
        'minor': _safeTrim(_minorController),
        'year': _safeTrim(_classYearController),
        'home': _safeTrim(_homeController),
        'favorite thing 1': _safeTrim(_fav1Controller),
        'favorite thing 2': _safeTrim(_fav2Controller),
        'favorite thing 3': _safeTrim(_fav3Controller),
        'quote': _safeTrim(_quoteController),
        'fun fact': _safeTrim(_funFactController),
        'favorite dartmouth tradition': _safeTrim(_traditionController),
        'birthday': (date != null) ? '${date?.month}-${date?.day}' : '-',
        'picture': profilePicUrl,
        ...roles,
      };
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .set(userDoc);

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Account created!')));
      Navigator.pushReplacementNamed(context, HomeScreen.route);
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      final msg = switch (e.code) {
        'email-already-in-use' => 'The email is already in use.',
        'invalid-email' => 'Invalid email format.',
        'weak-password' => 'Password is too weak (try 6+ characters).',
        _ => e.message ?? 'Registration was not possible.',
      };
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Unexpected error')));
    } finally {
      if (mounted)
        setState(() {
          _isSubmitting = false;
        });
    }
  }

  void PickFile() async {
    try {
      resultRegister = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
        withData: true,
      );
      if (resultRegister != null) {
        pickedFileRegister = resultRegister!.files.first;
        setState(() {
          filenameRegister = pickedFileRegister!.name;
          pickedImageBytes = pickedFileRegister!.bytes;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(21, 33, 39, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(0, 173, 171, 1),
        elevation: 5,
        shadowColor: Colors.black,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 300, vertical: 20),
        child: ListView(
          children: [
            Text(
              'Register an account',
              style: TextStyle(color: Colors.white, fontSize: 28),
            ),
            SizedBox(height: 3),
            Text(
              'Sign up to interact with the DALI community',
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
            SizedBox(height: 10),
            Text(
              'Dartmouth Email',
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),
            SizedBox(height: 5),
            TextFieldEmptyInside(
              hint: 'email@dartmouth.edu',
              controller: _emailController,
            ),
            SizedBox(height: 10),
            Text(
              'Password',
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),
            SizedBox(height: 5),
            TextFieldEmptyInside(
              hint: 'Password',
              controller: _passwordController,
              obscureText: true,
            ),
            SizedBox(height: 10),
            Text(
              'First Name and Last Name',
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),
            SizedBox(height: 5),
            TextFieldEmptyInside(
              hint: 'First Name and Last Name',
              controller: _nameController,
            ),
            SizedBox(height: 10),
            Text(
              'What roles do you have?',
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 5),
            InlineChoice.multiple(
              clearable: true,
              value: selectedRoles.toList(),
              itemCount: role_choices.length,
              onChanged: (values) {
                setState(() {
                  selectedRoles.clear();
                  selectedRoles.addAll(values.cast<String>());
                });
              },
              itemBuilder: (state, i) {
                return ChoiceChip(
                  selected: state.selected(role_choices[i]),
                  onSelected: state.onSelected(role_choices[i]),
                  label: Text(role_choices[i]),
                );
              },
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Column(
                    children: [
                      Text(
                        'Major or Majors',
                        style: TextStyle(color: Colors.white),
                      ),
                      TextFieldEmptyInside(
                        hint: 'Major or Majors',
                        controller: _majorController,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 10),
                Flexible(
                  child: Column(
                    children: [
                      Text(
                        'Minor or Minors',
                        style: TextStyle(color: Colors.white),
                      ),
                      TextFieldEmptyInside(
                        hint: 'Minor or Minors',
                        controller: _minorController,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 10),
                Flexible(
                  child: Column(
                    children: [
                      Text('Class Year', style: TextStyle(color: Colors.white)),
                      TextFieldEmptyInside(
                        hint: 'Class Year',
                        controller: _classYearController,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Flexible(
                  child: Column(
                    children: [
                      Text(
                        textAlign: TextAlign.center,
                        'Birthday',
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                      SizedBox(width: 10),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(width: 1, color: Colors.white30),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15.0,
                            vertical: 5,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                displayDate,
                                style: TextStyle(color: Colors.white30),
                              ),
                              SizedBox(width: 5),
                              TextButton(
                                onPressed: () async {
                                  date = await showDatePicker(
                                    context: context,
                                    firstDate: DateTime(1940),
                                    lastDate: DateTime(2026),
                                  );
                                  if (date != null) {
                                    setState(() {
                                      displayDate =
                                          '${date?.month}/${date?.day}/${date?.year}';
                                    });
                                  }
                                },
                                child: Icon(
                                  Icons.calendar_month_outlined,
                                  size: 20,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 10),
                Flexible(
                  child: Column(
                    children: [
                      Text('Home', style: TextStyle(color: Colors.white)),
                      TextFieldEmptyInside(
                        hint: 'Hanover, NH',
                        controller: _homeController,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Column(
                    children: [
                      Text(
                        'Top 1 Favorite Thing',
                        style: TextStyle(color: Colors.white),
                      ),
                      TextFieldEmptyInside(
                        hint: 'Clouds',
                        controller: _fav1Controller,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 10),
                Flexible(
                  child: Column(
                    children: [
                      Text(
                        'Top 2 Favorite Thing',
                        style: TextStyle(color: Colors.white),
                      ),
                      TextFieldEmptyInside(
                        hint: 'Trees',
                        controller: _fav2Controller,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 10),
                Flexible(
                  child: Column(
                    children: [
                      Text(
                        'Top 3 Favorite Thing',
                        style: TextStyle(color: Colors.white),
                      ),
                      TextFieldEmptyInside(
                        hint: 'Flowers',
                        controller: _fav3Controller,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Flexible(
                  child: Column(
                    children: [
                      Text(
                        'Quote',
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                      SizedBox(height: 5),
                      TextFieldEmptyInside(
                        hint: 'Quote',
                        controller: _quoteController,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 10),
                Flexible(
                  child: Column(
                    children: [
                      Text(
                        'Fun Fact',
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                      SizedBox(height: 5),
                      TextFieldEmptyInside(
                        hint: 'Fun Fact',
                        controller: _funFactController,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(
              'Favorite Dartmouth Tradition',
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 5),
            TextFieldEmptyInside(
              hint: 'Green Key',
              controller: _traditionController,
            ),
            SizedBox(height: 10),
            Text('Profile Picture', style: TextStyle(color: Colors.white)),
            SizedBox(height: 5),
            TextButton(
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  side: BorderSide(color: Color.fromRGBO(0, 173, 171, 1)),
                ),
              ),
              onPressed: () {
                PickFile();
              },
              child: Text(
                'Select File',
                style: TextStyle(
                  fontFamily: 'Ubuntu',
                  color: Color.fromRGBO(0, 173, 171, 1),
                ),
              ),
            ),
            Text(
              filenameRegister,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 10),
            ),
            SizedBox(height: 30),
            TextButton(
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                backgroundColor: Color.fromRGBO(0, 173, 171, 1),
              ),
              onPressed: _isSubmitting ? null : _submit,
              child: Text(
                'Submit',
                style: TextStyle(fontFamily: 'Ubuntu', color: Colors.white),
              ),
            ),
            SizedBox(height: 5),
            TextButton(
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                backgroundColor: Color.fromRGBO(0, 173, 171, 1),
              ),
              onPressed: () {
                Navigator.pushNamed(context, WelcomeScreen.route);
              },
              child: Text(
                'I already have an account',
                style: TextStyle(fontFamily: 'Ubuntu', color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
