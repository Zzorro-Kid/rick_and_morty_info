import 'package:flutter/material.dart';
import '../../../../core/router/app_router.dart';

class NavigationHelper {
  static void navigateToCharacterDetail(BuildContext context, int characterId) {
    Navigator.pushNamed(
      context,
      AppRouter.characterDetail,
      arguments: {'characterId': characterId},
    );
  }

  static void navigateToEpisodeDetail(BuildContext context, int episodeId) {
    Navigator.pushNamed(
      context,
      AppRouter.episodeDetail,
      arguments: {'episodeId': episodeId},
    );
  }
}
