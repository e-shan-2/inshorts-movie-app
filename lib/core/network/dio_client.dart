import 'package:dio/dio.dart';
import '../constants/api_constants.dart';

class DioClient {
  static Dio createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        headers: {
          'Authorization': 'Bearer ${ApiConstants.bearerToken}',
          'Content-Type': 'application/json',
        },
      ),
    );
   

   

     dio.interceptors.add(LogInterceptor(responseBody: true));

    return dio;
  }
}
