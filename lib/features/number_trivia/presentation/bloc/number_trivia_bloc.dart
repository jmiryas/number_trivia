import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/number_trivia.dart';
import '../../../../core/util/input_converter.dart';
import '../../domain/usecases/get_concrete_number_trivia.dart';
import '../../domain/usecases/get_random_number_trivia.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

const serverFailureMessage = 'Server Failure';
const cacheFailureMessage = 'Cache Failure';

const invalidInputFailureMessage =
    'Invalid Input - The number must be a positive integer.';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia concreteNumber;
  final GetRandomNumberTrivia randomNumber;
  final InputConverter inputConverter;

  NumberTriviaBloc({
    required this.concreteNumber,
    required this.randomNumber,
    required this.inputConverter,
  }) : super(NumberTriviaEmptyState()) {
    on<GetTriviaConcreteNumber>(_getConcreteNumberTriviaEventHandler);
    on<GetTriviaRandomNumber>(_getRandomNumberTriviaEventHandler);
  }

  Future<void> _getConcreteNumberTriviaEventHandler(
    GetTriviaConcreteNumber event,
    Emitter<NumberTriviaState> emit,
  ) async {
    final stringNumber = event.numberString;

    final inputConverterEither =
        inputConverter.stringToUnsignedInteger(stringNumber);

    await inputConverterEither.fold(
      (_) async => emit(
        const NumberTriviaErrorState(
          errorMessage: invalidInputFailureMessage,
        ),
      ),
      (parsedNumber) async {
        emit(NumberTriviaLoadingState());

        final params = Params(number: parsedNumber);
        final either = await concreteNumber(params);

        _emitNumberTriviaRetrievalResult(either, emit);
      },
    );
  }

  Future<void> _getRandomNumberTriviaEventHandler(
    GetTriviaRandomNumber event,
    Emitter<NumberTriviaState> emit,
  ) async {}

  String _mapFailureToMessage(Failure failure) {
    late final String failureMessage;

    switch (failure.runtimeType) {
      case ServerFailure:
        failureMessage = serverFailureMessage;

        break;

      case CacheFailure:
        failureMessage = cacheFailureMessage;

        break;

      default:
        failureMessage = 'Unexpected error';

        break;
    }

    return failureMessage;
  }

  void _emitNumberTriviaRetrievalResult(
    Either<Failure, NumberTrivia> either,
    Emitter<NumberTriviaState> emit,
  ) async {
    await either.fold(
      (failure) async {
        emit(
          NumberTriviaErrorState(
            errorMessage: _mapFailureToMessage(failure),
          ),
        );
      },
      (trivia) async {
        emit(
          NumberTriviaLoadedState(
            numberTrivia: trivia,
          ),
        );
      },
    );
  }
}
