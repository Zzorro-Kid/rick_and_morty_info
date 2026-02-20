import 'package:equatable/equatable.dart';
import '../../../../characters/domain/entities/character_model.dart';

sealed class CharacterDetailState extends Equatable {
  const CharacterDetailState();

  @override
  List<Object?> get props => [];
}

class CharacterDetailInitial extends CharacterDetailState {}

class CharacterDetailLoading extends CharacterDetailState {}

class CharacterDetailLoaded extends CharacterDetailState {
  final CharacterModel character;

  const CharacterDetailLoaded(this.character);

  @override
  List<Object?> get props => [character];
}

class CharacterDetailError extends CharacterDetailState {
  final String message;

  const CharacterDetailError(this.message);

  @override
  List<Object?> get props => [message];
}
