import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia/features/number_trivia/data/models/number_trivia_model.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const testNumberTriviaModel = NumberTriviaModel(text: "Text", number: 1);

  test("should be a subsclass of NumberTrivia entity", () async {
    expect(testNumberTriviaModel, isA<NumberTrivia>());
  });

  group("fromJSON", () {
    test("should return a valid model when the JSON number is an integer",
        () async {
      NumberTriviaModel numberTriviaModel =
          NumberTriviaModel.fromJson(json.decode(fixture("trivia.json")));

      expect(numberTriviaModel, equals(testNumberTriviaModel));
    });

    test(
        "should return a valid model when the JSON number is regarded as a double",
        () async {
      NumberTriviaModel numberTriviaModel = NumberTriviaModel.fromJson(
          json.decode(fixture("trivia_double.json")));

      expect(numberTriviaModel, equals(testNumberTriviaModel));
    });
  });

  group("toJSON", () {
    test("should return a JSON", () async {
      expect(testNumberTriviaModel.toJson(), {
        "text": "Text",
        "number": 1,
      });
    });
  });
}
