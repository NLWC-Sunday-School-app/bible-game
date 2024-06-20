import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

class ApiException implements Exception {
  final int code;
  final Map<String, dynamic> message;
  static Map<String, dynamic> errorMessage = {};

  ApiException({required this.code, required this.message}) {
    errorMessage = message;
  }

  @override
  String toString() {
    return 'ApiException: $code - $message';
  }

  static void showSnackBar(BuildContext context) {
    String message = '';
    if (errorMessage.containsKey('errors')) {
      message = errorMessage['errors'][0];
    } else {
      message = errorMessage['error'];
    }

    Flushbar(
      message: message,
      flushbarPosition: FlushbarPosition.TOP,
      flushbarStyle: FlushbarStyle.GROUNDED,
      backgroundColor: Colors.red,
      duration: const Duration(seconds: 3),
    ).show(context);
  }
}

class BadRequestException extends ApiException {
  BadRequestException({required Map<String, dynamic> message})
      : super(code: 400, message: message);
}

class UnauthorizedException extends ApiException {
  UnauthorizedException({required Map<String, dynamic> message})
      : super(code: 401, message: message);
}

class ForbiddenException extends ApiException {
  ForbiddenException({required Map<String, dynamic> message})
      : super(code: 403, message: message);
}

class NotFoundException extends ApiException {
  NotFoundException({required Map<String, dynamic> message})
      : super(code: 404, message: message);
}

class InternalServerErrorException extends ApiException {
  InternalServerErrorException({required Map<String, dynamic> message})
      : super(code: 500, message: message);
}

class UnknownApiException extends ApiException {
  UnknownApiException(
      {required int code, required Map<String, dynamic> message})
      : super(code: code, message: message);
}
