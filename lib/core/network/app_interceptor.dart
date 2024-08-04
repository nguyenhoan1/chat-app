import 'package:dio/dio.dart';
import 'package:flutter_clean_architecture_bloc_template/core/utility/utility.dart';

class AppInterceptor implements InterceptorsWrapper {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    Utility.appLog(
      title: 'Interceptor - onError',
      message: "ERROR => ${err.message}\n${err.stackTrace}",
    );
    handler.next(err);
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    Utility.appLog(
      title: 'Interceptor - onRequest',
      message:
          "URI => ${options.uri}\nBODY-REQUEST => ${Utility.prettyJson(options.data)}",
    );
    handler.next(
      options,
    );
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    Utility.appLog(
        title: 'Interceptor - onResponse',
        message: "${response.realUri}\n${Utility.prettyJson(response.data)}");
    handler.next(response);
  }
}
