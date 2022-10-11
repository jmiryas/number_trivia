import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../injection_container.dart';
import '../bloc/number_trivia_bloc.dart';
import '../widgets/display_message_widget.dart';
import '../widgets/display_number_trivia_widget.dart';
import '../widgets/number_trivia_control_widget.dart';

class NumberTriviaPage extends StatelessWidget {
  const NumberTriviaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Number Trivia"),
      ),
      body: BlocProvider(
        create: (_) => serviceLocator.get<NumberTriviaBloc>(),
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
                builder: (context, state) {
                  late Widget widget;

                  if (state is NumberTriviaEmptyState) {
                    widget =
                        const DisplayMessageWidget(message: "Start searching!");
                  } else if (state is NumberTriviaLoadingState) {
                    widget = const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is NumberTriviaLoadedState) {
                    widget = DisplayNumberTriviaWidget(
                        numberTrivia: state.numberTrivia);
                  } else if (state is NumberTriviaErrorState) {
                    widget = DisplayMessageWidget(message: state.errorMessage);
                  }

                  return widget;
                },
              ),
              const SizedBox(
                height: 10.0,
              ),
              const NumberTriviaControlWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
