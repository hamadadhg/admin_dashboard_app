import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../config/app_constants.dart';
import 'shared_preferences_helper.dart';

class TokenInterceptor extends Interceptor {
  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    try {
      final token = await SharedPreferencesHelper.getData(key: AppConstants.token);
      // final lang = await SharedPreferencesHelper.getData(key: AppKeys.langNo);
      // final fcm = await SharedPreferencesHelper.getData(key: AppKeys.fbToken);
      //
      // if(fcm == null || fcm.isEmpty) {
      //   await NotificationService().getToken();
      // }

      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
        // options.headers['fcm-token'] = 'Bearer $fcm';
        debugPrint('=====================================================> $token');
        // debugPrint('=====================================================> $fcm');
      } else {
        debugPrint('TokenInterceptor: No token found');
      }

      // options.headers['App-Language'] = lang;

    } catch (e) {
      debugPrint('TokenInterceptor Error: $e');
    }

    super.onRequest(options, handler);
  }
}
