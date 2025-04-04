import 'dart:io' show Platform;

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_clean_architecture_bloc_template/core/utils/env/prod_env.dart';
import 'package:flutter_clean_architecture_bloc_template/core/utils/env/stg_env.dart';
import 'package:flutter_clean_architecture_bloc_template/core/utils/log_service.dart';
import 'package:flutter_clean_architecture_bloc_template/firebase_options.dart';
import 'package:native_flutter_proxy/custom_proxy.dart';
import 'package:native_flutter_proxy/native_proxy_reader.dart';
import 'package:package_info_plus/package_info_plus.dart';
// import 'package:adamo_sport/utils/config/env/prod_env.dart';
// import 'package:adamo_sport/utils/config/env/qa_env.dart';
// import 'package:adamo_sport/utils/config/env/stg_env.dart';
// import 'package:adamo_sport/utils/service/log_service.dart';
// import 'package:native_flutter_proxy/custom_proxy.dart';
// import 'package:native_flutter_proxy/native_proxy_reader.dart';
// import 'package:package_info_plus/package_info_plus.dart';
import 'env/app_env.dart';
import 'env/qa_env.dart';

enum Enviroment { qa, stg, prod }

class AppConfig {
  static Enviroment env = Enviroment.qa;
  static AppEnv appEnv = QaEnv();

  static String baseUrl = '';
  static String apiKey = '';
  static String? currentProxy;
  static PackageInfo? _packageInfo;
  static String get appVersion {
    return _packageInfo != null
        ? '${_packageInfo?.version.split(' ').first} (${_packageInfo?.buildNumber})'
        : '';
  }

  static String get packageName => _packageInfo?.packageName ?? '';

  static String get purchaseKey {
    if (Platform.isAndroid) {
      return appEnv.revenueCatPublicKeyAndroid;
    }

    return appEnv.revenueCatPublicKeyIos;
  }

  static FirebaseOptions get firebaseOptions => DefaultFirebaseOptions.currentPlatform; 

  // static get firebaseOptions {
  //   switch (env) {
  //     case Enviroment.qa:
  //       return qa.DefaultFirebaseOptions.currentPlatform;
  //     case Enviroment.stg:
  //       return stg.DefaultFirebaseOptions.currentPlatform;
  //     case Enviroment.prod:
  //       return prod.DefaultFirebaseOptions.currentPlatform;
  //   }
  // }

  static Future<void> loadEnv() async {
    await _checkEnv();
    debugPrint('$env');

    switch (env) {
      case Enviroment.qa:
        appEnv = QaEnv();
        await _configProxy();
        break;
      case Enviroment.stg:
        appEnv = StgEnv();
        await _configProxy();
        break;
      case Enviroment.prod:
        appEnv = ProdEnv();
        break;
      default:
    }

    baseUrl = appEnv.baseUrl;
    debugPrint(baseUrl);
    apiKey = appEnv.baseUrl;
    debugPrint(baseUrl);
  }

  static Future<void> _checkEnv() async {
    _packageInfo = await PackageInfo.fromPlatform();
    final packageName = _packageInfo?.packageName ?? '';
    try {
      if (packageName.contains(Enviroment.qa.name)) {
        env = Enviroment.qa;
      } else if (packageName.contains(Enviroment.stg.name)) {
        env = Enviroment.stg;
      } else {
        env = Enviroment.prod;
      }
    } catch (e) {
      env = Enviroment.qa;
    }
  }

  static Future<void> _configProxy() async {
    bool enabled = false;
    String? host;
    int? port;
    try {
      final ProxySetting settings = await NativeProxyReader.proxySetting;
      enabled = settings.enabled;
      host = settings.host;
      port = settings.port;
    } catch (error) {
      L.error(error);
    }
    if (enabled && host != null) {
      final proxy = CustomProxy(ipAddress: host, port: port);
      currentProxy = proxy.toString();
    }
  }
}
