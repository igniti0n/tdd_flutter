// @dart=2.9

import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../../../../../lib/core/error/exceptions.dart';
import '../../../../../lib/features/number_trivia/data/datasources/local_data_source.dart';
import '../../../../../lib/features/number_trivia/data/models/number_trivia_model.dart';
import '../../../../fixtures/fixture_parser.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  MockSharedPreferences mockSharedPreferences;
  LocalDataSourceImpl dataSource;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = LocalDataSourceImpl(mockSharedPreferences);
  });
  final String tJsonString = parseFixture('trivia_cashed.json');
  final NumberTriviaModel triviaModel =
      NumberTriviaModel.fomJson(json.decode(tJsonString));
  test('should return cashed NUmberTrivia form shared preferences', () async {
    //arrange
    when(mockSharedPreferences.getString(cashedNumberTriviaKey))
        .thenReturn(tJsonString);
    //act
    final result = await dataSource.getNumberTrivia();
    //assert
    expect(result, triviaModel);
  });

  test(
      'should throw CasheException when getting String form shared preferences and no String is saved',
      () {
    //arrange
    when(mockSharedPreferences.getString(cashedNumberTriviaKey))
        .thenReturn(null);
    //act
    final call = dataSource.getNumberTrivia;
    //assert
    expect(() => call(), throwsA(isInstanceOf<CasheException>()));
  });

  final NumberTriviaModel testModel = NumberTriviaModel('text', 4);

  test('should cashe number trivia', () {
    //act
    dataSource.casheNumberTrivia(testModel);
    //assert
    final testString = json.encode(testModel.toJson());

    verify(mockSharedPreferences.setString(cashedNumberTriviaKey, testString))
        .called(1);
  });
}
