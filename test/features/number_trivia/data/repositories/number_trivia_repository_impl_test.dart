// @dart=2.9
import 'dart:math';

import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdd/core/error/exceptions.dart';
import 'package:tdd/core/error/failure.dart';
import 'package:tdd/core/platform/network_info.dart';
import 'package:tdd/features/number_trivia/data/datasources/local_data_source.dart';
import 'package:tdd/features/number_trivia/data/datasources/network_data_source.dart';
import 'package:tdd/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:tdd/features/number_trivia/data/repositories/number_trivia_repositroy_impl.dart';
import 'package:tdd/features/number_trivia/domain/enteties/number_trivia.dart';

class MockLocalDataSource extends Mock implements LocalDataSource {}

class MockNetworkDataSource extends Mock implements NetworkDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  MockLocalDataSource mockLocalDataSource;
  MockNetworkDataSource mockNetworkDataSource;
  MockNetworkInfo mockNetworkInfo;
  NumberTriviaRepositoryImplementation numberTriviaRepositoryImplementation;

  setUp(() {
    mockNetworkInfo = MockNetworkInfo();
    mockNetworkDataSource = MockNetworkDataSource();
    mockLocalDataSource = MockLocalDataSource();
    numberTriviaRepositoryImplementation = NumberTriviaRepositoryImplementation(
      networkInfo: mockNetworkInfo,
      networkDataSource: mockNetworkDataSource,
      localDataSource: mockLocalDataSource,
    );
  });

  group('concrete number trivia tests', () {
    final tNumber = 4;
    final tNumberTriviaModel = NumberTriviaModel('text', tNumber);
    final NumberTrivia tNumberTrivia = tNumberTriviaModel;
    test(
      'should check device connection when getting concrete number trivia',
      () async {
        // arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        // act
        await numberTriviaRepositoryImplementation
            .getConcreteNumberTrivia(tNumber);
        // assert
        verify(mockNetworkInfo.isConnected).called(1);
      },
    );

    group('getting data online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected)
            .thenAnswer((realInvocation) async => true);
      });
      test(
        'should return concrete NumberTrivia on succesfull data retrival ans cashe it',
        () async {
          // arrange
          when(mockNetworkDataSource.getConcreteNumberTrivia(tNumber))
              .thenAnswer((_) async => tNumberTriviaModel);
          // act

          final _result = await numberTriviaRepositoryImplementation
              .getConcreteNumberTrivia(tNumber);

          // assert
          expect(_result, equals(Right(tNumberTrivia)));
          verify(mockNetworkDataSource.getConcreteNumberTrivia(tNumber))
              .called(1);
          verifyNoMoreInteractions(mockNetworkDataSource);
          verify(mockLocalDataSource.casheNumberTrivia(tNumberTriviaModel))
              .called(1);
          verifyNoMoreInteractions(mockLocalDataSource);
        },
      );

      test(
        'should return ServerFailure on unsuccesfull data retrival',
        () async {
          // arrange
          when(mockNetworkDataSource.getConcreteNumberTrivia(any))
              .thenThrow(ServerException());
          // act

          final _result = await numberTriviaRepositoryImplementation
              .getConcreteNumberTrivia(tNumber);

          // assert
          expect(_result, equals(Left(ServerFailure())));
          verify(mockNetworkDataSource.getConcreteNumberTrivia(tNumber))
              .called(1);
          verifyNoMoreInteractions(mockNetworkDataSource);
          verifyZeroInteractions(mockLocalDataSource);
        },
      );
    });

    group('getting data offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected)
            .thenAnswer((realInvocation) async => false);
      });
      test(
        'should return last NumberTrivia on succesfull data retrival',
        () async {
          // arrange
          when(mockLocalDataSource.getNumberTrivia())
              .thenAnswer((_) async => tNumberTriviaModel);
          // act

          final _result = await numberTriviaRepositoryImplementation
              .getConcreteNumberTrivia(tNumber);

          // assert
          expect(_result, equals(Right(tNumberTrivia)));
          verify(mockLocalDataSource.getNumberTrivia()).called(1);
          verifyNoMoreInteractions(mockLocalDataSource);
          verifyZeroInteractions(mockNetworkDataSource);
        },
      );

      test(
        'should return CasheException on  unsuccesfull data retrival',
        () async {
          // arrange
          when(mockLocalDataSource.getNumberTrivia())
              .thenThrow(CasheException());
          // act

          final _result = await numberTriviaRepositoryImplementation
              .getConcreteNumberTrivia(tNumber);

          // assert
          expect(_result, equals(Left(CasheFailure())));
          verify(mockLocalDataSource.getNumberTrivia()).called(1);
          verifyNoMoreInteractions(mockLocalDataSource);
          verifyZeroInteractions(mockNetworkDataSource);
        },
      );
    });
  });

  group('random number trivia tests', () {
    final tNumberTriviaModel = NumberTriviaModel('text', 4444);
    final NumberTrivia tNumberTrivia = tNumberTriviaModel;
    test(
      'should check device connection when getting random number trivia',
      () async {
        // arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        // act
        await numberTriviaRepositoryImplementation.getRandomNumberTrivia();
        // assert
        verify(mockNetworkInfo.isConnected).called(1);
      },
    );

    group('getting data online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected)
            .thenAnswer((realInvocation) async => true);
      });
      test(
        'should return concrete NumberTrivia on succesfull data retrival ans cashe it',
        () async {
          // arrange
          when(mockNetworkDataSource.getRandomNumberTrivia())
              .thenAnswer((_) async => tNumberTriviaModel);
          // act

          final _result = await numberTriviaRepositoryImplementation
              .getRandomNumberTrivia();

          // assert
          expect(_result, equals(Right(tNumberTrivia)));
          verify(mockNetworkDataSource.getRandomNumberTrivia()).called(1);
          verifyNoMoreInteractions(mockNetworkDataSource);
          verify(mockLocalDataSource.casheNumberTrivia(tNumberTriviaModel))
              .called(1);
          verifyNoMoreInteractions(mockLocalDataSource);
        },
      );

      test(
        'should return ServerFailure on unsuccesfull data retrival',
        () async {
          // arrange
          when(mockNetworkDataSource.getRandomNumberTrivia())
              .thenThrow(ServerException());
          // act

          final _result = await numberTriviaRepositoryImplementation
              .getRandomNumberTrivia();

          // assert
          expect(_result, equals(Left(ServerFailure())));
          verify(mockNetworkDataSource.getRandomNumberTrivia()).called(1);
          verifyNoMoreInteractions(mockNetworkDataSource);
          verifyZeroInteractions(mockLocalDataSource);
        },
      );
    });

    group('getting data offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected)
            .thenAnswer((realInvocation) async => false);
      });
      test(
        'should return last NumberTrivia on succesfull data retrival',
        () async {
          // arrange
          when(mockLocalDataSource.getNumberTrivia())
              .thenAnswer((_) async => tNumberTriviaModel);
          // act

          final _result = await numberTriviaRepositoryImplementation
              .getRandomNumberTrivia();

          // assert
          expect(_result, equals(Right(tNumberTrivia)));
          verify(mockLocalDataSource.getNumberTrivia()).called(1);
          verifyNoMoreInteractions(mockLocalDataSource);
          verifyZeroInteractions(mockNetworkDataSource);
        },
      );

      test(
        'should return CasheException on  unsuccesfull data retrival',
        () async {
          // arrange
          when(mockLocalDataSource.getNumberTrivia())
              .thenThrow(CasheException());
          // act

          final _result = await numberTriviaRepositoryImplementation
              .getRandomNumberTrivia();

          // assert
          expect(_result, equals(Left(CasheFailure())));
          verify(mockLocalDataSource.getNumberTrivia()).called(1);
          verifyNoMoreInteractions(mockLocalDataSource);
          verifyZeroInteractions(mockNetworkDataSource);
        },
      );
    });
  });
}
