/// Base class defining network operations
abstract class NetworkBaseService {
  /// Performs a GET request
  Future<dynamic> get({
    required String url,
    required Map<String, dynamic> parameters,
  });
}
