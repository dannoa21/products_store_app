import 'package:dio/dio.dart';
import 'package:products_store_app/core/network/network_base_service.dart';

/// Implementation of NetworkBaseService
class NetworkImplService implements NetworkBaseService {
  final Dio _dio = Dio();

  @override
  Future<dynamic> get({
    required String url,
    required Map<String, dynamic> parameters,
  }) async {
    try {
      final response = await _dio.get(url, queryParameters: parameters);

      // Return response data directly
      return response.data;
    } on DioException catch (e) {
      // Basic error handling
      throw Exception(
        'Network GET request failed: ${e.response?.statusCode} ${e.message}',
      );
    } catch (e) {
      throw Exception('Unexpected error in GET request: $e');
    }
  }
}
