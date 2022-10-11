import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/number_trivia_bloc.dart';

class NumberTriviaControlWidget extends StatelessWidget {
  const NumberTriviaControlWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final numberTriviaController = TextEditingController();
    String numberTriviaInput = "";

    return Column(
      children: [
        TextField(
          controller: numberTriviaController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: "Input a number",
          ),
          onChanged: (value) {
            numberTriviaInput = value;
          },
          onSubmitted: (value) {
            // dispatchConcrete();
          },
        ),
        const SizedBox(
          height: 10.0,
        ),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  numberTriviaController.clear();

                  BlocProvider.of<NumberTriviaBloc>(context).add(
                    GetTriviaConcreteNumber(numberString: numberTriviaInput),
                  );
                },
                child: const Text("Search"),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  numberTriviaController.clear();

                  BlocProvider.of<NumberTriviaBloc>(context).add(
                    GetTriviaRandomNumber(),
                  );
                },
                child: const Text("Random Trivia"),
              ),
            ),
          ],
        )
      ],
    );
  }
}
