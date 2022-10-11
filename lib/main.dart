import 'package:flutter/material.dart';

import 'injection_container.dart';
import 'features/number_trivia/presentation/pages/number_trivia_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  initializeServiceLocator().then(
    (_) => runApp(
      const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "Number Trivia",
      debugShowCheckedModeBanner: false,
      home: NumberTriviaPage(),
    );
  }
}
