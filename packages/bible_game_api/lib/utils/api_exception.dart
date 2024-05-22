class ApiException implements Exception {
  final int code;
  final String message;

  ApiException({required this.code, required this.message});

  @override
  String toString() {
    return 'ApiException: $code - $message';
  }
}

class BadRequestException extends ApiException {
  BadRequestException({required String message})
      : super(code: 400, message: message);
}

class UnauthorizedException extends ApiException {
  UnauthorizedException({required String message})
      : super(code: 401, message: message);
}

class ForbiddenException extends ApiException {
  ForbiddenException({required String message})
      : super(code: 403, message: message);
}

class NotFoundException extends ApiException {
  NotFoundException({required String message})
      : super(code: 404, message: message);
}

class InternalServerErrorException extends ApiException {
  InternalServerErrorException({required String message})
      : super(code: 500, message: message);
}

class UnknownApiException extends ApiException {
  UnknownApiException({required int code, required String message})
      : super(code: code, message: message);
}
