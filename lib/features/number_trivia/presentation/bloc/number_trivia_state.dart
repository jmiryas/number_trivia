part of 'number_trivia_bloc.dart';

abstract class NumberTriviaState extends Equatable {
  const NumberTriviaState();

  @override
  List<Object> get props => [];
}

class NumberTriviaEmptyState extends NumberTriviaState {}

class NumberTriviaLoadingState extends NumberTriviaState {}

class NumberTriviaLoadedState extends NumberTriviaState {
  final NumberTrivia numberTrivia;

  const NumberTriviaLoadedState({
    required this.numberTrivia,
  });
}

class NumberTriviaErrorState extends NumberTriviaState {
  final String errorMessage;

  const NumberTriviaErrorState({
    required this.errorMessage,
  });
}
