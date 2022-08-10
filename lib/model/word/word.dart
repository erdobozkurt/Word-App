import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import 'meaning.dart';
import 'phonetic.dart';

@immutable
class Word {
  final String? word;
  final String? phonetic;
  final List<Phonetic>? phonetics;
  final List<Meaning>? meanings;

  const Word({this.word, this.phonetic, this.phonetics, this.meanings});

  @override
  String toString() {
    return 'Word(word: $word, phonetic: $phonetic, phonetics: $phonetics, meanings: $meanings)';
  }

  factory Word.fromJson(Map<String, dynamic> json) => Word(
        word: json['word'] as String?,
        phonetic: json['phonetic'] as String?,
        phonetics: (json['phonetics'] as List<dynamic>?)
            ?.map((e) => Phonetic.fromJson(e as Map<String, dynamic>))
            .toList(),
        meanings: (json['meanings'] as List<dynamic>?)
            ?.map((e) => Meaning.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'word': word,
        'phonetic': phonetic,
        'phonetics': phonetics?.map((e) => e.toJson()).toList(),
        'meanings': meanings?.map((e) => e.toJson()).toList(),
      };

  Word copyWith({
    String? word,
    String? phonetic,
    List<Phonetic>? phonetics,
    List<Meaning>? meanings,
  }) {
    return Word(
      word: word ?? this.word,
      phonetic: phonetic ?? this.phonetic,
      phonetics: phonetics ?? this.phonetics,
      meanings: meanings ?? this.meanings,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! Word) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode =>
      word.hashCode ^
      phonetic.hashCode ^
      phonetics.hashCode ^
      meanings.hashCode;
}
