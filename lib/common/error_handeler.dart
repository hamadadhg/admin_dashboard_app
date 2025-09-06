import 'dart:core';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import 'error_model.dart';
import 'failure.dart';

mixin HandlingException {
  Future<Either<Failure, T>> wrapHandlingException<T>(
      {required Future<T> Function() tryCall}) async {
    try {
      final result = await tryCall();
      return Right(result);
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }
}

class ErrorHandler implements Exception {
  late Failure failure;

  ErrorHandler.handle(error) {
    if (error is DioException) {
      failure = _handleError(error);
    } else {
      failure = ServerFailure(
        message: error.toString(),
        statusCode: ResponseCode.badRequestServer,
      );
    }
  }

  Failure _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return DataSource.connectTimeOut.getFailure();
      case DioExceptionType.sendTimeout:
        return DataSource.sendTimeOut.getFailure();
      case DioExceptionType.receiveTimeout:
        return DataSource.receiveTimeOut.getFailure();
      case DioExceptionType.cancel:
        return DataSource.cancel.getFailure();
      case DioExceptionType.unknown:
        return DataSource.Default.getFailure();
      case DioExceptionType.badCertificate:
        return DataSource.badRequest.getFailure();
      case DioExceptionType.connectionError:
        return DataSource.noInternetConnection.getFailure();
      case DioExceptionType.badResponse:
        switch (error.response?.statusCode) {
          case ResponseCode.internalServerError:
            return DataSource.internetServerError.getFailure();
          case ResponseCode.notFound:
            return DataSource.notFound.getFailure();
          case ResponseCode.forBidden:
            return DataSource.forBidden.getFailure();
          case ResponseCode.blocked:
            return const UserBlockedFailure(
                message: AppConstantsV2.blockedError);
          case ResponseCode.notAllowed:
            return const UserNotAllowedFailure(
                message: AppConstantsV2.notAllowed);
          case ResponseCode.badContent:
            return ServerFailure(
                message: ErrorMessageModel.fromJson(error.response?.data)
                    .statusMessage,
                statusCode: ResponseCode.badContent);
          case ResponseCode.badRequestServer:
            return ServerFailure(
                message: ErrorMessageModel.fromJson(error.response?.data)
                    .statusMessage,
                statusCode: ResponseCode.badRequestServer);
          default:
            return ServerFailure(
              message: error.response?.data["message"].toString() ??
                  error.response?.data["errors"]?.toString() ??
                  '',
              statusCode: error.response?.statusCode ?? ResponseCode.badRequest,
            );
        }
    }
  }
}

extension DataSourceExtension on DataSource {
  Failure getFailure() {
    switch (this) {
      case DataSource.success:
        return const ServerFailure(
            statusCode: ResponseCode.success, message: ResponseMessage.SUCCESS);
      case DataSource.noInternet:
        return const ServerFailure(
            statusCode: ResponseCode.noContent,
            message: ResponseMessage.NO_CONTENT);
      case DataSource.badRequest:
        return const ServerFailure(
            statusCode: ResponseCode.badRequest,
            message: ResponseMessage.BAD_REQUEST);
      case DataSource.forBidden:
        return const ServerFailure(
            statusCode: ResponseCode.forBidden,
            message: ResponseMessage.FORBIDDEN);
      case DataSource.unAuthorized:
        return const ServerFailure(
            statusCode: ResponseCode.unAuthorized,
            message: ResponseMessage.UNAUTORISED);
      case DataSource.notFound:
        return const ServerFailure(
            statusCode: ResponseCode.notFound,
            message: ResponseMessage.NOT_FOUND);
      case DataSource.internetServerError:
        return const ServerFailure(
            statusCode: ResponseCode.internalServerError,
            message: ResponseMessage.INTERNAL_SERVER_ERROR);
      case DataSource.connectTimeOut:
        return const ServerFailure(
            statusCode: ResponseCode.connectTimeOut,
            message: ResponseMessage.CONNECT_TIMEOUT);
      case DataSource.cancel:
        return const ServerFailure(
            statusCode: ResponseCode.cancel, message: ResponseMessage.CANCEL);
      case DataSource.receiveTimeOut:
        return const ServerFailure(
            statusCode: ResponseCode.receiveTimeOut,
            message: ResponseMessage.RECIEVE_TIMEOUT);
      case DataSource.sendTimeOut:
        return const ServerFailure(
            statusCode: ResponseCode.sendTimeOut,
            message: ResponseMessage.SEND_TIMEOUT);
      case DataSource.cashError:
        return const ServerFailure(
            statusCode: ResponseCode.cashError,
            message: ResponseMessage.CACHE_ERROR);
      case DataSource.noInternetConnection:
        return const ServerFailure(
            statusCode: ResponseCode.noInternetConnection,
            message: ResponseMessage.NO_INTERNET_CONNECTION);
      case DataSource.Default:
        return const ServerFailure(
            statusCode: ResponseCode.Default, message: ResponseMessage.DEFAULT);
    }
  }
}

