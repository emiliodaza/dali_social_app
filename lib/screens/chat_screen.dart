import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:untitled/constants.dart';
import 'package:untitled/screens/profile_screen.dart';
import 'package:untitled/screens/search_chat_screen.dart';
import 'package:untitled/widgets.dart';
import 'home_screen.dart';

class ChatScreen extends StatefulWidget {
  static final String route = "chat_screen";
  final String otherUid;
  const ChatScreen({super.key, required this.otherUid});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _db = FirebaseFirestore.instance;
  final _msgController = TextEditingController();

  static String chatIdFor(String a, String b) {
    final pair = [a, b]..sort();
    return '${pair[0]}_${pair[1]}';
  }

  String get myUid => FirebaseAuth.instance.currentUser!.uid;

  late final String chatId = chatIdFor(myUid, widget.otherUid);

  DocumentReference<Map<String, dynamic>> get chatRef =>
      _db.collection('chats').doc(chatId);

  CollectionReference<Map<String, dynamic>> get messagesRef =>
      chatRef.collection('messages');

  Future<void> _ensureChatExists() async {
    final snap = await chatRef.get();
    if (snap.exists) return;

    await chatRef.set({
      'participants': [myUid, widget.otherUid],
      'updatedAt': FieldValue.serverTimestamp(),
      'lastMessage': '',
      'lastSenderId': '',
    });
  }

  Future<void> _sendMessage() async {
    final text = _msgController.text.trim();
    if (text.isEmpty) return;
    _msgController.clear();

    await messagesRef.add({
      'senderId': myUid,
      'text': text,
      'createdAt': FieldValue.serverTimestamp(),
    });

    await chatRef.update({
      'updatedAt': FieldValue.serverTimestamp(),
      'lastMessage': text,
      'lastSenderId': myUid,
    });
  }

  @override
  void dispose() {
    _msgController.dispose;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: kTopContainer,
            border: Border.all(color: kDaliGreen),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 21,
                              backgroundColor: Colors.white,
                              child: CircleAvatar(
                                radius: 20,
                                backgroundImage: AssetImage(
                                  'images/devon_profile.jpg',
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            Text(
                              'Devon Starr',
                              style: kTextWhite.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Spacer(),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: daliButtonWidget(
                                text: 'Home',
                                route: HomeScreen.route,
                              ),
                            ),
                            TextButton(
                              style: TextButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10.0),
                                  ),
                                ),
                                backgroundColor: Colors.white,
                              ),
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  ProfileScreen.route,
                                  arguments: widget.otherUid,
                                );
                              },
                              child: Text(
                                'Profile',
                                style: TextStyle(
                                  fontFamily: 'Ubuntu',
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Divider(color: kDaliGreen),
                    Flexible(
                      child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                        stream: messagesRef
                            .orderBy('createdAt', descending: true)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Center(
                              child: Text(
                                'Error: ${snapshot.error}',
                                style: kTextWhite,
                              ),
                            );
                          }
                          if (!snapshot.hasData) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          final docs = snapshot.data?.docs;

                          if (docs!.isEmpty) {
                            return Center(
                              child: Text('No messages yet', style: kTextWhite),
                            );
                          }
                          return ListView.builder(
                            reverse: true,
                            itemCount: docs.length,
                            itemBuilder: (context, i) {
                              final data = docs[i].data();
                              final text = (data['text'] ?? '').toString();
                              final senderId = (data['senderId'] ?? '')
                                  .toString();
                              final isMe = senderId == myUid;
                              return Align(
                                alignment: isMe
                                    ? Alignment.centerRight
                                    : Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 8,
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20),
                                        bottomLeft: isMe
                                            ? Radius.circular(20)
                                            : Radius.zero,
                                        bottomRight: isMe
                                            ? Radius.zero
                                            : Radius.circular(20),
                                      ),
                                      color: isMe
                                          ? kTopContainer
                                          : Colors.transparent,
                                      border: isMe
                                          ? null
                                          : Border.all(color: kTopContainer),
                                    ),
                                    padding: const EdgeInsets.all(10),
                                    child: Text(text, style: kTextWhite),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                    Row(
                      children: [
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFieldEmptyInside(hint: 'Type a message'),
                          ),
                        ),
                        TextButton(
                          onPressed: _sendMessage,
                          child: CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.white,
                            child: Icon(Icons.send, color: Colors.black),
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
      ),
    );
  }
}
