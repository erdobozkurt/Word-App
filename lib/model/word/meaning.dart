import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import 'definition.dart';

@immutable
class Meaning {
  final String? partOfSpeech;
  final List<Definition>? definitions;
  final List<dynamic>? synonyms;
  final List<dynamic>? antonyms;

  const Meaning({
    this.partOfSpeech,
    this.definitions,
    this.synonyms,
    this.antonyms,
  });

  @override
  String toString() {
    return 'Meaning(partOfSpeech: $partOfSpeech, definitions: $definitions, synonyms: $synonyms, antonyms: $antonyms)';
  }

  factory Meaning.fromJson(Map<String, dynamic> json) => Meaning(
        partOfSpeech: json['partOfSpeech'] as String?,
        definitions: (json['definitions'] as List<dynamic>?)
            ?.map((e) => Definition.fromJson(e as Map<String, dynamic>))
            .toList(),
        synonyms: json['synonyms'] as List<dynamic>?,
        antonyms: json['antonyms'] as List<dynamic>?,
      );

  Map<String, dynamic> toJson() => {
        'partOfSpeech': partOfSpeech,
        'definitions': definitions?.map((e) => e.toJson()).toList(),
        'synonyms': synonyms,
        'antonyms': antonyms,
      };

  Meaning copyWith({
    String? partOfSpeech,
    List<Definition>? definitions,
    List<dynamic>? synonyms,
    List<dynamic>? antonyms,
  }) {
    return Meaning(
      partOfSpeech: partOfSpeech ?? this.partOfSpeech,
      definitions: definitions ?? this.definitions,
      synonyms: synonyms ?? this.synonyms,
      antonyms: antonyms ?? this.antonyms,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! Meaning) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode =>
      partOfSpeech.hashCode ^
      definitions.hashCode ^
      synonyms.hashCode ^
      antonyms.hashCode;
}

