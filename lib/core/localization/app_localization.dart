import 'package:flutter_clean_architecture_bloc_template/core/constants/constants.dart';
import 'package:flutter_localization/flutter_localization.dart';

const List<MapLocale> appLocales = [
  MapLocale(Constants.eng, LocaleData.EN),
  MapLocale(Constants.vi, LocaleData.VI),
];

mixin LocaleData {
  static const String version = "version";
  static const String versionNotFound = "versionNotFound";
  static const String loginTitle = "loginTitle";
  static const String loginDesc = "loginDesc";
  static const String loginText = "login";
  static const String logoutText = "logout";
  static const String email = "email";
  static const String id = "id";
  static const String emailHint = "emailHint";
  static const String password = "password";
  static const String passwordHint = "passwordHint";
  static const String greetingText = "greetingText";
  static const String languageState = "languageState";

  // Type Info Status
  static const String success = 'success';
  static const String failed = 'failed';
  static const String warning = 'warning';
  static const String error = 'error';

  static const Map<String, dynamic> EN = {
    version: "Version %a",
    versionNotFound: "Version Not Found",
    loginTitle: "Login Page",
    loginDesc: "This is your login page",
    loginText: "Login",
    logoutText: "Logout",
    email: "Email Address",
    id: "ID",
    emailHint: "Your email address here...",
    password: "Password",
    passwordHint: "Your password here...",
    greetingText: "Welcome %a",
    languageState: " Your Current Language %a",
    //
    success: "Success",
    failed: "Failed",
    warning: "Warning",
    error: "Error",
  };
  static const Map<String, dynamic> VI = {
    "version": "Phiên bản %a",
    "versionNotFound": "Không tìm thấy phiên bản",
    "loginTitle": "Trang đăng nhập",
    "loginDesc": "Đây là trang đăng nhập của bạn",
    "loginText": "Đăng nhập",
    "logoutText": "Đăng xuất",
    "email": "Địa chỉ email",
    "id": "ID",
    "emailHint": "Nhập địa chỉ email của bạn ở đây...",
    "password": "Mật khẩu",
    "passwordHint": "Nhập mật khẩu của bạn ở đây...",
    "greetingText": "Chào mừng %a",
    "languageState": "Ngôn ngữ hiện tại của bạn là %a",
    //
    "success": "Thành công",
    "failed": "Thất bại",
    "warning": "Cảnh báo",
    "error": "Lỗi",
  };
}
