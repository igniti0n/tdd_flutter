import 'package:tdd/features/number_trivia/domain/enteties/number_trivia.dart';

class NumberTriviaModel extends NumberTrivia {
  NumberTriviaModel(String text, int number) : super(text, number);

  factory NumberTriviaModel.fomJson(Map<String, dynamic> map) {
    return NumberTriviaModel(
      map['text'],
      (map['number'] as num).toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'number': number,
    };
  }
}
