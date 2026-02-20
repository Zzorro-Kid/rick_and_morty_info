import 'package:flutter/material.dart';

class EpisodeInfoCard extends StatelessWidget {
  const EpisodeInfoCard({super.key, required this.airDate});

  final String airDate;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(
            Icons.calendar_today_outlined,
            size: 20,
            color: colorScheme.primary,
          ),
          const SizedBox(width: 12),
          Text(
            'Release date',
            style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 14),
          ),
          const Spacer(),
          Text(
            airDate,
            style: TextStyle(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
