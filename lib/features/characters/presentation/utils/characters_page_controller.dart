import 'package:flutter/material.dart';
import '../../../../core/router/app_router.dart';
import '../cubit/characters/characters_cubit.dart';

class CharactersPageController {
  CharactersPageController({
    required CharactersCubit cubit,
    required this.onLoadMoreError,
  }) : _cubit = cubit;

  final CharactersCubit _cubit;
  final void Function(BuildContext context) onLoadMoreError;

  final ScrollController scrollController = ScrollController();
  final TextEditingController searchController = TextEditingController();

  void init() {
    scrollController.addListener(_onScroll);
    _cubit.fetchCharacters();
  }

  void dispose() {
    scrollController.dispose();
    searchController.dispose();
  }

  void _onScroll() {
    final position = scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 200) {
      _cubit.fetchNextPage();
    }
  }

  void onSearchChanged(String query) {
    _cubit.fetchCharacters(query: query);
  }

  void onClearSearch() {
    searchController.clear();
    onSearchChanged('');
  }

  void onRetry(String query) {
    _cubit.fetchCharacters(query: query);
  }

  void onCharacterTap(BuildContext context, dynamic character) {
    Navigator.pushNamed(
      context,
      AppRouter.characterDetail,
      arguments: {'characterId': character.id},
    );
  }
}
