import 'package:dartz/dartz.dart';

import '../entities/number_trivia.dart';
import '../../../../core/error/failures.dart';
import '../repositories/number_trivia_repository.dart';

class GetConcreteNumberTrivia {
  final NumberTriviaRepository numberTriviaRepository;

  GetConcreteNumberTrivia({
    required this.numberTriviaRepository,
  });

  Future<Either<Failure, NumberTrivia>> execute({required int number}) async {
    return await numberTriviaRepository.getConcreteNumberTrivia(number);
  }
}
