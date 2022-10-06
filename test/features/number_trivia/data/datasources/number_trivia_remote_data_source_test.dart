import 'dart:convert';

import 'package:mocktail/mocktail.dart';
import "package:http/http.dart" as http;
import 'package:flutter_test/flutter_test.dart';
import 'package:number_trivia/core/error/exceptions.dart';
import 'package:number_trivia/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:number_trivia/features/number_trivia/data/models/number_trivia_model.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  late NumberTriviaRemoteDataSourceImpl dataSource;
  late MockHttpClient mockHttpClient;

  setUpAll(() {
    registerFallbackValue(Uri());
  });

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = NumberTriviaRemoteDataSourceImpl(client: mockHttpClient);
  });

  void setUpMockHttpClientSuccess200() {
    final trivia = fixture('trivia.json');
    const responseCode = 200;
    final response = http.Response(trivia, responseCode);

    when(() => mockHttpClient.get(any(), headers: any(named: 'headers')))
        .thenAnswer((_) async => response);
  }

  void setUpMockHttpClientFailure404() {
    const responseBody = 'Something went wrong';
    const statusCode = 404;
    final response = http.Response(responseBody, statusCode);

    when(() => mockHttpClient.get(any(), headers: any(named: 'headers')))
        .thenAnswer((_) async => response);
  }

  group("getConcreteNumberTrivia", () {
    const testNumber = 1;

    final testNumberTrivia = NumberTriviaModel.fromJson(
      json.decode(
        fixture("trivia.json"),
      ),
    );

    test(
      "should perform a GET request on a URL with number being the endpoint and with applicatiom/json header",
      () async {
        setUpMockHttpClientSuccess200();

        dataSource.getConcreteNumberTrivia(testNumber);

        // Assert
        final uri = Uri.parse('http://numbersapi.com/$testNumber');

        final headers = {
          'Content-Type': 'application/json',
        };

        verify(() => mockHttpClient.get(uri, headers: headers));
      },
    );

    test(
      "should return NumberTrivia when the response code is 200 (success)",
      () async {
        setUpMockHttpClientSuccess200();

        final result = await dataSource.getConcreteNumberTrivia(testNumber);

        final uri = Uri.parse('http://numbersapi.com/$testNumber');

        final headers = {
          'Content-Type': 'application/json',
        };

        verify(() => mockHttpClient.get(uri, headers: headers));

        expect(result, equals(testNumberTrivia));
      },
    );

    test(
      "should throw a ServerException when the response code is 404 or other",
      () async {
        setUpMockHttpClientFailure404();

        final call = dataSource.getConcreteNumberTrivia;

        expect(() => call(testNumber),
            throwsA(const TypeMatcher<ServerException>()));
      },
    );
  });

  group("getRandomNumberTrivia", () {
    final testNumberTrivia = NumberTriviaModel.fromJson(
      json.decode(
        fixture("trivia.json"),
      ),
    );

    test(
      "should perform a GET request on a URL with number being the endpoint and with applicatiom/json header",
      () async {
        setUpMockHttpClientSuccess200();

        dataSource.getRandomNumberTrivia();

        // Assert
        final uri = Uri.parse('http://numbersapi.com/random');

        final headers = {
          'Content-Type': 'application/json',
        };

        verify(() => mockHttpClient.get(uri, headers: headers));
      },
    );

    test(
      "should return NumberTrivia when the response code is 200 (success)",
      () async {
        setUpMockHttpClientSuccess200();

        final result = await dataSource.getRandomNumberTrivia();

        final uri = Uri.parse('http://numbersapi.com/random');

        final headers = {
          'Content-Type': 'application/json',
        };

        verify(() => mockHttpClient.get(uri, headers: headers));

        expect(result, equals(testNumberTrivia));
      },
    );

    test(
      "should throw a ServerException when the response code is 404 or other",
      () async {
        setUpMockHttpClientFailure404();

        final call = dataSource.getRandomNumberTrivia;

        expect(() => call(), throwsA(const TypeMatcher<ServerException>()));
      },
    );
  });
}
