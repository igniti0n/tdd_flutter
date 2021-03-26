import 'dart:math';

import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tdd/core/error/exceptions.dart';
import 'package:tdd/features/number_trivia/data/datasources/network_data_source.dart';
import 'package:tdd/features/number_trivia/data/models/number_trivia_model.dart';

import '../../../../fixtures/fixture_parser.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  late MockHttpClient mockHttpClient;
  late NetworkDataSourceImpl networkDataSourceImpl;

  final int tNumber = 4;
  final NumberTriviaModel tModel = NumberTriviaModel.fomJson(
      json.decode(parseFixture('trivia_integer.json')));

  void setUpMockedHttpResponse(int responseCode) {
    when(mockHttpClient.get(Uri(path: 'http://numbersapi.com/$tNumber'),
            headers: anyNamed('headers')))
        .thenAnswer((realInvocation) async =>
            http.Response(parseFixture('trivia_integer.json'), responseCode));

    when(mockHttpClient.get(Uri(path: 'http://numbersapi.com/random'),
            headers: anyNamed('headers')))
        .thenAnswer((realInvocation) async =>
            http.Response(parseFixture('trivia_integer.json'), responseCode));
  }

  setUp(() {
    mockHttpClient = MockHttpClient();
    networkDataSourceImpl = NetworkDataSourceImpl(mockHttpClient);
  });

  group('concrete number', () {
    test('should pass in proper parameters to http Client in body and headers',
        () {
//arrange
      setUpMockedHttpResponse(200);
      //act
      networkDataSourceImpl.getConcreteNumberTrivia(tNumber);
      //assert
      verify(mockHttpClient.get(
        Uri(path: 'http://numbersapi.com/$tNumber'),
        headers: {'Content-Type': 'application/json'},
      ));
    });

    test('should return proper NumberTriviaModel from recieved string',
        () async {
//arrange

      setUpMockedHttpResponse(200);
      //act
      final response =
          await networkDataSourceImpl.getConcreteNumberTrivia(tNumber);
      //assert
      expect(response, tModel);
      verify(mockHttpClient.get(
        Uri(path: 'http://numbersapi.com/$tNumber'),
        headers: {'Content-Type': 'application/json'},
      )).called(1);
    });

    test(
      'should throw Server exception when fetching data went wrong',
      () async {
        // arrange

        setUpMockedHttpResponse(404);
        // act
        final call = networkDataSourceImpl.getConcreteNumberTrivia;
        // assert
        expect(() => call(4), throwsA(isInstanceOf<ServerException>()));
      },
    );
  });

  group('random number', () {
    test(
      'should pass in appropriate headers to call',
      () async {
        // arrange

        setUpMockedHttpResponse(200);
        // act
        networkDataSourceImpl.getRandomNumberTrivia();
        // assert
        verify(mockHttpClient.get(
          Uri(path: 'http://numbersapi.com/random'),
          headers: {'Content-Type': 'application/json'},
        )).called(1);
      },
    );

    test(
      'should return appropriate NumberTriviaModel',
      () async {
        // arrange

        setUpMockedHttpResponse(200);
        // act
        final result = await networkDataSourceImpl.getRandomNumberTrivia();
        // assert
        expect(result, tModel);
        verify(mockHttpClient.get(
          Uri(path: 'http://numbersapi.com/random'),
          headers: {'Content-Type': 'application/json'},
        )).called(1);
      },
    );

    test(
      'should throw ServerException when response code is not 200',
      () async {
        // arrange

        setUpMockedHttpResponse(500);
        // act
        final call = networkDataSourceImpl.getRandomNumberTrivia;
        // assert
        expect(call, throwsA(isInstanceOf<ServerException>()));
        verify(mockHttpClient.get(
          Uri(path: 'http://numbersapi.com/random'),
          headers: {'Content-Type': 'application/json'},
        )).called(1);
      },
    );
  });
}
