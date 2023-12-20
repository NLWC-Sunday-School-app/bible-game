import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:bible_game/controllers/auth_controller.dart';

class DioExceptions implements Exception {
  late String message;
  final AuthController _authController = Get.put(AuthController());

  DioExceptions.fromDioError(DioError dioError) {
    print('dioError, ${dioError.requestOptions.uri}');
    print('dioError message, ${dioError.message}');
    print('dioError response, ${dioError.response}');
    switch (dioError.type) {
      case DioErrorType.cancel:
        message = "Request to API server was cancelled";
        break;
      case DioErrorType.connectionTimeout:
        message = "Connection timeout with API server";
        break;
      case DioErrorType.receiveTimeout:
        message = "Receive timeout in connection with API server";
        break;
      case DioErrorType.badResponse:
        message = _handleError(
          dioError.response?.statusCode,
          dioError.response?.data,
        );
        break;
      case DioErrorType.sendTimeout:
        message = "Send timeout in connection with API server";
        break;
      case DioErrorType.unknown:
        if (dioError.message!.contains("SocketException")) {
          message = 'No Internet';
          break;
        }
        message = "Unexpected error occurred";
        break;
      default:
        message = "Something went wrong";
        break;
    }
  }

  String _handleError(int? statusCode, dynamic error) {
    print('status code: $statusCode');
    print('error: ${error.runtimeType}');
    print('errors: ${error['errors'][0]}');
    switch (statusCode) {
      case 400:
        if (error.runtimeType.toString() ==
            '_InternalLinkedHashMap<String, dynamic>') {
          Get.snackbar('Error', error['errors'][0],
              backgroundColor: Colors.red,
              colorText: Colors.white,
              duration: const Duration(seconds: 3),
              snackPosition: SnackPosition.TOP);
        } else {
          Get.snackbar('Error', error,
              backgroundColor: Colors.red,
              colorText: Colors.white,
              duration: const Duration(seconds: 3),
              snackPosition: SnackPosition.TOP);
        }

        return 'Bad request';
      case 401:
        Get.snackbar(
          'Unauthorized',
          error,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
          snackPosition: SnackPosition.TOP,
        );
        _authController.resetAppData();
        return 'Unauthorized';
      case 403:
        return 'Forbidden';
      case 404:
        print('error: $error');
        return error['error'];
      case 500:
        Get.snackbar('Oops', 'An error occurred',
            backgroundColor: Colors.red,
            colorText: Colors.white,
            duration: const Duration(seconds: 4),
            snackPosition: SnackPosition.TOP);
        _authController.resetAppData();
        return 'Internal server error';
      case 502:
        return 'Bad gateway';
      default:
        return 'Oops something went wrong';
    }
  }

  @override
  String toString() => message;
}
