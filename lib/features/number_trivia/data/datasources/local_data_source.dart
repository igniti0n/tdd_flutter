import 'package:tdd/features/number_trivia/data/models/number_trivia_model.dart';

abstract class LocalDataSource {
  Future<NumberTriviaModel> getNumberTrivia();

  Future<NumberTriviaModel> casheNumberTrivia(
      NumberTriviaModel numberTriviaModel);
}
