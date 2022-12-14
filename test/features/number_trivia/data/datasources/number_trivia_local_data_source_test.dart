import 'dart:convert';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:number_trivia/core/error/exceptions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:number_trivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:number_trivia/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late NumberTriviaLocalDataSourceImpl dataSource;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = NumberTriviaLocalDataSourceImpl(
      sharedPreferences: mockSharedPreferences,
    );
  });

  group("getLastNumberTrivia", () {
    final testNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture("trivia_cached.json")));

    test(
      "should return NumberTrivia from SharedPreferences when there is one in the cache",
      () async {
        when(() => mockSharedPreferences.getString(any()))
            .thenReturn(fixture("trivia_cached.json"));

        final result = await dataSource.getLastNumberTrivia();

        verify(() => mockSharedPreferences.getString(CACHED_NUMBER_TRIVIA));
        expect(result, equals(testNumberTriviaModel));
      },
    );

    test(
      "should throw a CacheException when there is not a cached value",
      () async {
        when(() => mockSharedPreferences.getString(any())).thenReturn(null);

        final call = dataSource.getLastNumberTrivia;

        expect(() => call(), throwsA(const TypeMatcher<CacheException>()));
      },
    );
  });

  group("cacheNumberTrivia", () {
    const NumberTriviaModel testNumberTrivia =
        NumberTriviaModel(text: "Text", number: 1);

    test(
      "should call SharedPreferences to cache the data",
      () async {
        when(() => mockSharedPreferences.setString(any(), any()))
            .thenAnswer((_) async => true);

        dataSource.cacheNumberTrivia(testNumberTrivia);

        final expectedJsonString = json.encode(testNumberTrivia.toJson());

        verify(() => mockSharedPreferences.setString(
            CACHED_NUMBER_TRIVIA, expectedJsonString));
      },
    );
  });
}
