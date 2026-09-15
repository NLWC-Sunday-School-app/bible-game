import 'package:dio/dio.dart';

import '../utils/api_exception.dart';

class ApiClient {
  final String baseUrl;
  final Dio dio;
  String? token;

  ApiClient({required this.baseUrl, required this.token,})
      : dio = Dio(BaseOptions(
          baseUrl: baseUrl,
          // Without these Dio has no timeouts, so a request against an
          // unreachable host reports failure against a zero duration --
          // "took longer than 0:00:00.000000", which reads like a
          // misconfiguration rather than a server that is not answering.
          connectTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 30),
          sendTimeout: const Duration(seconds: 30),
        )) {
    _setupInterceptors();
  }

  void updateToken(String newToken) {
    token = newToken;
  }

  void _setupInterceptors() {
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        options.headers = {
          'Content-Type': 'application/json; charset=UTF-8',
          'accept': '*/*',
          if (token != null && token!.isNotEmpty)
            'Authorization': 'Bearer $token',
        };
        return handler.next(options); // Continue
      },
      onResponse: (response, handler) {
        return handler.next(response); // Continue
      },
      onError: (DioException e, handler) {
        return handler.next(e); // Continue
      },
    ));
  }

  Future<Response> get(String endpoint) async {
    try {
      return await dio.get(endpoint);
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  Future<Response> post(String endpoint,
      {required Map<String, dynamic> data}) async {
    try {
      return await dio.post(endpoint, data: data);
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  Future<Response> patch(String endpoint,
      {required Map<String, dynamic> data}) async {
    try {
      return await dio.patch(endpoint, data: data);
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  Future<Response> delete(String endpoint) async {
    try {
      return await dio.delete(endpoint);
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  Response _handleError(DioException error) {
    final response = error.response;
    Map<String, dynamic> toMap(dynamic data) {
      if (data is Map<String, dynamic>) return data;
      return {'error': data?.toString() ?? 'An error occurred'};
    }

    if (response != null) {
      switch (response.statusCode) {
        case 400:
          throw BadRequestException(message: toMap(response.data));
        case 401:
          throw UnauthorizedException(message: toMap(response.data));
        case 403:
          throw ForbiddenException(message: toMap(response.data));
        case 404:
          throw NotFoundException(message: toMap(response.data));
        case 500:
          throw InternalServerErrorException(message: toMap(response.data));
        default:
          throw UnknownApiException(
              code: response.statusCode!, message: toMap(response.data));
      }
    } else {
      // Dio's own text names internals the user cannot act on. Say what
      // actually happened instead.
      final reason = switch (error.type) {
        DioExceptionType.connectionTimeout ||
        DioExceptionType.connectionError =>
          'Could not reach the server. Check your connection and try again.',
        DioExceptionType.receiveTimeout ||
        DioExceptionType.sendTimeout =>
          'The server took too long to respond. Please try again.',
        DioExceptionType.cancel => 'Request cancelled.',
        _ => 'Network error. Check your connection.',
      };
      throw ApiException(code: -1, message: {'error': reason});
    }
  }
}
