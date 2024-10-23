import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

Future<void> Function({
  required BuildContext context,
  required Widget child,
  bool hasBlur,
  bool enableDrag,
}) showCustomSheet = ({
  required BuildContext context,
  required Widget child,
  bool hasBlur = true,
  bool enableDrag = true,
}) {
  return showModalBottomSheet(
    showDragHandle: true,
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.grey.withOpacity(0.2),
    elevation: 0,
    useSafeArea: true,
    enableDrag: enableDrag,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30),
    ),
    builder: (context) => GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: hasBlur ? 3 : 0,
          sigmaY: hasBlur ? 3 : 0,
        ),
        child: SizedBox(
          width: 100.w,
          child: child,
        ),
      ),
    ),
  );
};
