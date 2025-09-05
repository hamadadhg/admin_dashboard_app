class ApiResponse<T> {
  final bool success;
  final String message;
  final T? data;
  final Map<String, dynamic>? errors;
  final int? statusCode;

  ApiResponse({
    required this.success,
    required this.message,
    this.data,
    this.errors,
    this.statusCode,
  });

  factory ApiResponse.success({
    required T data,
    String message = 'Success',
    int? statusCode,
  }) {
    return ApiResponse<T>(
      success: true,
      message: message,
      data: data,
      statusCode: statusCode,
    );
  }

  factory ApiResponse.error({
    required String message,
    Map<String, dynamic>? errors,
    int? statusCode,
  }) {
    return ApiResponse<T>(
      success: false,
      message: message,
      errors: errors,
      statusCode: statusCode,
    );
  }

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>)? fromJsonT,
  ) {
    return ApiResponse<T>(
      success: json['success'] ?? true,
      message: json['message'] ?? '',
      data: fromJsonT != null && json['data'] != null
          ? fromJsonT(json['data'])
          : null,
      errors: json['errors'],
      statusCode: json['statusCode'],
    );
  }

  @override
  String toString() {
    return 'ApiResponse(success: $success, message: $message, data: $data, errors: $errors, statusCode: $statusCode)';
  }
}
