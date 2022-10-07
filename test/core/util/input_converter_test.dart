import 'package:dartz/dartz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:number_trivia/core/util/input_converter.dart';

void main() {
  late InputConverter inputConverter;

  setUp(() {
    inputConverter = InputConverter();
  });

  group("stringToUnsignedInteger", () {
    test(
      "should return an integer when the string represents an unsigned integer",
      () {
        const numberString = "1";

        final result = inputConverter.stringToUnsignedInteger(numberString);

        expect(result, const Right(1));
      },
    );

    test(
      "should return a failure when the string is not an integer",
      () {
        const numberString = "a";

        final result = inputConverter.stringToUnsignedInteger(numberString);

        expect(result, Left(InvalidInputFailure()));
      },
    );

    test(
      "should return a failure when the string is a negative integer",
      () {
        const numberString = "-1";

        final result = inputConverter.stringToUnsignedInteger(numberString);

        expect(result, Left(InvalidInputFailure()));
      },
    );
  });
}
