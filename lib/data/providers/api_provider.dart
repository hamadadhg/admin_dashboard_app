import 'package:dio/dio.dart';
import 'package:flutter_admin_dashboard/common/shared_preferences_helper.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../config/app_constants.dart';
import '../models/api_response.dart';

class ApiProvider {
  late Dio _dio;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  ApiProvider() {
    _dio = Dio(BaseOptions(
      baseUrl: AppConstants.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Add auth token if available
        String? token = await _storage.read(key: AppConstants.tokenKey);
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
      onError: (error, handler) {
        print('API Error: ${error.message}');
        handler.next(error);
      },
    ));
  }

  // GET request
  Future<ApiResponse<T>> get<T>(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      final response = await _dio.get(
        endpoint,
        queryParameters: queryParameters,
      );

      if (response.statusCode == 200) {
        return ApiResponse.success(
          data: fromJson != null ? fromJson(response.data) : response.data,
          statusCode: response.statusCode,
        );
      } else {
        return ApiResponse.error(
          message: response.data['message'] ?? 'Unknown error occurred',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return ApiResponse.error(
        message: 'Unexpected error: $e',
      );
    }
  }

  // POST request
  Future<ApiResponse<T>> post<T>(String endpoint, dynamic data, // Changed to dynamic
      {Map<String, dynamic>? queryParameters,
      T Function(Map<String, dynamic>)? fromJson,
      String? token} // Added token parameter
      ) async {
    try {
      final response = await _dio.post(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: token != null ? Options(headers: {'Authorization': 'Bearer $token'}) : null,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ApiResponse.success(
          data: fromJson != null ? fromJson(response.data) : response.data,
          statusCode: response.statusCode,
        );
      } else {
        return ApiResponse.error(
          message: response.data['message'] ?? 'Unknown error occurred',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return ApiResponse.error(
        message: 'Unexpected error: $e',
      );
    }
  }

  // POST request with FormData (for file uploads)
  Future<ApiResponse<T>> postFormData<T>(String endpoint,
      {required FormData formData, T Function(Map<String, dynamic>)? fromJson, String? token // Added token parameter
      }) async {
    try {
      final response = await _dio.post(
        endpoint,
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',
          headers: token != null ? {'Authorization': 'Bearer $token'} : null,
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ApiResponse.success(
          data: fromJson != null ? fromJson(response.data) : response.data,
          statusCode: response.statusCode,
        );
      } else {
        return ApiResponse.error(
          message: response.data['message'] ?? 'Unknown error occurred',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return ApiResponse.error(
        message: 'Unexpected error: $e',
      );
    }
  }

  // DELETE request
  Future<ApiResponse<T>> delete<T>(String endpoint,
      {Map<String, dynamic>? queryParameters, T Function(Map<String, dynamic>)? fromJson, String? token // Added token parameter
      }) async {
    try {
      final response = await _dio.delete(
        endpoint,
        queryParameters: queryParameters,
        options: token != null ? Options(headers: {'Authorization': 'Bearer $token'}) : null,
      );

      if (response.statusCode == 200) {
        return ApiResponse.success(
          data: fromJson != null ? fromJson(response.data) : response.data,
          statusCode: response.statusCode,
        );
      } else {
        return ApiResponse.error(
          message: response.data['message'] ?? 'Unknown error occurred',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return ApiResponse.error(
        message: 'Unexpected error: $e',
      );
    }
  }

  // Handle Dio errors
  ApiResponse<T> _handleDioError<T>(DioException error) {
    String message = 'Network error occurred';
    Map<String, dynamic>? errors;

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        message = 'Connection timeout';
        break;
      case DioExceptionType.sendTimeout:
        message = 'Send timeout';
        break;
      case DioExceptionType.receiveTimeout:
        message = 'Receive timeout';
        break;
      case DioExceptionType.badResponse:
        if (error.response?.data != null) {
          message = error.response!.data['message'] ?? 'Server error';
          errors = error.response!.data['errors'];
        }
        break;
      case DioExceptionType.cancel:
        message = 'Request cancelled';
        break;
      case DioExceptionType.unknown:
        message = 'Unknown error occurred';
        break;
      case DioExceptionType.badCertificate: // Added missing case
        message = 'Bad certificate';
        break;
      default:
        message = 'Unknown error occurred';
    }

    return ApiResponse.error(
      message: message,
      errors: errors,
      statusCode: error.response?.statusCode,
    );
  }

  // Save auth token
  Future<void> saveToken(String token) async {
    SharedPreferencesHelper.saveData(key: AppConstants.token, value: token);
    await _storage.write(key: AppConstants.tokenKey, value: token);
  }

  // Get auth token
  Future<String?> getToken() async {
    return await _storage.read(key: AppConstants.tokenKey);
  }

  // Clear auth token
  Future<void> clearToken() async {
    await _storage.delete(key: AppConstants.tokenKey);
  }
}
