import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../characters/domain/entities/character_model.dart';

class EpisodeCharacterTile extends StatelessWidget {
  const EpisodeCharacterTile({
    super.key,
    required this.character,
    required this.onTap,
  });

  final CharacterModel character;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: colorScheme.surfaceContainerHigh,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              _buildAvatar(colorScheme),
              const SizedBox(width: 12),
              Expanded(child: _buildInfo(colorScheme)),
              _buildChevron(colorScheme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar(ColorScheme colorScheme) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: CachedNetworkImage(
        imageUrl: character.image,
        width: 48,
        height: 48,
        fit: BoxFit.cover,
        placeholder: (_, __) => _buildPlaceholder(colorScheme),
        errorWidget: (_, __, ___) => _buildError(colorScheme),
      ),
    );
  }

  Widget _buildPlaceholder(ColorScheme colorScheme) {
    return Container(
      width: 48,
      height: 48,
      color: colorScheme.surfaceContainerHighest,
    );
  }

  Widget _buildError(ColorScheme colorScheme) {
    return Container(
      width: 48,
      height: 48,
      color: colorScheme.surfaceContainerHighest,
      child: Icon(Icons.person, color: colorScheme.outline, size: 24),
    );
  }

  Widget _buildInfo(ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          character.name,
          style: const TextStyle(fontWeight: FontWeight.w600),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 2),
        Text(
          character.species,
          style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant),
        ),
      ],
    );
  }

  Widget _buildChevron(ColorScheme colorScheme) {
    return Icon(
      Icons.chevron_right_rounded,
      color: colorScheme.onSurfaceVariant,
    );
  }
}
