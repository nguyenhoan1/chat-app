import 'package:dio/dio.dart';

class NetworkHelper {
  static String handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.cancel:
        return "Connection failed, please check your network\nDetail Error:\t${error.message}";
      case DioExceptionType.connectionTimeout:
        return "Connection Timeout\nDetail Error:\t${error.message}";
      case DioExceptionType.unknown:
        return "Unknown Error Issue\nDetail Error:\t${error.message}";
      case DioExceptionType.receiveTimeout:
        return "Connection timeout when receive data from server\nDetail Error:\t${error.message}";
      case DioExceptionType.badResponse:
        return "Error Bad Response is Occured\nDetail Error:\t${error.message}";
      case DioExceptionType.sendTimeout:
        return "Connection timeout when send data to server\nDetail Error:\t${error.message}";
      case DioExceptionType.badCertificate:
        return "This connection has bad certificate\nDetail Error:\t${error.message}";
      case DioExceptionType.connectionError:
        return "Your Connection has error\nDetail Error:\t${error.message}";
    }
  }
}
