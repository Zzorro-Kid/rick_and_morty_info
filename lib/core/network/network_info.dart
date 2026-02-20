import 'dart:developer';
import 'package:http/http.dart' as http;
import '../constants/api_constants.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  @override
  Future<bool> get isConnected async {
    try {
      final response = await http
          .head(Uri.parse(ApiConstants.baseUrl))
          .timeout(ApiConstants.connectivityCheckTimeout);

      return response.statusCode >= 100 && response.statusCode < 600;
    } catch (e) {
      log('Error checking internet connection: $e');
      return false;
    }
  }
}
