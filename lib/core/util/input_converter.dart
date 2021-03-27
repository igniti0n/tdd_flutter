import 'package:dartz/dartz.dart';
import 'package:tdd/core/error/failure.dart';
import 'package:tdd/features/number_trivia/domain/enteties/number_trivia.dart';

class InputConverter {
  Either<Failure, int> stringToUnsignedInt(String text) {
    try {
      final int number = int.parse(text);
      if (number < 0) throw FormatException();
      return Right(number);
    } on FormatException {
      return Left(InputFailure());
    }
  }
}

class InputFailure extends Failure {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
