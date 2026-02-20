import 'package:equatable/equatable.dart';
import 'location_info_model.dart';

class CharacterModel extends Equatable {
  final int id;
  final String name;
  final String status;
  final String species;
  final String type;
  final String gender;
  final LocationInfoModel origin;
  final LocationInfoModel location;
  final String image;
  final List<String> episode;
  final String url;
  final String created;

  const CharacterModel({
    required this.id,
    required this.name,
    required this.status,
    required this.species,
    required this.type,
    required this.gender,
    required this.origin,
    required this.location,
    required this.image,
    required this.episode,
    required this.url,
    required this.created,
  });

  @override
  List<Object?> get props => [id, name, status];
}
