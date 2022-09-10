import 'dart:convert';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:word_app/model/word/word.dart';
import 'package:word_app/services/api_services.dart';
import 'package:word_app/services/auth_methods.dart';
import 'package:word_app/view/screens/list_page.dart';


class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);
  static const routeName = 'mainPage';

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late Future<Word> futureWord;
  final audioPlayer = AudioPlayer();
  final AuthMethods authMethods = AuthMethods();
  final ApiServices apiServices = ApiServices();

  @override
  void initState() {
    super.initState();

    futureWord = apiServices.setWord();
  }

  String word = '';

  bool isSaved = false;

  String description = "";

  String wordInfo = '';

  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Word App'),
        actions: [
          PopupMenuButton(
              onSelected: (value) {
                if (value == 1) {
                  Navigator.pushNamed(context, ListPage.routeName);
                }
              },
              itemBuilder: ((context) => [
                    const PopupMenuItem(
                      value: 1,
                      child: Text('Favorite Words'),
                    )
                  ]))
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: Center(
                child: Column(
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    const CircleAvatar(
                      radius: 40,
                      backgroundImage:
                          NetworkImage('https://picsum.photos/200'),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Erdoğan'),
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              title: const Text('Sign out'),
              onTap: () {
                authMethods.signOut(context);
              },
            )
          ],
        ),
      ),
      body: FutureBuilder<Word>(
          future: futureWord,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              margin: const EdgeInsets.all(12),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          onPressed: addFavs,
                          icon: Icon(isSaved ? Icons.star : Icons.star_border),
                          iconSize: 32,
                        ),
                      ),
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                word = snapshot.data!.word!,
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              IconButton(
                                onPressed: (){
                                  apiServices.fetchAudio(word);
                                },
                                icon: const Icon(Icons.volume_up_sharp),
                              ),
                            ],
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              snapshot.data!.meanings![0].partOfSpeech!,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        description = snapshot
                            .data!.meanings![0].definitions![0].definition!,
                        style: Theme.of(context).textTheme.titleMedium,
                        textAlign: TextAlign.center,
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: IconButton(
                          onPressed: () {
                            setState(() {
                              futureWord = apiServices.setWord();
                              isSaved = false;
                            });
                          },
                          icon: const Icon(Icons.arrow_right_alt),
                          iconSize: 40,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }

  Future addFavs() async {
    isSaved = !isSaved;
    setState(() {});
    User? user = _auth.currentUser;

    final docWord =
        FirebaseFirestore.instance.collection(user!.email.toString()).doc();

    return docWord.set({'word': word, 'definition': description});
  }
}
