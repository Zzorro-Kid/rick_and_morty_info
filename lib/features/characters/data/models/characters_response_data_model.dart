import '../../domain/entities/characters_response_model.dart';
import 'character_data_model.dart';
import 'info_data_model.dart';

class CharactersResponseDataModel extends CharactersResponseModel {
  const CharactersResponseDataModel({
    required super.info,
    required super.results,
  });

  factory CharactersResponseDataModel.fromJson(Map<String, dynamic> json) {
    return CharactersResponseDataModel(
      info: InfoDataModel.fromJson(json['info']),
      results: (json['results'] as List<dynamic>)
          .map((e) => CharacterDataModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'info': (info as dynamic).toJson(),
      'results': results.map((e) => (e as dynamic).toJson()).toList(),
    };
  }
}
