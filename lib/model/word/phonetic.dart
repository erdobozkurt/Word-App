import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

@immutable
class Phonetic {
  final String? text;
  final String? audio;
  final String? sourceUrl;

  const Phonetic({this.text, this.audio, this.sourceUrl});

  @override
  String toString() {
    return 'Phonetic(text: $text, audio: $audio, sourceUrl: $sourceUrl)';
  }

  factory Phonetic.fromJson(Map<String, dynamic> json) => Phonetic(
        text: json['text'] as String?,
        audio: json['audio'] as String?,
        sourceUrl: json['sourceUrl'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'text': text,
        'audio': audio,
        'sourceUrl': sourceUrl,
      };

  Phonetic copyWith({
    String? text,
    String? audio,
    String? sourceUrl,
  }) {
    return Phonetic(
      text: text ?? this.text,
      audio: audio ?? this.audio,
      sourceUrl: sourceUrl ?? this.sourceUrl,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! Phonetic) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode => text.hashCode ^ audio.hashCode ^ sourceUrl.hashCode;
}
