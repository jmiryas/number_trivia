import 'package:dartz/dartz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:number_trivia/core/util/input_converter.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:number_trivia/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:number_trivia/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';

class MockGetConcreteNumberTrivia extends Mock
    implements GetConcreteNumberTrivia {}

class MockGetRandomNumberTrivia extends Mock implements GetRandomNumberTrivia {}

class MockInputConverter extends Mock implements InputConverter {}

void main() {
  const testNumberString = '1';
  const testParsedNumber = 1;
  const testNumberTrivia = NumberTrivia(number: 1, text: 'text');

  late MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  late MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  late MockInputConverter mockInputConverter;

  late NumberTriviaBloc numberTriviaBloc;

  setUpAll(() {
    registerFallbackValue(const Params(number: testParsedNumber));
    registerFallbackValue(NoParams());
  });

  setUp(() {
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();

    numberTriviaBloc = NumberTriviaBloc(
      concreteNumber: mockGetConcreteNumberTrivia,
      randomNumber: mockGetRandomNumberTrivia,
      inputConverter: mockInputConverter,
    );
  });

  void setUpMockInputConverterSuccess() {
    when(() => mockInputConverter.stringToUnsignedInteger(any()))
        .thenReturn(const Right(testParsedNumber));
  }

  void setUpMockGetConcreteNumberTriviaSuccess() {
    when(() => mockGetConcreteNumberTrivia(any()))
        .thenAnswer((_) async => const Right(testNumberTrivia));
  }

  void setUpMockGetRandomNumberTriviaSuccess() {
    when(() => mockGetRandomNumberTrivia(any()))
        .thenAnswer((_) async => const Right(testNumberTrivia));
  }

  test("initialState should be Empty", () {
    expect(numberTriviaBloc.state, equals(NumberTriviaEmptyState()));
  });

  group("GetTriviaForConcreteNumber", () {
    test(
      "should call the InputConverter to validate and convert the number to an unsigned integer",
      () async {
        setUpMockInputConverterSuccess();
        setUpMockGetConcreteNumberTriviaSuccess();

        numberTriviaBloc.add(
          const GetTriviaConcreteNumber(numberString: testNumberString),
        );

        await untilCalled(
            () => mockInputConverter.stringToUnsignedInteger(any()));

        verify(
            () => mockInputConverter.stringToUnsignedInteger(testNumberString));
      },
    );

    test(
      "should emit [NumberTriviaErrorState] when the input is invalid",
      () {
        // Arrange
        when(() => mockInputConverter.stringToUnsignedInteger(any()))
            .thenReturn(Left(InvalidInputFailure()));

        // Assert
        expectLater(
            numberTriviaBloc.stream,
            emitsInOrder([
              const NumberTriviaErrorState(
                  errorMessage: invalidInputFailureMessage)
            ]));

        // Act
        numberTriviaBloc.add(
          const GetTriviaConcreteNumber(numberString: testNumberString),
        );
      },
    );

    test('should get data from the concrete use case', () async {
      // arrange
      setUpMockInputConverterSuccess();
      setUpMockGetConcreteNumberTriviaSuccess();

      // act
      numberTriviaBloc
          .add(const GetTriviaConcreteNumber(numberString: testNumberString));
      await untilCalled(() => mockGetConcreteNumberTrivia(any()));

      // // assert
      verify(
        () =>
            mockGetConcreteNumberTrivia(const Params(number: testParsedNumber)),
      );
    });
  });
}
