import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../injection_container.dart';
import '../cubit/characters/characters_cubit.dart';
import '../utils/characters_page_controller.dart';
import '../widgets/character_card.dart';

class CharactersPage extends StatefulWidget {
  const CharactersPage({super.key});

  @override
  State<CharactersPage> createState() => _CharactersPageState();
}

class _CharactersPageState extends State<CharactersPage> {
  late CharactersCubit _cubit;
  late CharactersPageController _controller;

  @override
  void initState() {
    super.initState();
    _cubit = sl<CharactersCubit>();
    _controller = CharactersPageController(
      cubit: _cubit,
      onLoadMoreError: _onLoadMoreError,
    );
    _controller.init();
  }

  void _onLoadMoreError(BuildContext context) {
    final errorMessage = _cubit.state.errorMessage;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(errorMessage ?? 'Ошибка загрузки')));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: BlocListener<CharactersCubit, CharactersState>(
        listenWhen: (prev, curr) =>
            curr.status == CharactersStatus.success &&
            curr.errorMessage != null &&
            prev.errorMessage != curr.errorMessage,
        listener: (context, state) => _onLoadMoreError(context),
        child: Scaffold(
          appBar: _buildAppBar(),
          body: BlocBuilder<CharactersCubit, CharactersState>(
            builder: _buildBody,
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text('Rick & Morty'),
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      scrolledUnderElevation: 0,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: _buildSearchField(),
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _controller.searchController,
      onChanged: _controller.onSearchChanged,
      decoration: InputDecoration(
        hintText: 'Поиск по имени...',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: _controller.searchController.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: _controller.onClearSearch,
              )
            : null,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, CharactersState state) {
    if (state.characters.isNotEmpty) {
      return _buildList(context, state);
    }

    return switch (state.status) {
      CharactersStatus.loading => const Center(
        child: CircularProgressIndicator(),
      ),
      CharactersStatus.failure => _buildError(state),
      _ => const Center(child: Text('Ничего не найдено')),
    };
  }

  Widget _buildError(CharactersState state) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.red),
          const SizedBox(height: 12),
          Text(state.errorMessage ?? 'Что-то пошло не так'),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () => _controller.onRetry(state.query),
            child: const Text('Повторить'),
          ),
        ],
      ),
    );
  }

  Widget _buildList(BuildContext context, CharactersState state) {
    return ListView.builder(
      controller: _controller.scrollController,
      itemCount: state.characters.length + 1,
      itemBuilder: (context, index) => _buildListItem(context, state, index),
    );
  }

  Widget _buildListItem(
    BuildContext context,
    CharactersState state,
    int index,
  ) {
    if (index == state.characters.length) {
      return _buildListFooter(state);
    }

    final character = state.characters[index];
    return CharacterCard(
      character: character,
      onTap: () => _controller.onCharacterTap(context, character),
    );
  }

  Widget _buildListFooter(CharactersState state) {
    if (state.status == CharactersStatus.loadingMore) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (!state.hasNextPage) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Center(child: Text('Это все персонажи')),
      );
    }

    return const SizedBox.shrink();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
