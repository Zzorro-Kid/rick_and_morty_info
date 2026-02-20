import 'package:flutter/material.dart';

class CharacterSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const CharacterSearchBar({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: 'Search by name...',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          fillColor: Colors.white,
          filled: true,
        ),
        onChanged: onChanged,
      ),
    );
  }
}
