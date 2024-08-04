import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture_bloc_template/core/theme/app_color.dart';
import 'package:flutter_clean_architecture_bloc_template/core/theme/app_theme.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.textButton,
    this.widthSize,
    required this.onTap,
    this.isLoading = false,
    this.backgroundColor = AppColor.tealColorPrimary,
    this.textButtonColor = AppColor.whiteColor,
  });

  final String textButton;
  final double? widthSize;
  final void Function()? onTap;
  final Color backgroundColor;
  final Color textButtonColor;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: !isLoading ? onTap : null,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        alignment: Alignment.center,
        width: widthSize ?? MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: !isLoading ? backgroundColor : AppColor.grayColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Visibility(
          visible: !isLoading,
          replacement: const CupertinoActivityIndicator(
            color: AppColor.whiteColor,
          ),
          child: Text(
            textButton,
            style: AppTheme.buttonTextPrimary.copyWith(
              color: textButtonColor,
            ),
          ),
        ),
      ),
    );
  }
}
