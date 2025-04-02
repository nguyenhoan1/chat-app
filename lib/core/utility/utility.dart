import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture_bloc_template/core/constants/constants.dart';
import 'package:flutter_clean_architecture_bloc_template/core/localization/app_localization.dart';
import 'package:flutter_clean_architecture_bloc_template/core/theme/app_color.dart';
import 'package:flutter_clean_architecture_bloc_template/core/theme/app_theme.dart';
import 'package:flutter_clean_architecture_bloc_template/presentation/widgets/custom_button.dart';
import 'package:flutter_clean_architecture_bloc_template/presentation/widgets/custom_spacing.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:smart_snackbars/smart_snackbars.dart';

import '../../data/data_source/local/shared_preferences_data_source.dart';

class Utility {
  static SharedPreferencesDataSource? _preferencesHelper;
  static FlutterLocalization? _flutterLocalization;

  Utility(SharedPreferencesDataSource preferencesHelper,
      FlutterLocalization flutterLocalization) {
    _preferencesHelper = preferencesHelper;
    _flutterLocalization = flutterLocalization;
  }

  static String getCurrentLocalization() {
    return _flutterLocalization!.currentLocale.toString();
  }

  static void configLocalization(void Function(Locale?)? onTranslatedLanguage) {
    _flutterLocalization?.init(
      mapLocales: appLocales,
      initLanguageCode: Constants.vi,
    );
    _flutterLocalization?.onTranslatedLanguage = onTranslatedLanguage;
  }

  static void customSnackbar({
    required String message,
    required String typeInfo,
    required BuildContext context,
  }) {
    String generateTitle() {
      switch (typeInfo) {
        case Constants.SUCCESS:
          return LocaleData.success.getString(context);
        case Constants.FAILED:
          return LocaleData.failed.getString(context);
        case Constants.WARNING:
          return LocaleData.warning.getString(context);
        case Constants.ERROR:
          return LocaleData.error.getString(context);
        default:
          return "Unknown";
      }
    }

    Widget generateLeadingIcon() {
      switch (typeInfo) {
        case Constants.SUCCESS:
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Icon(
              Icons.check,
              color: AppColor.whiteColor,
            ),
          );
        case Constants.FAILED:
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Icon(
              Icons.error_outline,
              color: AppColor.whiteColor,
            ),
          );
        case Constants.WARNING:
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Icon(
              Icons.warning_amber_rounded,
              color: AppColor.whiteColor,
            ),
          );
        case Constants.ERROR:
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Icon(
              Icons.error,
              color: AppColor.whiteColor,
            ),
          );
        default:
          return Icon(
            Icons.question_mark,
            color: AppColor.whiteColor,
          );
      }
    }

    Color getBackgroundColor() {
      switch (typeInfo) {
        case Constants.SUCCESS:
          return AppColor.tealColorPrimary;
        case Constants.FAILED:
          return AppColor.red;
        case Constants.WARNING:
          return AppColor.yellow;
        case Constants.ERROR:
          return AppColor.red;
        default:
          return AppColor.grayColor;
      }
    }

    SmartSnackBars.showTemplatedSnackbar(
        context: context,
        contentPadding: const EdgeInsets.all(12),
        leading: generateLeadingIcon(),
        title: generateTitle(),
        backgroundColor: getBackgroundColor(),
        subTitleWidget: SizedBox(
          width: MediaQuery.of(context).size.width - 80,
          child: Text(
            message,
            style: AppTheme.paragraph2.copyWith(
              color: AppColor.whiteColor,
            ),
          ),
        ));
  }

  static List<String> convertStringToList(String input,
      {bool trimWhitespace = true}) {
    if (trimWhitespace) {
      return input
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();
    } else {
      return input.split(',').where((e) => e.isNotEmpty).toList();
    }
  }

  static String formattedDateTime(DateTime dateTime) {
    return DateFormat('dd/MMM/yyyy').format(dateTime);
  }

  static String getKeyValueTranslation(String word) {
    if (_preferencesHelper == null) {
      throw StateError(
          'SharedPreferences has not been initialized. Ensure it\'s properly registered with GetIt!');
    }
    var language = word.split('|');
    return _preferencesHelper!.getStringSync(Constants.languageKey) ==
            Constants.vietnam
        ? language[0]
        : language[1].isEmpty
            ? language[0]
            : language[1];
  }

  static Future<String> getBuildNumberVersionApp() async {
    var packageInfo = await PackageInfo.fromPlatform();
    return "${packageInfo.version}+${packageInfo.buildNumber} - ${packageInfo.packageName}";
  }

  static String prettyJson(dynamic json) {
    var spaces = ' ' * 4;
    var encoder = JsonEncoder.withIndent(spaces);
    return encoder.convert(json);
  }

  static String assetPathImage({required String fileName}) {
    return "assets/images/$fileName.png";
  }

  static void appLog({
    required String title,
    required String message,
  }) {
    log(message, name: title);
  }

  static void hideKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  static Future<void> customAlertDialog(
      {BuildContext? context,
      String? title,
      String? message,
      void Function()? onPressed,
      String? textButton,
      Widget? content,
      bool isApiResponse = true}) async {
    if (isApiResponse) {
      List<String>? responseMessage = message?.split('\n');
      return showDialog(
        context: context!,
        builder: (context) => Dialog(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (title != null)
                  Text(
                    title,
                    style: AppTheme.header2,
                  ),
                const VerticalSpacing(
                  height: 10,
                ),
                if (responseMessage != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        responseMessage[0],
                        style: AppTheme.paragraph1,
                      ),
                      Text(
                        responseMessage[0]!.contains('Success')
                            ? responseMessage[1]
                            : responseMessage[0],
                        style: AppTheme.paragraph2.copyWith(
                          color: AppColor.grayColor,
                        ),
                      ),
                    ],
                  ),
                if (content != null) content,
                const VerticalSpacing(),
                if (textButton != null)
                  CustomButton(
                    textButton: textButton,
                    onTap: () => Navigator.pop(context),
                  )
              ],
            ),
          ),
        ),
      );
    } else {
      print('responseMessage $message');
      return showDialog(
        context: context!,
        builder: (context) => Dialog(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (title != null)
                  Text(
                    title,
                    style: AppTheme.header2,
                  ),
                const VerticalSpacing(
                  height: 10,
                ),
                if (message != null)
                  Text(
                    message,
                    style: AppTheme.paragraph1,
                  ),
                if (content != null) content,
                const VerticalSpacing(),
                if (textButton != null)
                  CustomButton(
                    textButton: textButton,
                    onTap: () => Navigator.pop(context),
                  )
              ],
            ),
          ),
        ),
      );
    }
  }

  static Color HexToColor(String hexString) {
    final hex = hexString.replaceAll('#', '');

    if (hex.length == 6) {
      return Color(int.parse('FF$hex', radix: 16));
    } else if (hex.length == 8) {
      return Color(int.parse(hex, radix: 16));
    } else if (hex.length == 3) {
      final r = hex[0];
      final g = hex[1];
      final b = hex[2];
      return Color(int.parse('FF$r$r$g$g$b$b', radix: 16));
    }

    throw FormatException('Invalid hex color format');
  }

  
}
