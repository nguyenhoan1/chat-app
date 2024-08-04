import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AppTheme {
  /// Header Section
  static TextStyle header1 = TextStyle(
    fontSize: 24.sp,
    fontWeight: FontWeight.bold,
  );
  static TextStyle header2 = TextStyle(
    fontSize: 22.sp,
    fontWeight: FontWeight.w700,
  );

  /// Paragraph Section
  static TextStyle paragraph1 = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w400,
  );
  static TextStyle paragraph2 = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
  );

  /// ButtonText Section
  static TextStyle buttonTextPrimary = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.normal,
  );
  static TextStyle buttonTextSecondary = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.normal,
  );

  /// Other
  static TextStyle titleTextField = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.normal,
  );
}
