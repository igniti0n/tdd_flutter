import 'package:tdd/core/error/exceptions.dart';
import 'package:tdd/core/platform/network_info.dart';
import 'package:tdd/features/number_trivia/data/datasources/local_data_source.dart';
import 'package:tdd/features/number_trivia/data/datasources/network_data_source.dart';
import 'package:tdd/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:tdd/features/number_trivia/domain/enteties/number_trivia.dart';
import 'package:tdd/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:tdd/features/number_trivia/domain/repositories/number_trivia_repository.dart';

typedef Future<NumberTriviaModel> _TriviaCall();

class NumberTriviaRepositoryImplementation extends NumberTriviaRepository {
  final NetworkInfo networkInfo;
  final LocalDataSource localDataSource;
  final NetworkDataSource networkDataSource;

  NumberTriviaRepositoryImplementation({
    required LocalDataSource localDataSource,
    required NetworkDataSource networkDataSource,
    required NetworkInfo networkInfo,
  })   : this.networkInfo = networkInfo,
        this.localDataSource = localDataSource,
        this.networkDataSource = networkDataSource;

  @override
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(
      int number) async {
    // TODO: implement getConcreteNumberTrivia

    return _getTrivia(() => networkDataSource.getConcreteNumberTrivia(number));
  }

  @override
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() async {
    // TODO: implement getRandomNumberTrivia
    return _getTrivia(() => networkDataSource.getRandomNumberTrivia());
  }

  Future<Either<Failure, NumberTrivia>> _getTrivia(
      _TriviaCall triviaCall) async {
    try {
      NumberTriviaModel res;
      if (await networkInfo.isConnected) {
        res = await triviaCall();
        await localDataSource.casheNumberTrivia(res);
        //Future.microtask(() => Right(res));
      } else {
        res = await localDataSource.getNumberTrivia();
      }
      return Right(res);
    } on ServerException {
      return Left(ServerFailure());
    } on CasheException {
      return Left(CasheFailure());
    }
  }
}
