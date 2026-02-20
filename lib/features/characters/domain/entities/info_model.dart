import 'package:equatable/equatable.dart';

class InfoModel extends Equatable {
  final int count;
  final int pages;
  final String? next;
  final String? prev;

  const InfoModel({
    required this.count,
    required this.pages,
    this.next,
    this.prev,
  });

  @override
  List<Object?> get props => [count, pages, next, prev];
}
