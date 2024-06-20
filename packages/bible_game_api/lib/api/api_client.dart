import 'package:dio/dio.dart';

import '../utils/api_exception.dart';

class ApiClient {
  final String baseUrl;
  final Dio dio;
  String? token;

  ApiClient({required this.baseUrl, required this.token,})
      : dio = Dio(BaseOptions(baseUrl: baseUrl)) {
    _setupInterceptors();
  }

  void updateToken(String newToken) {
    token = newToken;
  }

  void _setupInterceptors() {
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        options.headers = {
          'Content-Type': 'application/json',
          'accept': '*/*',
          'Authorization': 'Bearer $token'
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
      return await dio.post(endpoint, data: data);
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  Response _handleError(DioException error) {
    final response = error.response;
    if (response != null) {
      switch (response.statusCode) {
        case 400:
          throw BadRequestException(message: response.data);
        case 401:
          throw UnauthorizedException(message: response.data);
        case 403:
          throw ForbiddenException(message: response.data);
        case 404:
          throw NotFoundException(message: response.data);
        case 500:
          throw InternalServerErrorException(message: response.data);
        default:
          throw UnknownApiException(
              code: response.statusCode!, message: response.data);
      }
    } else {
      throw ApiException(
        code: error.response?.statusCode ?? -1,
        message: response?.data,
      );
    }
  }
}
