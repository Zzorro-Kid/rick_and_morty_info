import '../../domain/entities/location_info_model.dart';

class LocationInfoDataModel extends LocationInfoModel {
  const LocationInfoDataModel({required super.name, required super.url});

  factory LocationInfoDataModel.fromJson(Map<String, dynamic> json) {
    return LocationInfoDataModel(
      name: json['name'] as String? ?? '',
      url: json['url'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'url': url};
  }
}
