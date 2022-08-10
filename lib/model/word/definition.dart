import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

@immutable
class Definition {
  final String? definition;
  final List<dynamic>? synonyms;
  final List<dynamic>? antonyms;
  final String? example;

  const Definition({
    this.definition,
    this.synonyms,
    this.antonyms,
    this.example,
  });

  @override
  String toString() {
    return 'Definition(definition: $definition, synonyms: $synonyms, antonyms: $antonyms, example: $example)';
  }

  factory Definition.fromJson(Map<String, dynamic> json) => Definition(
        definition: json['definition'] as String?,
        synonyms: json['synonyms'] as List<dynamic>?,
        antonyms: json['antonyms'] as List<dynamic>?,
        example: json['example'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'definition': definition,
        'synonyms': synonyms,
        'antonyms': antonyms,
        'example': example,
      };

  Definition copyWith({
    String? definition,
    List<dynamic>? synonyms,
    List<dynamic>? antonyms,
    String? example,
  }) {
    return Definition(
      definition: definition ?? this.definition,
      synonyms: synonyms ?? this.synonyms,
      antonyms: antonyms ?? this.antonyms,
      example: example ?? this.example,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! Definition) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode =>
      definition.hashCode ^
      synonyms.hashCode ^
      antonyms.hashCode ^
      example.hashCode;
}
