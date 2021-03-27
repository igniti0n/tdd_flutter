part of 'number_trivia_bloc.dart';

abstract class NumberTriviaEvent extends Equatable {
  const NumberTriviaEvent();

  @override
  List<Object> get props => [];
}

class GetTriviaForConcreteNumber extends NumberTriviaEvent {
  final String text;
  const GetTriviaForConcreteNumber(this.text);
}

class GetTriviaForRandomNumber extends NumberTriviaEvent {}
