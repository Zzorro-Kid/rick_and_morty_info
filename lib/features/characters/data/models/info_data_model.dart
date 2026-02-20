import '../../domain/entities/info_model.dart';

class InfoDataModel extends InfoModel {
  const InfoDataModel({
    required super.count,
    required super.pages,
    super.next,
    super.prev,
  });

  factory InfoDataModel.fromJson(Map<String, dynamic> json) {
    return InfoDataModel(
      count: json['count'] as int? ?? 0,
      pages: json['pages'] as int? ?? 0,
      next: json['next'] as String?,
      prev: json['prev'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'count': count, 'pages': pages, 'next': next, 'prev': prev};
  }
}
