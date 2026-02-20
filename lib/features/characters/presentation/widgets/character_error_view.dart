import 'package:flutter/material.dart';

class CharacterErrorView extends StatelessWidget {
  const CharacterErrorView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 48, color: Colors.red),
          SizedBox(height: 16),
          Text('An error occurred'),
        ],
      ),
    );
  }
}
