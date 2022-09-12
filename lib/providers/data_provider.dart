import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:word_app/services/api_services.dart';

import '../model/word/word.dart';

final wordDataProvider = FutureProvider<Word>((ref) async {
  return ref.watch(wordProvider).setWord();
});

final audioDataProvider = FutureProvider<Response>((ref) async {
   return ref.watch(wordProvider).fetchAudio();
});





