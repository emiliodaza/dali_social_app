import 'package:flutter/material.dart';
import 'package:untitled/constants.dart';
import 'package:untitled/screens/profile_screen.dart';
import 'package:untitled/widgets.dart';

class PostTextScreen extends StatefulWidget {
  static final String route = "post_text_screen";
  const PostTextScreen({super.key});

  @override
  State<PostTextScreen> createState() => _PostTextScreen();
}

class _PostTextScreen extends State<PostTextScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(0, 173, 171, 1),
        elevation: 5,
        shadowColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
        child: Container(
          width: 1000,
          height: 500,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: kTopContainer,
            border: Border.all(color: kDaliGreen),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    maxLines: null,
                    expands: true,
                    textAlign: TextAlign.start,
                    decoration: InputDecoration(hintText: 'Type your post'),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: daliButtonWidget(
                  text: 'Submit',
                  route: ProfileScreen.route,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
