import 'package:equatable/equatable.dart';

class LocationInfoModel extends Equatable {
  final String name;
  final String url;

  const LocationInfoModel({required this.name, required this.url});

  @override
  List<Object?> get props => [name, url];
}
