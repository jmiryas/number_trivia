import 'package:dartz/dartz.dart';
import 'package:mocktail/mocktail.dart';
import "package:flutter_test/flutter_test.dart";
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';

import 'package:number_trivia/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:number_trivia/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';

class MockNumberTriviaRepository extends Mock
    implements NumberTriviaRepository {}

void main() {
  MockNumberTriviaRepository mockNumberTriviaRepository =
      MockNumberTriviaRepository();
  GetConcreteNumberTrivia usecase = GetConcreteNumberTrivia(
      numberTriviaRepository: mockNumberTriviaRepository);

  const testNumber = 42;
  const testNumberTrivia = NumberTrivia(
    text:
        "42 is the angle in degrees for which a rainbow appears or the critical angle.",
    number: testNumber,
  );

  test("should get trivia for the number from the repository", () async {
    when(() => mockNumberTriviaRepository.getConcreteNumberTrivia(testNumber))
        .thenAnswer((_) async => const Right(testNumberTrivia));

    final result = await usecase.execute(number: testNumber);

    expect(result, const Right(testNumberTrivia));
    verify(
        () => mockNumberTriviaRepository.getConcreteNumberTrivia(testNumber));
    verifyNoMoreInteractions(mockNumberTriviaRepository);
  });
}
