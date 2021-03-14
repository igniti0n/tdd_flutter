import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tdd/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:tdd/features/number_trivia/domain/enteties/number_trivia.dart';
import 'dart:convert';

import '../../../../fixtures/fixture_parser.dart';

void main() {
  NumberTriviaModel numberTriviaModel = NumberTriviaModel('test text', 1);

  test("should be a NumberTrivia entity", () {
    expect(numberTriviaModel, isA<NumberTrivia>());
  });

  group('from JSON', () {
    test('should return NumberTrivia entity when given integer in JSON string',
        () {
      final Map<String, dynamic> jsonMap =
          json.decode(parseFixture('trivia_integer.json'));

      final result = NumberTriviaModel.fomJson(jsonMap);
      expect(result, equals(numberTriviaModel));
    });

    test('should return NumberTrivia entity when given double in JSON string',
        () {
      final Map<String, dynamic> jsonMap =
          json.decode(parseFixture('trivia_double.json'));

      final result = NumberTriviaModel.fomJson(jsonMap);
      expect(result, equals(numberTriviaModel));
    });
  });

  group('to JSON', () {
    test('should return appropriate JSON', () {
      final Map<String, dynamic> representingMap = {
        'text': 'test text',
        'number': 1,
      };

      final result = NumberTriviaModel.toJson(numberTriviaModel);

      expect(result, equals(representingMap));
    });
  });
}
