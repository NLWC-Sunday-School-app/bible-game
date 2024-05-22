import 'package:dio/dio.dart';

import '../utils/api_exception.dart';

class ApiClient {
  final String baseUrl;
  final Dio dio;

  ApiClient({required this.baseUrl})
      : dio = Dio(BaseOptions(baseUrl: baseUrl)) {
    _setupInterceptors();
  }

  void _setupInterceptors() {
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        options.headers = {
          'Content-Type': 'application/json',
          'accept': '*/*',
          'Authorization': 'Bearer '
        };
        return handler.next(options); // Continue
      },
      onResponse: (response, handler) {
        return handler.next(response); // Continue
      },
      onError: (DioError e, handler) {
        return handler.next(e); // Continue
      },
    ));
  }

  Future<Response> get(String endpoint) async {
    try {
      return await dio.get(endpoint);
    } on DioError catch (e) {
      return _handleError(e);
    }
  }

  Future<Response> post(String endpoint,
      {required Map<String, dynamic> data}) async {
    try {
      return await dio.post(endpoint, data: data);
    } on DioError catch (e) {
      return _handleError(e);
    }
  }

  Response _handleError(DioError error) {
    final response = error.response;

    if (response != null) {
      switch (response.statusCode) {
        case 400:
          throw BadRequestException(message: response.data.toString());
        case 401:
          throw UnauthorizedException(message: response.data.toString());
        case 403:
          throw ForbiddenException(message: response.data.toString());
        case 404:
          throw NotFoundException(message: response.data.toString());
        case 500:
          throw InternalServerErrorException(message: response.data.toString());
        default:
          throw UnknownApiException(
              code: response.statusCode!, message: response.data.toString());
      }
    } else {
      throw ApiException(
        code: error.response?.statusCode ?? -1,
        message: error.message!,
      );
    }
  }
}
