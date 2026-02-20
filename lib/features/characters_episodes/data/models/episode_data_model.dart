import '../../domain/entities/episode_model.dart';

class EpisodeDataModel extends EpisodeModel {
  const EpisodeDataModel({
    required super.id,
    required super.name,
    required super.airDate,
    required super.episode,
    required super.characters,
    required super.url,
    required super.created,
  });

  factory EpisodeDataModel.fromJson(Map<String, dynamic> json) {
    return EpisodeDataModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      airDate: json['air_date'] as String? ?? '',
      episode: json['episode'] as String? ?? '',
      characters: (json['characters'] as List<dynamic>)
          .map((e) => e.toString())
          .toList(),
      url: json['url'] as String? ?? '',
      created: json['created'] as String? ?? '',
    );
  }
}
