import 'package:equatable/equatable.dart';

class NumberTrivia extends Equatable {
  final int number;
  final String text;

  const NumberTrivia(String text, int number)
      : number = number,
        text = text;

  @override
  // TODO: implement props
  List<Object?> get props => [number, text];
}
