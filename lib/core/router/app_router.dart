import 'package:flutter/material.dart';
import '../../features/characters/presentation/pages/сharacters_page.dart';
import '../../features/characters_details/presentation/pages/character_detail_page.dart';
import '../../features/characters_episodes/presentation/pages/episode_detail_page.dart';

class AppRouter {
  static const String charactersList = '/characters';
  static const String characterDetail = '/character-detail';
  static const String episodeDetail = '/episode-detail';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case charactersList:
        return MaterialPageRoute(builder: (_) => const CharactersPage());

      case characterDetail:
        final args = settings.arguments as Map<String, dynamic>?;
        final characterId = args?['characterId'] as int?;
        if (characterId == null) return _errorRoute('Character ID required');
        return MaterialPageRoute(
          builder: (_) => CharacterDetailPage(characterId: characterId),
        );

      case episodeDetail:
        final args = settings.arguments as Map<String, dynamic>?;
        final episodeId = args?['episodeId'] as int?;
        if (episodeId == null) return _errorRoute('Episode ID required');
        return MaterialPageRoute(
          builder: (_) => EpisodeDetailPage(episodeId: episodeId),
        );

      default:
        return _errorRoute('No route: ${settings.name}');
    }
  }

  static Route<dynamic> _errorRoute(String message) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text(message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: null,
                child: const Text('Go Back'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
