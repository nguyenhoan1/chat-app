import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture_bloc_template/core/theme/app_color.dart';
import 'package:flutter_clean_architecture_bloc_template/core/theme/app_theme.dart';
import 'package:flutter_clean_architecture_bloc_template/core/utility/utility.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'custom_spacing.dart';

class CustomTextfield extends StatelessWidget {
  const CustomTextfield({
    Key? key,
    required this.controller,
    required this.title,
    this.hintText,
    this.labelText,
    this.isPassword = false,
    this.onTapPasswordVisible,
    this.isVisiblePassword = true,
    this.enablePrefixIcon = false,
    this.prefixIcon,
    this.useAlternativeLabelStyle = false,
    this.enableBorder = false,
    this.isReadOnly = false,
    this.onFocusChanged,
    this.onChanged,
    this.isSearchTextField = false,
    this.extraWidget = const SizedBox(),
    this.useExtraWidget = false,
  }) : super(key: key);

  final TextEditingController controller;
  final String title;
  final String? hintText;
  final String? labelText;
  final bool? isPassword;
  final void Function()? onTapPasswordVisible;
  final bool? isVisiblePassword;
  final bool enablePrefixIcon;
  final Widget? prefixIcon;
  final bool useAlternativeLabelStyle;
  final bool enableBorder;
  final bool isReadOnly;
  final void Function(bool)? onFocusChanged;
  final Function(String)? onChanged;
  final bool isSearchTextField;
  final Widget extraWidget;
  final bool useExtraWidget;

  @override
  Widget build(BuildContext context) {
    return _CustomTextfieldContent(
      controller: controller,
      title: title,
      hintText: hintText,
      labelText: labelText,
      isPassword: isPassword,
      onTapPasswordVisible: onTapPasswordVisible,
      isVisiblePassword: isVisiblePassword,
      enablePrefixIcon: enablePrefixIcon,
      prefixIcon: prefixIcon,
      useAlternativeLabelStyle: useAlternativeLabelStyle,
      enableBorder: enableBorder,
      isReadOnly: isReadOnly,
      onFocusChanged: onFocusChanged,
      onChanged: onChanged,
      isSearchTextField: isSearchTextField,
      extraWidget: extraWidget,
      useExtraWidget: useExtraWidget,
    );
  }
}

class _CustomTextfieldContent extends StatelessWidget {
  const _CustomTextfieldContent({
    Key? key,
    required this.controller,
    required this.title,
    this.extraWidget = const SizedBox(),
    this.useExtraWidget = false,
    this.hintText,
    this.labelText,
    this.isPassword = false,
    this.onTapPasswordVisible,
    this.isVisiblePassword = true,
    this.enablePrefixIcon = false,
    this.prefixIcon,
    this.useAlternativeLabelStyle = false,
    this.enableBorder = false,
    this.isReadOnly = false,
    this.onFocusChanged,
    this.onChanged,
    this.isSearchTextField = false,
  }) : super(key: key);

  final TextEditingController controller;
  final String title;
  final String? hintText;
  final String? labelText;
  final bool? isPassword;
  final void Function()? onTapPasswordVisible;
  final bool? isVisiblePassword;
  final bool enablePrefixIcon;
  final Widget? prefixIcon;
  final bool useAlternativeLabelStyle;
  final bool enableBorder;
  final bool isReadOnly;
  final void Function(bool)? onFocusChanged;
  final Function(String)? onChanged;
  final bool isSearchTextField;
  final Widget extraWidget;
  final bool useExtraWidget;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != "") ...[
          Text(
            title,
            style: !useAlternativeLabelStyle
                ? AppTheme.titleTextField
                : AppTheme.titleTextField.copyWith(
                    color: AppColor.blackColor,
                    fontSize: 15.sp,
                  ),
          ),
          const VerticalSpacing(
            height: 8,
          ),
        ],
        Container(
          decoration: BoxDecoration(
            color: !useAlternativeLabelStyle
                ? AppColor.whiteColor
                : AppColor.grayColor,
            borderRadius: BorderRadius.circular(50),
            border: enableBorder
                ? Border.all(
                    color: AppColor.grayColor,
                    width: 1,
                  )
                : null,
          ),
          child: Focus(
            onFocusChange: (isFocused) {},
            child: TextField(
              onChanged: onChanged,
              readOnly: isReadOnly,
              controller: controller,
              obscureText: isVisiblePassword == false,
              onTapOutside:
                  !isSearchTextField ? (_) => Utility.hideKeyboard() : null,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(16),
                labelText: labelText,
                hintText: hintText,
                hintStyle: AppTheme.paragraph1.copyWith(
                  color: AppColor.grayColor,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: enablePrefixIcon ? prefixIcon : null,
                suffixIcon: isPassword == true
                    ? GestureDetector(
                        onTap: onTapPasswordVisible,
                        child: Icon(
                          isVisiblePassword == false
                              ? Icons.visibility_rounded
                              : Icons.visibility_off_outlined,
                        ),
                      )
                    : (isSearchTextField)
                        ? useExtraWidget
                            ? Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  GestureDetector(
                                    onTap: () => Utility.hideKeyboard(),
                                    child: Icon(
                                      Icons.clear,
                                    ),
                                  ),
                                  HorizontalSpacing(
                                    width: 6,
                                  ),
                                  extraWidget,
                                  HorizontalSpacing(
                                    width: 10,
                                  ),
                                ],
                              )
                            : GestureDetector(
                                onTap: () => Utility.hideKeyboard(),
                                child: Icon(
                                  Icons.clear,
                                ),
                              )
                        : null,
              ),
            ),
          ),
        )
      ],
    );
  }
}
