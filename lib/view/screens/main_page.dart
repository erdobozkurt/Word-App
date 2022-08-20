import 'dart:convert';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:word_app/model/word/word.dart';
import 'package:word_app/view/screens/list_page.dart';
import 'package:http/http.dart' as http;
import 'package:english_words/english_words.dart';

import 'login_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);
  static const routeName = 'mainPage';

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late Future<Word> futureWord;
  final audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();

    futureWord = setWord();
  }

  String word = '';

  bool isSaved = false;

  String description = "";

  String wordInfo = '';

  final _auth = FirebaseAuth.instance;

  Future<http.Response> fetchWords(String word) {
    return http.get(
        Uri.parse('https://api.dictionaryapi.dev/api/v2/entries/en/$word'));
  }

  fetchAudio() async {
    final apiCallUri =
        'https://api.dictionaryapi.dev/media/pronunciations/en/$word-us.mp3';

    await audioPlayer.play(UrlSource(apiCallUri));
  }

  Future<Word> setWord() async {
    /* isLoading = true; */
    int randomNumber = Random().nextInt(nouns.length);
    String requestWord = nouns[randomNumber];
    http.Response wordsFromApi = await fetchWords(requestWord);

    if (wordsFromApi.statusCode == 200) {
      List<dynamic> dataList = jsonDecode(wordsFromApi.body);

      return Word.fromJson(dataList[0]);

      /* description =
          Word.fromJson(dataList[0]).meanings![0].definitions![0].definition!;
      wordInfo = Word.fromJson(dataList[0]).meanings![0].partOfSpeech!; */
    } else {
      throw Exception('Failed to load data');

    }

    /* word = jsonDecode(wordsFromApi.body)[0]["word"];
    String? descriptionData = jsonDecode(wordsFromApi.body)[0]["meanings"][0]
        ["definitions"][0]["definition"];

    if (descriptionData != null) {
      description = descriptionData;
    } else {
      description = "";
    } */

    /* isLoading = false;
    setState(() {}); */
  }

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
                } else if (value == 2) {
                  signOut();
                  Navigator.pushReplacementNamed(context, LoginPage.routeName);
                }
              },
              itemBuilder: ((context) => [
                    const PopupMenuItem(
                      value: 1,
                      child: Text('Favorite words'),
                    ),
                    const PopupMenuItem(
                      value: 2,
                      child: Text('Sign out'),
                    )
                  ]))
        ],
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
                                onPressed: fetchAudio,
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
                              futureWord = setWord();
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

void signOut() async {
  await FirebaseAuth.instance.signOut();
}
