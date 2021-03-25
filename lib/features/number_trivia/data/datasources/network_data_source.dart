import 'package:tdd/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

abstract class NetworkDataSource {
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number);
  Future<NumberTriviaModel> getRandomNumberTrivia();
  const NetworkDataSource();
}

class NetworkDataSourceImpl extends NetworkDataSource {
  final http.Client client;
  const NetworkDataSourceImpl(this.client);

  @override
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number) async {
    final response = await client.get(
      Uri(path: 'http://numbersapi.com/$number'),
      headers: {'Content-Type': 'application/json'},
    );

    return NumberTriviaModel.fomJson(json.decode(response.body));
  }

  @override
  Future<NumberTriviaModel> getRandomNumberTrivia() {
    // TODO: implement getRandomNumberTrivia
    throw UnimplementedError();
  }
}
