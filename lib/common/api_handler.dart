import 'package:dio/dio.dart';
import 'package:flutter_admin_dashboard/common/typedef.dart';

import 'failure.dart';

mixin HandlingApiManager {
  Future<T> wrapHandlingApi<T>({required Future<Response> Function() tryCall, required FromJson<T> jsonConvert}) async {
    final response = await tryCall();
    if (response.statusCode == 200 || response.statusCode == 201 || response.statusCode == 202 || response.statusCode == 203 || response.statusCode == 204) {
      return jsonConvert(response.data);
    } else if (response.statusCode == 401) {
      throw UnauthenticatedFailure(
        message: response.data["message"].toString(),
      );
    } else if (response.statusCode == 403) {
      throw UserBlockedFailure(
        message: response.data["message"].toString(),
      );
    } else {
      throw ServerFailure(
        message: response.data["message"].toString(),
        statusCode: response.statusCode,
      );
    }
  }
}
