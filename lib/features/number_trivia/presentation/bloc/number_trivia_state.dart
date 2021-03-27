part of 'number_trivia_bloc.dart';

abstract class NumberTriviaState extends Equatable {
  const NumberTriviaState([List<Object> props = const []]);

  @override
  List<Object> get props;
}

class Empty extends NumberTriviaState {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class Loading extends NumberTriviaState {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class Loaded extends NumberTriviaState {
  final NumberTrivia trivia;
  const Loaded({required this.trivia});

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class Error extends NumberTriviaState {
  final String message;
  const Error({required String message}) : this.message = message;

  @override
  // TODO: implement props
  List<Object> get props => [message];
}
