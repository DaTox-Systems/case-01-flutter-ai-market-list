import 'package:dio/dio.dart';
import '../error/exceptions.dart';
import 'api_constants.dart';

class ApiClient {
  final Dio _dio;

  ApiClient({Dio? dio})
      : _dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: ApiConstants.baseUrl,
                connectTimeout: ApiConstants.connectTimeout,
                receiveTimeout: ApiConstants.receiveTimeout,
                headers: {'Accept': 'application/json'},
              ),
            );

  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
      );
      return response.data;
    } on DioException catch (e) {
      throw ServerException(
        e.message ?? 'Network communication error (${e.response?.statusCode})',
      );
    } catch (e) {
      throw ServerException('Unexpected network error: $e');
    }
  }
}
