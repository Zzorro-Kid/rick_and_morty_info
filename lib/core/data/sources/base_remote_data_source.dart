import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../errors/exceptions.dart';

abstract class BaseRemoteDataSource {
  final http.Client client;

  const BaseRemoteDataSource({required this.client});

  Future<http.Response> get(Uri url) async {
    try {
      return await client.get(url);
    } on http.ClientException catch (e) {
      throw NetworkException('No internet connection: ${e.message}');
    }
  }

  Map<String, dynamic> handleObjectResponse(http.Response response) {
    final statusCode = response.statusCode;
    final responseBody = response.body.isEmpty ? '{}' : response.body;

    switch (statusCode) {
      case 200:
        return jsonDecode(responseBody) as Map<String, dynamic>;
      default:
        _handleError(responseBody: responseBody, statusCode: statusCode);
        return {};
    }
  }

  List<dynamic> handleListResponse(http.Response response) {
    final statusCode = response.statusCode;
    final responseBody = response.body.isEmpty ? '[]' : response.body;

    switch (statusCode) {
      case 200:
        return jsonDecode(responseBody) as List<dynamic>;
      default:
        _handleError(responseBody: responseBody, statusCode: statusCode);
        return [];
    }
  }

  void _handleError({required String responseBody, required int statusCode}) {
    switch (statusCode) {
      case 404:
        throw NotFoundException('Resource not found');
      case 400:
        throw ServerException('Bad request', statusCode);
      case 401:
        throw ServerException('Unauthorized', statusCode);
      case 403:
        throw ServerException('Forbidden', statusCode);
      case 500:
      case 502:
      case 503:
        throw ServerException('Server error', statusCode);
      default:
        throw UnexpectedException(errorCode: statusCode);
    }
  }
}
