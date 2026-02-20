import 'package:flutter/material.dart';

class CharacterStatusHelper {
  static (Color, String) getStatusData(String status, ColorScheme colorScheme) {
    return switch (status.toLowerCase()) {
      'alive' => (Colors.green, 'Alive'),
      'dead' => (Colors.red, 'Dead'),
      _ => (colorScheme.outline, 'Unknown'),
    };
  }

  static Color getStatusColor(String status, ColorScheme colorScheme) {
    final (color, _) = getStatusData(status, colorScheme);
    return color;
  }

  static String getStatusLabel(String status, ColorScheme colorScheme) {
    final (_, label) = getStatusData(status, colorScheme);
    return label;
  }
}
