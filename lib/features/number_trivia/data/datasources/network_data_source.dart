import 'package:tdd/core/error/exceptions.dart';
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
    return getNumberTriviaFromUrl('/$number');
  }

  @override
  Future<NumberTriviaModel> getRandomNumberTrivia() async {
    return getNumberTriviaFromUrl('/random');
  }

  Future<NumberTriviaModel> getNumberTriviaFromUrl(String path) async {
    print("RESPONSE: ");
    final response = await client.get(
      Uri.https('numbersapi.com', path),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode != 200) throw ServerException();

    return NumberTriviaModel.fomJson(jsonDecode(response.body));
  }
}
