import 'package:dio/dio.dart';
import 'package:eagle_eye_admin/service/storage/storage_service.dart';

class TokenInterceptor extends Interceptor {
  @override
  onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    options.headers['Authorization'] = 'Bearer ${StorageService.getToken()}';
    options.headers['Access-Control-Allow-Origin'] = '*';
    return handler.next(options);
  }
}
