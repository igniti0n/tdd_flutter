import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../enteties/number_trivia.dart';
import '../repositories/number_trivia_repository.dart';

class GetConcreteNumberTrivia extends Usecase<NumberTrivia, Param> {
  final NumberTriviaRepository numberTriviaRepository;
  const GetConcreteNumberTrivia({required NumberTriviaRepository repository})
      : numberTriviaRepository = repository;

  Future<Either<Failure, NumberTrivia>> call(Param param) async {
    return await numberTriviaRepository.getConcreteNumberTrivia(param.number);
  }
}

class Param extends Equatable {
  final int number;
  const Param({int num = 0}) : this.number = num;

  @override
  // TODO: implement props
  List<Object?> get props => [number];
}
