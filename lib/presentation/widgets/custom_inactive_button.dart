import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture_bloc_template/core/theme/app_color.dart';
import 'package:flutter_clean_architecture_bloc_template/core/theme/app_theme.dart';

class CustomInactiveButton extends StatelessWidget {
  const CustomInactiveButton({
    super.key,
    required this.textButton,
    this.widthSize,
  });

  final String textButton;
  final double? widthSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      alignment: Alignment.center,
      width: widthSize ?? MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: AppColor.grayColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        textButton,
        style: AppTheme.buttonTextPrimary.copyWith(
          color: AppColor.whiteColor,
        ),
      ),
    );
  }
}
