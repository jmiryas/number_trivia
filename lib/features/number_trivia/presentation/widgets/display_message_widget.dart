import 'package:flutter/material.dart';

class DisplayMessageWidget extends StatelessWidget {
  final String message;
  const DisplayMessageWidget({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        message,
        style: const TextStyle(
          fontSize: 25.0,
        ),
      ),
    );
  }
}
