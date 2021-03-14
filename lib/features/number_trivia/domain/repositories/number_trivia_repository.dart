import 'package:dartz/dartz.dart';
import 'package:tdd/core/error/failure.dart';
import 'package:tdd/features/number_trivia/domain/enteties/number_trivia.dart';

abstract class NumberTriviaRepository {
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(int number);
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia();
}
