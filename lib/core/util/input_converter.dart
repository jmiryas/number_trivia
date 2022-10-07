import 'package:dartz/dartz.dart';

import '../error/failures.dart';

class InputConverter {
  Either<Failure, int> stringToUnsignedInteger(String numberString) {
    try {
      final numberParseResult = int.parse(numberString);

      if (numberParseResult >= 0) {
        return Right(numberParseResult);
      } else {
        // return Left(InvalidInputFailure());
        throw const FormatException();
      }
    } on FormatException {
      return Left(InvalidInputFailure());
    }
  }
}

class InvalidInputFailure extends Failure {}
