import 'dart:convert';

import "package:http/http.dart" as http;
import 'package:number_trivia/core/error/exceptions.dart';
import '../models/number_trivia_model.dart';

const _numbersApi = 'http://numbersapi.com';

abstract class NumberTriviaRemoteDataSource {
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number);
  Future<NumberTriviaModel> getRandomNumberTrivia();
}

class NumberTriviaRemoteDataSourceImpl extends NumberTriviaRemoteDataSource {
  final http.Client client;

  NumberTriviaRemoteDataSourceImpl({
    required this.client,
  });

  Future<NumberTriviaModel> _getTriviaFromUrl(String url) async {
    final uri = Uri.parse(url);

    final headers = {
      'Content-Type': 'application/json',
    };

    final response = await client.get(uri, headers: headers);

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final numberTrivia = NumberTriviaModel.fromJson(jsonResponse);

      return numberTrivia;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number) {
    return _getTriviaFromUrl("$_numbersApi/$number");
  }

  @override
  Future<NumberTriviaModel> getRandomNumberTrivia() {
    return _getTriviaFromUrl("$_numbersApi/random");
  }
}