class ResponseCode {
  static const int success = 200; // success with data
  static const int noContent = 201; // success with no data (no content)
  static const int badRequest = 400; // ServerFailure, API rejected request
  static const int unAuthorized = 401; // failure, user is not authorised
  static const int forBidden = 403; //  failure, API rejected request
  static const int internalServerError = 500; // failure, crash in server side
  static const int notFound = 404; // failure, not found
  static const int notAllowed = 405; // failure, not allowed
  static const int blocked = 420; // failure,blocked
  static const int badContent = 422; // failure, Bad_Content
  static const int badRequestServer =
      402; // ServerFailure, API rejected request

  // local status code
  static const int connectTimeOut = -1;
  static const int cancel = -2;
  static const int receiveTimeOut = -3;
  static const int sendTimeOut = -4;
  static const int cashError = -5;
  static const int noInternetConnection = -6;
  static const int Default = -7;
}

class ResponseMessage {
  static const String SUCCESS = AppConstantsV2.success; // success with data
  static const String NO_CONTENT =
      AppConstantsV2.success; // success with no data (no content)
  static const String BAD_REQUEST =
      AppConstantsV2.badRequestError; // failure, API rejected request
  static const String UNAUTORISED =
      AppConstantsV2.unauthorizedError; // failure, user is not authorised
  static const String FORBIDDEN =
      AppConstantsV2.forbiddenError; //  failure, API rejected request
  static const String INTERNAL_SERVER_ERROR =
      AppConstantsV2.internalServerError; // failure, crash in server side
  static const String NOT_FOUND =
      AppConstantsV2.notFoundError; // failure, crash in server side

  // local status code
  static const String CONNECT_TIMEOUT = AppConstantsV2.timeoutError;
  static const String CANCEL = AppConstantsV2.defaultError;
  static const String RECIEVE_TIMEOUT = AppConstantsV2.timeoutError;
  static const String SEND_TIMEOUT = AppConstantsV2.timeoutError;
  static const String CACHE_ERROR = AppConstantsV2.cacheError;
  static const String NO_INTERNET_CONNECTION = AppConstantsV2.noInternetError;
  static const String DEFAULT = AppConstantsV2.defaultError;
}

class AppConstantsV2 {
  AppConstantsV2._();

  // error handler
  static const String success = 'success';
  static const String badRequestError = 'Bad request';
  static const String noContent = 'No Content';
  static const String forbiddenError = 'Forbidden user';
  static const String unauthorizedError =
      'Un Authorized user'; //"unauthorized_error";
  static const String notFoundError = '404 not found';
  static const String conflictError = 'Conflict Error';
  static const String blockedError = 'Blocked User';
  static const String internalServerError =
      'Server Error'; //"internal_server_error";
  static const String notAllowed = 'Not allowed'; //"internal_server_error";

  static const String unknownError = 'Error';
  static const String timeoutError = 'Timed Out Error'; //"timeout_error"
  static const String defaultError = 'Error';
  static const String cacheError = 'No Cash Error';
  static const String noInternetError = 'You are offline'; //"no_internet_error"
}

class ApiInternalStatus {
  static const int SUCCESS = 0;
  static const int FAILURE = 1;
}

// ignore_for_file: constant_identifier_names
enum DataSource {
  success,
  noInternet,
  badRequest,
  forBidden,
  unAuthorized,
  notFound,
  internetServerError,
  connectTimeOut,
  cancel,
  receiveTimeOut,
  sendTimeOut,
  cashError,
  noInternetConnection,
  Default,
}
