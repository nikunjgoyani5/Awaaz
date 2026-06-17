import 'package:eagle_eye_admin/utils/app_constants.dart';
import 'package:logic_go_network/network.dart';
import 'package:dio/dio.dart';


class ApiControllerMain {
  static final ApiControllerMain _apiController = ApiControllerMain._internal();

  factory ApiControllerMain() {
    return _apiController;
  }

  ApiControllerMain._internal();

  static late Dio dio;

  static void init() {
    restClient = RestClient(baseUrl: baseUrl, token: token, connectionTO: 30000, receiveTO: 30000);

    dio = Dio();
    // dio.options.baseUrl = 'http://139.59.36.221:8001';
    dio.options.baseUrl = 'https://awaazeye.com';
    dio.options.connectTimeout = const Duration(seconds: 3);
    dio.options.receiveTimeout = const Duration(seconds: 10);

    // add dio interceptor
    dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      error: true,
      request: true,
      requestHeader: true,
      responseHeader: true,
    ));

    // add dio interceptor for insert token on api call time
    // dio.interceptors.add(TokenInterceptor());
  }

  // GET
  static Future<Response<T>> get<T>(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      return await dio.get<T>(path, queryParameters: queryParameters);
    } catch (e) {
      rethrow;
    }
  }

  // POST
  static Future<Response<T>> post<T>(
      String path, {
        Map<String, dynamic>? data,
        String? filePath,
      }) async {
    try {
      return await dio.post<T>(path, data: FormData.fromMap({if (data != null) ...data, if (filePath != null) 'file': await MultipartFile.fromFile(filePath)}));
    } catch (e) {
      rethrow;
    }
  }

  // PATCH
  static Future<Response<T>> patch<T>(String path, {Map<String, dynamic>? data}) async {
    try {
      return await dio.patch<T>(path, data: data);
    } catch (e) {
      rethrow;
    }
  }

  // DELETE
  static Future<Response<T>> delete<T>(String path, {Map<String, dynamic>? data}) async {
    try {
      return await dio.delete<T>(path, data: data);
    } catch (e) {
      rethrow;
    }
  }
}
