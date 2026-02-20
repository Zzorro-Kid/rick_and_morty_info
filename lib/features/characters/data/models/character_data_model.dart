import '../../domain/entities/character_model.dart';
import 'location_info_data_model.dart';

class CharacterDataModel extends CharacterModel {
  const CharacterDataModel({
    required super.id,
    required super.name,
    required super.status,
    required super.species,
    required super.type,
    required super.gender,
    required super.origin,
    required super.location,
    required super.image,
    required super.episode,
    required super.url,
    required super.created,
  });

  factory CharacterDataModel.fromJson(Map<String, dynamic> json) {
    return CharacterDataModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      status: json['status'] as String? ?? '',
      species: json['species'] as String? ?? '',
      type: json['type'] as String? ?? '',
      gender: json['gender'] as String? ?? '',
      origin: LocationInfoDataModel.fromJson(json['origin']),
      location: LocationInfoDataModel.fromJson(json['location']),
      image: json['image'] as String? ?? '',
      episode: (json['episode'] as List<dynamic>)
          .map((e) => e.toString())
          .toList(),
      url: json['url'] as String? ?? '',
      created: json['created'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'status': status,
      'species': species,
      'type': type,
      'gender': gender,
      'origin': (origin as dynamic).toJson(),
      'location': (location as dynamic).toJson(),
      'image': image,
      'episode': episode,
      'url': url,
      'created': created,
    };
  }
}
