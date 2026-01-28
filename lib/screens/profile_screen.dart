import "package:cloud_firestore/cloud_firestore.dart";
import "package:file_picker/file_picker.dart";
import "package:flutter/material.dart";
import "package:untitled/screens/home_screen.dart";
import "package:untitled/screens/post_text_screen.dart";

import "../widgets.dart";
import "chat_screen.dart";

class ProfileScreen extends StatefulWidget {
  final String userId;
  static final String route = "profile_screen";
  const ProfileScreen({super.key, required this.userId});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isMediaSelected = true;
  bool isTextBasedPostSelected = false;
  PlatformFile? pickedFilePost;
  FilePickerResult? resultPost;
  String filenamePost = '';

  void PickFilePost() async {
    try {
      resultPost = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );
      if (resultPost != null) {
        pickedFilePost = resultPost!.files.first;
        setState(() {
          filenamePost = resultPost!.files.first.name;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text(
            'Error loading profile: ${snapshot.error}',
            style: TextStyle(color: Colors.white),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return Center(
            child: Text(
              'User not found',
              style: TextStyle(color: Colors.white),
            ),
          );
        }

        final data = snapshot.data!.data();

        if (data == null) {
          return Center(
            child: Text(
              'User data is empty',
              style: TextStyle(color: Colors.white),
            ),
          );
        }
        final tagWidgets = TagWidgetsBuilder(dataForTags: data);
        final String birthday = (data["birthday"] ?? "-").toString();
        final String favoriteDartmouthTradition =
            (data["favorite dartmouth tradition"] ?? '-').toString();
        final String favoriteThing1 = (data["favorite thing 1"] ?? '-')
            .toString();
        final String favoriteThing2 = (data["favorite thing 2"] ?? '-')
            .toString();
        final String favoriteThing3 = (data["favorite thing 3"] ?? '-')
            .toString();
        final String funFact = (data["fun fact"] ?? '-').toString();
        final String home = (data["home"] ?? '').toString();
        final String major = (data["major"] ?? '').toString();
        final String minor = (data["minor"] ?? '').toString();
        final String majorMinor = minor.trim().isEmpty
            ? major
            : '$major & $minor';
        final String name = (data["name"] ?? '-').toString();
        final String? pictureUrl = data["picture"]?.toString();
        final String quote = (data["quote"] ?? '-').toString();
        final String year = (data["year"] ?? '-').toString();
        return Scaffold(
          backgroundColor: Colors.black,
          body: Row(
            children: [
              Container(
                width: 380,
                color: Color.fromRGBO(61, 79, 92, 0.3),
                child: ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: CircleAvatar(
                        radius: 101,
                        backgroundColor: Colors.white,
                        child: ClipOval(
                          child: SizedBox(
                            width: 200,
                            height: 200,
                            child: ProfileImage(pictureUrl: pictureUrl),
                          ),
                        ),
                      ),
                    ),
                    Text(
                      name,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      year,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(height: 5),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: tagWidgets,
                    ),
                    SizedBox(height: 5),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        '🌲 $majorMinor | 🏠 $home | 🎂 $birthday',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                          onPressed: () {},
                          style: ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(
                              Colors.white,
                            ),
                          ),
                          child: Text(
                            'Follow',
                            style: TextStyle(
                              color: Color.fromRGBO(38, 57, 43, 1),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, ChatScreen.route);
                            },
                            style: ButtonStyle(
                              backgroundColor: WidgetStatePropertyAll(
                                Colors.white,
                              ),
                            ),
                            child: Icon(
                              Icons.chat_outlined,
                              color: Color.fromRGBO(38, 57, 43, 1),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 0.5),
                          borderRadius: BorderRadius.all(Radius.circular(6.0)),
                          color: Color.fromRGBO(
                            38,
                            57,
                            43,
                            0.30196078431372547,
                          ),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.0,
                          vertical: 3.0,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Quote',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              '"$quote"',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                color: Colors.white,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Top Favorite Things',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '🥇 $favoriteThing1',
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                '🥈 $favoriteThing2',
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                '🥉 $favoriteThing3',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Top Dartmouth Tradition',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                favoriteDartmouthTradition,
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 0.5),
                          borderRadius: BorderRadius.all(Radius.circular(6.0)),
                          color: Color.fromRGBO(
                            38,
                            57,
                            43,
                            0.30196078431372547,
                          ),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.0,
                          vertical: 3.0,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'Fun Fact',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              textAlign: TextAlign.end,
                              funFact,
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(color: Color.fromRGBO(61, 79, 92, 0.6), width: 2),
              Container(
                width: 870,
                color: Colors.black45,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                width: 1,
                                color: isMediaSelected
                                    ? Color.fromRGBO(0, 173, 171, 1)
                                    : Colors.black,
                              ),
                            ),
                          ),
                          child: TextButton(
                            onPressed: () {
                              setState(() {
                                isMediaSelected = true;
                                isTextBasedPostSelected = false;
                              });
                            },
                            style: ButtonStyle(
                              shape: MaterialStatePropertyAll(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.zero,
                                ),
                              ),
                            ),
                            child: Text(
                              'Pictures',
                              style: TextStyle(
                                color: isMediaSelected
                                    ? Color.fromRGBO(0, 173, 171, 1)
                                    : Colors.white,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                width: 1,
                                color: isTextBasedPostSelected
                                    ? Color.fromRGBO(0, 173, 171, 1)
                                    : Colors.black,
                              ),
                            ),
                          ),
                          child: TextButton(
                            style: ButtonStyle(
                              shape: MaterialStatePropertyAll(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.zero,
                                ),
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                isTextBasedPostSelected = true;
                                isMediaSelected = false;
                              });
                            },
                            child: Text(
                              'Text-Based Posts',
                              style: TextStyle(
                                color: isTextBasedPostSelected
                                    ? Color.fromRGBO(0, 173, 171, 1)
                                    : Colors.white,
                              ),
                            ),
                          ),
                        ),
                        Spacer(),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextButton(
                            style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                              ),
                              backgroundColor: Color.fromRGBO(0, 173, 171, 1),
                            ),
                            onPressed: () {
                              PickFilePost();
                            },
                            child: Text(
                              'Add Picture 📸',
                              style: TextStyle(
                                fontFamily: 'Ubuntu',
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: daliButtonWidget(
                            text: 'Add Text 📝',
                            route: PostTextScreen.route,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: daliButtonWidget(
                            text: 'Home',
                            route: HomeScreen.route,
                          ),
                        ),
                      ],
                    ),
                    Flexible(
                      child: isMediaSelected
                          ? GridForProfile(crossAxisCounter: 5)
                          : Padding(
                              padding: const EdgeInsets.all(20),
                              child: ListView(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.white),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                    ),
                                    child: Text(
                                      'Hello this is some text',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.white),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                    ),
                                    child: Text(
                                      'Hello this is another text',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.white),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                    ),
                                    child: Text(
                                      'Hello this is the third text',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class TagWidgetsBuilder extends StatelessWidget {
  final Map<String, dynamic>? dataForTags;
  const TagWidgetsBuilder({super.key, required this.dataForTags});

  static const Map<String, Color> mapTagColors = {
    'core': Color.fromRGBO(193, 8, 167, 1.0),
    'des': Color.fromRGBO(3, 99, 98, 1.0),
    'dev': Color.fromRGBO(151, 123, 1, 1.0),
    'pm': Color.fromRGBO(3, 83, 163, 1.0),
    'mentor': Color.fromRGBO(182, 93, 84, 1.0),
  };

  @override
  Widget build(BuildContext context) {
    final dataToUse = dataForTags ?? {};
    final tagWidgets = <Widget>[];

    for (final entry in mapTagColors.entries) {
      final key = entry.key;
      final color = entry.value;
      if (dataToUse[key] == true) {
        tagWidgets.add(Tag(tagName: key, color: color));
      }
    }

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 5,
      runSpacing: 5,
      children: tagWidgets.isEmpty
          ? [
              Text(
                'The user has no role tags',
                style: TextStyle(color: Colors.white, fontFamily: 'Ubuntu'),
              ),
            ]
          : tagWidgets,
    );
  }
}
