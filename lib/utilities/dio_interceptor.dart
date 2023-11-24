import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';


class DioInterceptor extends Interceptor {

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler)async {
    options.headers = {'Content-Type': 'application/json','accept': 'application/json', 'Authorization': 'Bearer ${GetStorage().read('user_token')}'};
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // TODO: implement onResponse
    super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    // TODO: implement onError
    super.onError(err, handler);
  }

}
