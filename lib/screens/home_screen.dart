import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:untitled/screens/profile_screen.dart";
import "package:untitled/screens/search_chat_screen.dart";
import "package:untitled/screens/welcome_screen.dart";
import "../constants.dart";
import "../widgets.dart";
import "chat_screen.dart";
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatefulWidget {
  static final String route = "home_screen";
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isMediaSelected = true;
  bool isTextBasedPostSelected = false;
  bool isPeopleSelected = false;
  Widget contentBuilder() {
    if (isMediaSelected) {
      return GridForProfile(crossAxisCounter: 5);
    } else if (isTextBasedPostSelected) {
      return Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.all(Radius.circular(10)),
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
                borderRadius: BorderRadius.all(Radius.circular(10)),
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
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Text(
                'Hello this is the third text',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(20),
        child: PeopleList(inputSearch: ''),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Row(
        children: [
          Container(
            width: 200,
            color: Color.fromRGBO(61, 79, 92, 0.3),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'DALI SOCIAL',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontFamily: 'Ubuntu'),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, SearchChatScreen.route);
                  },
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(Icons.search, color: Colors.white),
                          SizedBox(width: 5),
                          Text(
                            'Search',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Ubuntu',
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, ChatScreen.route);
                  },
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(Icons.message_outlined, color: Colors.white),
                          SizedBox(width: 5),
                          Text(
                            'Messages',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Ubuntu',
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {
                    final uid = FirebaseAuth.instance.currentUser?.uid;
                    if (uid == null) {
                      Navigator.pushReplacementNamed(
                        context,
                        WelcomeScreen.route,
                      );
                      return;
                    }
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProfileScreen(userId: uid),
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(Icons.person, color: Colors.white),
                          SizedBox(width: 5),
                          Text(
                            'Profile',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Ubuntu',
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    if (!context.mounted) return;
                    Navigator.pushReplacementNamed(
                      context,
                      WelcomeScreen.route,
                    );
                  },
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(Icons.exit_to_app, color: Colors.white),
                          SizedBox(width: 5),
                          Text(
                            'Log Out',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Ubuntu',
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ],
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
                            isPeopleSelected = false;
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
                            fontFamily: 'Ubuntu',
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
                            isPeopleSelected = false;
                          });
                        },
                        child: Text(
                          'Text-Based Posts',
                          style: TextStyle(
                            color: isTextBasedPostSelected
                                ? Color.fromRGBO(0, 173, 171, 1)
                                : Colors.white,
                            fontFamily: 'Ubuntu',
                          ),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            width: 1,
                            color: isPeopleSelected
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
                            isPeopleSelected = true;
                            isTextBasedPostSelected = false;
                            isMediaSelected = false;
                          });
                        },
                        child: Text(
                          'People',
                          style: TextStyle(
                            color: isPeopleSelected
                                ? Color.fromRGBO(0, 173, 171, 1)
                                : Colors.white,
                            fontFamily: 'Ubuntu',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Flexible(child: contentBuilder()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PeopleList extends StatelessWidget {
  final String inputSearch;
  const PeopleList({super.key, required this.inputSearch});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text(
              'Error: ${snapshot.error}',
              style: TextStyle(color: Colors.white),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final allDocs = snapshot.data?.docs ?? [];

          final filteredDocs = inputSearch.isEmpty
              ? allDocs
              : allDocs.where((doc) {
                  final dataOfDoc = doc.data() as Map<String, dynamic>;
                  final name = dataOfDoc['name'].toString().toLowerCase();
                  return name.contains(inputSearch);
                }).toList();

          if (filteredDocs.isEmpty) {
            return Text(
              'No users found',
              style: TextStyle(color: Colors.white),
            );
          }
          return ListView.separated(
            itemBuilder: (context, index) {
              final data = filteredDocs[index].data() as Map<String, dynamic>;
              final String name = data['name'] ?? 'Unknown';
              final String major = data['major'] ?? '-';
              final String year = data['year'] ?? '-';
              final String? pictureUrl = data['picture']?.toString();
              return MemberCard(
                name: name,
                major: major,
                year: year,
                pictureUrl: pictureUrl,
                userId: filteredDocs[index].id,
              );
            },
            separatorBuilder: (context, index) => SizedBox(height: 8),
            itemCount: filteredDocs.length,
          );
        },
      ),
    );
  }
}

class ProfileImage extends StatelessWidget {
  final String? pictureUrl;
  const ProfileImage({super.key, required this.pictureUrl});

  @override
  Widget build(BuildContext context) {
    final bool hasUrl = pictureUrl != null && pictureUrl!.trim().isNotEmpty;
    if (!hasUrl) {
      return Image.asset('images/default_profile.jpg', fit: BoxFit.cover);
    }
    return Image.network(
      pictureUrl!,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Image.asset('images/default_profile.jpg', fit: BoxFit.cover);
      },
    );
  }
}

class MemberCard extends StatelessWidget {
  final String name;
  final String major;
  final String year;
  final String? pictureUrl;
  final String userId;
  const MemberCard({
    super.key,
    required this.name,
    required this.major,
    required this.year,
    required this.pictureUrl,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Container(
        padding: EdgeInsets.all(8),
        child: Row(
          children: [
            CircleAvatar(
              radius: 26,
              backgroundColor: Colors.white,
              child: ClipOval(
                child: SizedBox(
                  width: 50,
                  height: 50,
                  child: ProfileImage(pictureUrl: pictureUrl),
                ),
              ),
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: kTextWhite.copyWith(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Ubuntu',
                  ),
                ),
                Text(
                  'Majors: $major',
                  style: kTextWhite.copyWith(
                    fontFamily: 'Ubuntu',
                    fontSize: 10,
                  ),
                ),
                Text(
                  'Year: $year',
                  style: kTextWhite.copyWith(
                    fontFamily: 'Ubuntu',
                    fontSize: 10,
                  ),
                ),
              ],
            ),
            Spacer(),
            TextButton(
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                backgroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  ProfileScreen.route,
                  arguments: userId,
                );
              },
              child: Text(
                'Profile',
                style: TextStyle(fontFamily: 'Ubuntu', color: Colors.black),
              ),
            ),
            SizedBox(width: 5),
            TextButton(
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                backgroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  ChatScreen.route,
                  arguments: userId,
                );
              },
              child: Icon(Icons.chat_outlined, color: Colors.black),
            ),
            SizedBox(width: 5),
            TextButton(
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                backgroundColor: Colors.white,
              ),
              onPressed: () {},
              child: Text(
                'Follow',
                style: TextStyle(fontFamily: 'Ubuntu', color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
