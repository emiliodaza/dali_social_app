import 'package:flutter/material.dart';
import 'constants.dart';

class TextFieldEmptyInside extends StatelessWidget {
  final String hint;
  final TextEditingController? controller;
  final bool obscureText;
  const TextFieldEmptyInside({
    super.key,
    required this.hint,
    this.controller,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      style: TextStyle(color: Colors.white, fontFamily: 'Ubuntu'),
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white30),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        hintText: hint,
      ),
    );
  }
}

class GridForProfile extends StatelessWidget {
  final int crossAxisCounter;
  const GridForProfile({super.key, required this.crossAxisCounter});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      primary: false,
      padding: EdgeInsets.all(20),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      crossAxisCount: crossAxisCounter,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ),
      ],
    );
  }
}

class Tag extends StatelessWidget {
  final String tagName;
  final Color color;
  const Tag({super.key, required this.tagName, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 1),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: Text(tagName, style: TextStyle(color: Colors.white)),
    );
  }
}

class daliButtonWidgetForLogin extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const daliButtonWidgetForLogin({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        backgroundColor: Color.fromRGBO(0, 173, 171, 1),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(fontFamily: 'Ubuntu', color: Colors.white),
      ),
    );
  }
}

class daliButtonWidget extends StatelessWidget {
  final String text;
  final String route;
  const daliButtonWidget({super.key, required this.text, required this.route});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        backgroundColor: Color.fromRGBO(0, 173, 171, 1),
      ),
      onPressed: () {
        Navigator.pushNamed(context, route);
      },
      child: Text(
        text,
        style: TextStyle(fontFamily: 'Ubuntu', color: Colors.white),
      ),
    );
  }
}

class chatBox extends StatelessWidget {
  final String imgPath;
  final String name;
  final String lastMessage;
  const chatBox({
    super.key,
    required this.imgPath,
    required this.lastMessage,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextButton(
        onPressed: () {},
        child: Row(
          children: [
            CircleAvatar(
              radius: 21,
              backgroundColor: Colors.white,
              child: CircleAvatar(
                radius: 20,
                backgroundImage: AssetImage(imgPath),
              ),
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: kTextWhite.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(lastMessage, style: kTextWhite),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
