import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../../../../core/error/exceptions.dart';
import '../models/number_trivia_model.dart';

abstract class LocalDataSource {
  const LocalDataSource();

  Future<NumberTriviaModel> getNumberTrivia();

  Future<NumberTriviaModel> casheNumberTrivia(
      NumberTriviaModel numberTriviaModel);
}

const String cashedNumberTriviaKey = 'CASHED_NUMBER_TRIVIA';

class LocalDataSourceImpl extends LocalDataSource {
  final SharedPreferences sharedPreferences;

  const LocalDataSourceImpl(this.sharedPreferences);

  @override
  Future<NumberTriviaModel> casheNumberTrivia(
      NumberTriviaModel numberTriviaModel) {
    // TODO: implement casheNumberTrivia
    throw UnimplementedError();
  }

  @override
  Future<NumberTriviaModel> getNumberTrivia() {
    // TODO: implement getNumberTrivia

    final String? savedString =
        sharedPreferences.getString(cashedNumberTriviaKey);
    if (savedString == null) throw CasheException();
    return Future.value(NumberTriviaModel.fomJson(json.decode(savedString)));
  }
}
