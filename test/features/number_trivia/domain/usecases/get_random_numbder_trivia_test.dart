// @dart=2.9
import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdd/features/number_trivia/domain/enteties/number_trivia.dart';
import 'package:tdd/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:tdd/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:tdd/features/number_trivia/domain/usecases/get_random_number_trivia.dart';

class MockNumberTriviaRepository extends Mock
    implements NumberTriviaRepository {}

void main() {
  MockNumberTriviaRepository randomNumberTriviaRepository;
  GetRandomNumberTrivia uscase;

  setUp(() {
    randomNumberTriviaRepository = MockNumberTriviaRepository();
    uscase = GetRandomNumberTrivia(repository: randomNumberTriviaRepository);
  });

  final tNUmber = NumberTrivia('test', 4);

  test('should return random number when get random number trivia is executed',
      () async {
    //arrange
    when(randomNumberTriviaRepository.getRandomNumberTrivia())
        .thenAnswer((_) async => Right(tNUmber));
    //act

    final result = await uscase(NoParams());

    //assert

    expect(result, Right(tNUmber));
    verify(randomNumberTriviaRepository.getRandomNumberTrivia()).called(1);
    verifyNoMoreInteractions(randomNumberTriviaRepository);
  });
}
