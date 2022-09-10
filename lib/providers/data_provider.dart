import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:word_app/services/api_services.dart';

import '../model/word/word.dart';

final wordDataProvider = FutureProvider<Word>((ref) async {
  return ref.watch(wordProvider).setWord();
});
