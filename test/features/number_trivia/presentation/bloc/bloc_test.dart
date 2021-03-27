import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tdd/core/error/failure.dart';
import 'package:tdd/core/util/input_converter.dart';
import 'package:tdd/features/number_trivia/domain/enteties/number_trivia.dart';
import 'package:tdd/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:tdd/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:tdd/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';

class MockInputConverter extends Mock implements InputConverter {}

class MockGetConcreteNumberTrivia extends Mock
    implements GetConcreteNumberTrivia {}

class MockGetRandomNumberTrivia extends Mock implements GetRandomNumberTrivia {}

void main() {
  final MockInputConverter mockInputConverter = MockInputConverter();
  final MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia =
      MockGetConcreteNumberTrivia();
  final MockGetRandomNumberTrivia mockGetRandomNumberTrivia =
      MockGetRandomNumberTrivia();
  final NumberTriviaBloc bloc = NumberTriviaBloc(
    getConcreteNumberTrivia: mockGetConcreteNumberTrivia,
    getRandomNumberTrivia: mockGetRandomNumberTrivia,
    inputParser: mockInputConverter,
  );

  final tNumber = 4;
  final tString = "4";
  final NumberTrivia tNumberTrivia = NumberTrivia("test", tNumber);

  void setUpInputParser() {
    when(mockInputConverter.stringToUnsignedInt(tString))
        .thenReturn(Right(tNumber));
  }

  void setUpInputParserError() {
    when(mockInputConverter.stringToUnsignedInt(tString))
        .thenReturn(Left(InputFailure()));
  }

  group('concrete', () {
    test(
      'should call the parse of string to integer',
      () async {
        // arrange
        setUpInputParser();
        // act
        bloc.add(GetTriviaForConcreteNumber(tString));

        await untilCalled(mockInputConverter.stringToUnsignedInt(tString));
        // assert
        verify(mockInputConverter.stringToUnsignedInt(tString)).called(1);
        verifyNoMoreInteractions(mockInputConverter);
      },
    );

    test(
      'should emit [Error] when input parsing failed',
      () async {
        // arrange
        setUpInputParserError();
        // assert later
        expectLater(
            bloc.stream, emitsInOrder([Error(message: INPUT_EXCEPTION)]));
        // act
        bloc.add(GetTriviaForConcreteNumber(tString));
      },
    );

    test(
      'should call usecase mockGetConcreteNumberTrivia',
      () async {
        // arrange
        setUpInputParser();
        when(mockGetConcreteNumberTrivia.call(Param(num: tNumber)))
            .thenAnswer((realInvocation) async => Right(tNumberTrivia));
        // act
        bloc.add(GetTriviaForConcreteNumber(tString));
        await untilCalled(
            mockGetConcreteNumberTrivia.call(Param(num: tNumber)));
        // assert
        verify(mockGetConcreteNumberTrivia.call(Param(num: tNumber))).called(1);
        verifyNoMoreInteractions(mockGetConcreteNumberTrivia);
      },
    );

    test(
      'should emit [Loading, Loaded] state with appropriate NumberTrivia',
      () async {
        // arrange
        setUpInputParser();
        when(mockGetConcreteNumberTrivia.call(Param(num: tNumber)))
            .thenAnswer((realInvocation) async => Right(tNumberTrivia));

        // act
        bloc.add(GetTriviaForConcreteNumber(tString));
        // assert later
        expectLater(bloc.stream,
            emitsInOrder([Loading(), Loaded(trivia: tNumberTrivia)]));
      },
    );

    test(
      'should emit [Loading, Error] state when geting concrete number trivia returns ServerException',
      () async {
        // arrange
        setUpInputParser();
        when(mockGetConcreteNumberTrivia.call(Param(num: tNumber)))
            .thenAnswer((realInvocation) async => Left(ServerFailure()));

        // act
        bloc.add(GetTriviaForConcreteNumber(tString));
        // assert later
        expectLater(bloc.stream,
            emitsInOrder([Loading(), Error(message: REMOTE_NUMBER_ERROR)]));
      },
    );

    test(
      'should emit [Loading, Error] state when geting concrete number trivia returns CasheException',
      () async {
        // arrange
        setUpInputParser();
        when(mockGetConcreteNumberTrivia.call(Param(num: tNumber)))
            .thenAnswer((realInvocation) async => Left(CasheFailure()));

        // act
        bloc.add(GetTriviaForConcreteNumber(tString));
        // assert later
        expectLater(bloc.stream,
            emitsInOrder([Loading(), Error(message: LOCAL_NUMBER_ERROR)]));
      },
    );
  });

  group('random', () {
    test(
      'should call usecase mockGetRandomNumberTrivia',
      () async {
        // arrange
        when(mockGetRandomNumberTrivia(NoParams()))
            .thenAnswer((realInvocation) async => Right(tNumberTrivia));
        // act
        bloc.add(GetTriviaForRandomNumber());
        await untilCalled(mockGetRandomNumberTrivia(NoParams()));
        // assert
        verify(mockGetRandomNumberTrivia(NoParams())).called(1);
        verifyNoMoreInteractions(mockGetRandomNumberTrivia);
      },
    );

    test(
      'should emit [Loading, Loaded] state with random NumberTrivia',
      () async {
        // arrange
        when(mockGetRandomNumberTrivia.call(NoParams()))
            .thenAnswer((realInvocation) async => Right(tNumberTrivia));

        // act
        bloc.add(GetTriviaForRandomNumber());
        // assert later
        expectLater(bloc.stream,
            emitsInOrder([Loading(), Loaded(trivia: tNumberTrivia)]));
      },
    );

    test(
      'should emit [Loading, Error] state when geting random number trivia returns ServerException',
      () async {
        // arrange
        setUpInputParser();
        when(mockGetRandomNumberTrivia.call(NoParams()))
            .thenAnswer((realInvocation) async => Left(ServerFailure()));

        // act
        bloc.add(GetTriviaForRandomNumber());
        // assert later
        expectLater(bloc.stream,
            emitsInOrder([Loading(), Error(message: REMOTE_NUMBER_ERROR)]));
      },
    );

    test(
      'should emit [Loading, Error] state when geting random number trivia returns CasheException',
      () async {
        // arrange
        setUpInputParser();
        when(mockGetRandomNumberTrivia.call(NoParams()))
            .thenAnswer((realInvocation) async => Left(CasheFailure()));

        // act
        bloc.add(GetTriviaForRandomNumber());
        // assert later
        expectLater(bloc.stream,
            emitsInOrder([Loading(), Error(message: LOCAL_NUMBER_ERROR)]));
      },
    );
  });
}
