import 'dart:convert';

import 'package:number_trivia/core/error/exceptions.dart';

import '../models/number_trivia_model.dart';

import 'package:shared_preferences/shared_preferences.dart';

abstract class NumberTriviaLocalDataSource {
  Future<NumberTriviaModel> getLastNumberTrivia();
  Future<void> cacheNumberTrivia(NumberTriviaModel numberTriviaModelToCache);
}

const CACHED_NUMBER_TRIVIA = "CACHED_NUMBER_TRIVIA";

class NumberTriviaLocalDataSourceImpl extends NumberTriviaLocalDataSource {
  final SharedPreferences sharedPreferences;

  NumberTriviaLocalDataSourceImpl({
    required this.sharedPreferences,
  });

  @override
  Future<void> cacheNumberTrivia(
      NumberTriviaModel numberTriviaModelToCache) async {
    final numberTriviaJsonString =
        json.encode(numberTriviaModelToCache.toJson());

    sharedPreferences.setString(CACHED_NUMBER_TRIVIA, numberTriviaJsonString);
  }

  @override
  Future<NumberTriviaModel> getLastNumberTrivia() {
    final jsonString = sharedPreferences.getString(CACHED_NUMBER_TRIVIA);

    return jsonString == null
        ? throw CacheException()
        : Future.value(NumberTriviaModel.fromJson(json.decode(jsonString)));
  }
}
