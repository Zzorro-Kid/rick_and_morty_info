import 'package:flutter/material.dart';
import '../../features/characters_details/presentation/pages/character_detail_page.dart';
import '../../features/characters_episodes/presentation/pages/episode_detail_page.dart';

class NavigationHelper {
  static void navigateToCharacterDetail(BuildContext context, int characterId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CharacterDetailPage(characterId: characterId),
      ),
    );
  }

  static void navigateToEpisodeDetail(BuildContext context, int episodeId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EpisodeDetailPage(episodeId: episodeId),
      ),
    );
  }
}
