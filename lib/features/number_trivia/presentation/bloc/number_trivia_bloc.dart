import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:tdd/core/error/failure.dart';
import 'package:tdd/core/util/input_converter.dart';
import 'package:tdd/features/number_trivia/domain/enteties/number_trivia.dart';
import 'package:tdd/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:tdd/features/number_trivia/domain/usecases/get_random_number_trivia.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

const String REMOTE_NUMBER_ERROR = "Server exception.";
const String LOCAL_NUMBER_ERROR = "Cashe exception.";
const String INPUT_EXCEPTION =
    "Input exception - input number must be a valid positive integer.";

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final InputConverter inputParser;
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;
  NumberTriviaBloc({
    required this.getConcreteNumberTrivia,
    required this.getRandomNumberTrivia,
    required this.inputParser,
  }) : super(Empty());

  @override
  Stream<NumberTriviaState> mapEventToState(
    NumberTriviaEvent event,
  ) async* {
    if (event is GetTriviaForConcreteNumber) {
      final either = inputParser.stringToUnsignedInt(event.text);

      yield* either.fold(
        (fialure) async* {
          print("Getting trivia for concrete number");
          yield Error(message: INPUT_EXCEPTION);
        },
        (integer) async* {
          yield Loading();
          final numberTriviaEither =
              await getConcreteNumberTrivia.call(Param(num: integer));

          yield yieldResult(numberTriviaEither);
        },
      );
    } else if (event is GetTriviaForRandomNumber) {
      yield Loading();
      final numberTriviaEither = await getRandomNumberTrivia.call(NoParams());

      yield yieldResult(numberTriviaEither);
    }
  }

  NumberTriviaState yieldResult(
      Either<Failure, NumberTrivia> numberTriviaEither) {
    return numberTriviaEither.fold(
        (failure) => Error(message: mapFailuresToString(failure)),
        (numberTrivia) => Loaded(trivia: numberTrivia));
  }

  String mapFailuresToString(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return REMOTE_NUMBER_ERROR;

      case CasheFailure:
        return LOCAL_NUMBER_ERROR;

      default:
        return 'Unknown error.';
    }
  }
}
