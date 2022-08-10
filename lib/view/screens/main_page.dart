import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:word_app/view/screens/list_page.dart';
import 'package:http/http.dart' as http;
import 'package:english_words/english_words.dart';


class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);
  static const routeName = 'mainPage';

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  void initState() {
    super.initState();
    setWord();
  }

  String word = '';

  String description = "";

  String wordInfo = '';

  bool isSaved = false;

  bool isLoading = true;

  Future<http.Response> fetchWords(String word) {
    return http.get(
        Uri.parse('https://api.dictionaryapi.dev/api/v2/entries/en/$word'));
  }

  setWord() async {
    isLoading = true;
    int randomNumber = Random().nextInt(nouns.length);
    String requestWord = nouns[randomNumber];
    http.Response words = await fetchWords(requestWord);
    word = jsonDecode(words.body)[0]["word"];
    String? descriptionData = jsonDecode(words.body)[0]["phonetic"];
    if (descriptionData != null) {
      description = descriptionData;
    } else {
      description = "";
    }

    isLoading = false;
    setState(() {});

    /* print(jsonDecode(words.body)[0]); */
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
                }
              },
              itemBuilder: ((context) => [
                    const PopupMenuItem(
                      value: 1,
                      child: Text('Favorite words'),
                    )
                  ]))
        ],
      ),
      body: Card(
        margin: const EdgeInsets.all(12),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: isLoading
                ? const CircularProgressIndicator.adaptive()
                : Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          onPressed: () {
                            isSaved = !isSaved;
                            setState(() {});
                          },
                          icon: Icon(isSaved ? Icons.star : Icons.star_border),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(word),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.volume_up_sharp),
                          )
                        ],
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(wordInfo),
                      ),
                      Text(
                        description,
                        textAlign: TextAlign.center,
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: IconButton(
                          onPressed: () {
                            setWord();
                          },
                          icon: const Icon(Icons.arrow_right_alt),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
