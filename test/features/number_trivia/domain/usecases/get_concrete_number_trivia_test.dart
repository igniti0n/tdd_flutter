// @dart=2.9
import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdd/features/number_trivia/domain/enteties/number_trivia.dart';
import 'package:tdd/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:tdd/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';

class MockNumberTriviaRepository extends Mock
    implements NumberTriviaRepository {}

void main() {
  MockNumberTriviaRepository concreteNumberTriviaRepository;
  GetConcreteNumberTrivia uscase;

  setUp(() {
    concreteNumberTriviaRepository = MockNumberTriviaRepository();
    uscase =
        GetConcreteNumberTrivia(repository: concreteNumberTriviaRepository);
  });

  final tNUmber = NumberTrivia('test', 4);

  test('should return tNumber when get concrete number trivia is executed',
      () async {
    //arrange
    when(concreteNumberTriviaRepository.getConcreteNumberTrivia(any))
        .thenAnswer((_) async => Right(tNUmber));
    //act

    final result = await uscase(Param(num: 4));

    //assert

    expect(result, Right(tNUmber));
    verify(concreteNumberTriviaRepository.getConcreteNumberTrivia(4)).called(1);
    verifyNoMoreInteractions(concreteNumberTriviaRepository);
  });
}
