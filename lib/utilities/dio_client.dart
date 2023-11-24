import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';

import '../services/base_url_service.dart';
import 'dio_interceptor.dart';

class DioClient {

  static final DioClient _instance = DioClient._internal();
  late Dio dio;
  factory  DioClient() => _instance;


  DioClient._internal() {
    BaseOptions options = BaseOptions(
      baseUrl: BaseUrlService.baseUrl,
      contentType: 'application/json; charset=utf-8',
      responseType: ResponseType.json,
    );
    dio = Dio(options);
    dio.interceptors.add(DioInterceptor());
// Get:-----------------------------------------------------------------------
    Future<Response> get(
      String url, {
      Map<String, dynamic>? queryParameters,
      Options? options,
      CancelToken? cancelToken,
      ProgressCallback? onReceiveProgress,
    }) async {
      try {
        final Response response = await dio.get(
          url,
          queryParameters: queryParameters,
          options: options,
          cancelToken: cancelToken,
          onReceiveProgress: onReceiveProgress,
        );
        return response;
      } catch (e) {
        rethrow;
      }
    }

// Post:----------------------------------------------------------------------
    Future<Response> post(
      String url, {
      data,
      Map<String, dynamic>? queryParameters,
      Options? options,
      CancelToken? cancelToken,
      ProgressCallback? onSendProgress,
      ProgressCallback? onReceiveProgress,
    }) async {
      try {
        final Response response = await dio.post(
          url,
          data: data,
          queryParameters: queryParameters,
          options: options,
          cancelToken: cancelToken,
          onSendProgress: onSendProgress,
          onReceiveProgress: onReceiveProgress,
        );
        return response;
      } catch (e) {
        rethrow;
      }
    }

    // Patch:-----------------------------------------------------------------------
    Future<Response> patch(
      String url, {
      data,
      Map<String, dynamic>? queryParameters,
      Options? options,
      CancelToken? cancelToken,
      ProgressCallback? onSendProgress,
      ProgressCallback? onReceiveProgress,
    }) async {
      try {
        final Response response = await dio.patch(
          url,
          data: data,
          queryParameters: queryParameters,
          options: options,
          cancelToken: cancelToken,
          onSendProgress: onSendProgress,
          onReceiveProgress: onReceiveProgress,
        );
        return response;
      } catch (e) {
        rethrow;
      }
    }

    // Delete:--------------------------------------------------------------------
    Future<dynamic> delete(
      String url, {
      data,
      Map<String, dynamic>? queryParameters,
      Options? options,
      CancelToken? cancelToken,
      ProgressCallback? onSendProgress,
      ProgressCallback? onReceiveProgress,
    }) async {
      try {
        final Response response = await dio.delete(
          url,
          data: data,
          queryParameters: queryParameters,
          options: options,
          cancelToken: cancelToken,
        );
        return response.data;
      } catch (e) {
        rethrow;
      }
    }
  }
}
