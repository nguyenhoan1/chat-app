import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_clean_architecture_bloc_template/core/network/app_interceptor.dart';
import 'package:flutter_clean_architecture_bloc_template/core/network/network_helper.dart';

class CallApiService {
  final Dio dio;

  CallApiService({required this.dio});

  Future<T> apiRequest<T>({
    required String url,
    required String method,
    required T Function(Map<String, dynamic>) fromJson,
    Map<String, dynamic>? params,
    Map<String, dynamic>? headers,
  }) async {
    if (kDebugMode) {
      dio.interceptors.add(AppInterceptor());
    }
    try {
      Response response;

      switch (method.toUpperCase()) {
        case 'GET':
          response = await dio.get(url,
              queryParameters: params, options: Options(headers: headers));
          break;
        case 'POST':
          response = await dio.post(url,
              data: params, options: Options(headers: headers));
          break;
        case 'PUT':
          response = await dio.put(url,
              data: params, options: Options(headers: headers));
          break;
        case 'DELETE':
          response = await dio.delete(url,
              data: params, options: Options(headers: headers));
          break;
        default:
          throw Exception('HTTP METHOD IS NOT SUPPORTED.');
      }

      return fromJson(response.data);
    } on DioException catch (error) {
      throw Exception(NetworkHelper.handleError(error));
    }
  }
}
