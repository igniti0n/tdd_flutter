// @dart=2.9

import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tdd/features/number_trivia/data/datasources/network_data_source.dart';
import 'package:tdd/features/number_trivia/data/models/number_trivia_model.dart';

import '../../../../fixtures/fixture_parser.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  MockHttpClient mockHttpClient;
  NetworkDataSourceImpl networkDataSourceImpl;

  setUp(() {
    mockHttpClient = MockHttpClient();
    networkDataSourceImpl = NetworkDataSourceImpl(mockHttpClient);
  });
  final int tNumber = 4;
  test('should pass in proper parameters to http Client in body and headers',
      () {
//arrange
    when(mockHttpClient.get(any, headers: anyNamed('headers'))).thenAnswer(
        (realInvocation) async =>
            http.Response(parseFixture('trivia_integer.json'), 200));
    //act
    networkDataSourceImpl.getConcreteNumberTrivia(tNumber);
    //assert
    verify(mockHttpClient.get(
      Uri(path: 'http://numbersapi.com/$tNumber'),
      headers: {'Content-Type': 'application/json'},
    ));
  });

  test('should return right NumberTriviaModel from recieved string', () async {
    final NumberTriviaModel tModel = NumberTriviaModel.fomJson(
        json.decode(parseFixture('trivia_integer.json')));
//arrange
    when(mockHttpClient.get(any, headers: anyNamed('headers'))).thenAnswer(
        (realInvocation) async =>
            http.Response(parseFixture('trivia_integer.json'), 200));
    //act
    final response =
        await networkDataSourceImpl.getConcreteNumberTrivia(tNumber);
    //assert
    expect(response, tModel);
    verify(mockHttpClient.get(
      Uri(path: 'http://numbersapi.com/$tNumber'),
      headers: {'Content-Type': 'application/json'},
    ));
  });
}
