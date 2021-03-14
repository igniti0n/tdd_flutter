import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../enteties/number_trivia.dart';
import '../repositories/number_trivia_repository.dart';

class GetRandomNumberTrivia extends Usecase<NumberTrivia, NoParams> {
  final NumberTriviaRepository numberTriviaRepository;
  const GetRandomNumberTrivia({required NumberTriviaRepository repository})
      : this.numberTriviaRepository = repository;

  @override
  Future<Either<Failure, NumberTrivia>> call(Object param) async {
    // TODO: implement call
    return await numberTriviaRepository.getRandomNumberTrivia();
  }
}

class NoParams {}
