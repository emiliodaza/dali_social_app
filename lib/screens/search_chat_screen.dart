import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:untitled/constants.dart';
import 'home_screen.dart';

class SearchChatScreen extends StatefulWidget {
  static final String route = "search_chat_screen";
  const SearchChatScreen({super.key});

  @override
  State<SearchChatScreen> createState() => _SearchChatScreen();
}

class _SearchChatScreen extends State<SearchChatScreen> {
  String searchInput = '';
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
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: kTopContainer,
            border: Border.all(color: kDaliGreen),
          ),
          child: Column(
            children: [
              TextField(
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(hintText: 'Search by name'),
                onChanged: (value) {
                  setState(() {
                    searchInput = value.trim().toLowerCase();
                  });
                },
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: PeopleList(inputSearch: searchInput),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
