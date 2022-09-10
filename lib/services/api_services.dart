import 'dart:convert';
import 'dart:math';

import 'package:english_words/english_words.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../model/word/word.dart';

class ApiServices {
  Future<http.Response> fetchWords(String word) {
    return http.get(
        Uri.parse('https://api.dictionaryapi.dev/api/v2/entries/en/$word'));
  }

  Future<http.Response> fetchAudio(String word) {
    return http.get(Uri.parse(
        'https://api.dictionaryapi.dev/media/pronunciations/en/$word-us.mp3'));
  }

  Future<Word> setWord() async {
    int randomNumber = Random().nextInt(nouns.length);
    String requestWord = nouns[randomNumber];
    http.Response response = await fetchWords(requestWord);

    if (response.statusCode == 200) {
      final Word word = Word.fromJson(jsonDecode(response.body)[0]);
      return word;
    } else {
      throw Exception('Failed to load data');
    }
  }
}

final Provider wordProvider = Provider<ApiServices>((ref) => ApiServices());
