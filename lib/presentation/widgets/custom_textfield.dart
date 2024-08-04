import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture_bloc_template/core/theme/app_color.dart';
import 'package:flutter_clean_architecture_bloc_template/core/theme/app_theme.dart';
import 'package:flutter_clean_architecture_bloc_template/core/utility/utility.dart';
import 'package:flutter_clean_architecture_bloc_template/presentation/widgets/custom_spacing.dart';

class CustomTextfield extends StatelessWidget {
  const CustomTextfield({
    super.key,
    required this.controller,
    required this.title,
    this.hintText,
    this.labelText,
    this.isPassword = false,
    this.onTapPasswordVisible,
    this.isVisiblePassword = true,
  });

  final TextEditingController controller;
  final String title;
  final String? hintText;
  final String? labelText;
  final bool? isPassword;
  final void Function()? onTapPasswordVisible;
  final bool? isVisiblePassword;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTheme.titleTextField,
        ),
        const VerticalSpacing(
          height: 8,
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColor.whiteColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColor.grayColor,
            ),
          ),
          child: TextField(
            controller: controller,
            obscureText: isVisiblePassword == false,
            onTapOutside: (_) => Utility.hideKeyboard(),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(10),
              labelText: labelText,
              hintText: hintText,
              border: InputBorder.none,
              suffixIcon: isPassword == true
                  ? GestureDetector(
                      onTap: onTapPasswordVisible,
                      child: Icon(
                        isVisiblePassword == false
                            ? Icons.visibility_rounded
                            : Icons.visibility_off_outlined,
                      ),
                    )
                  : null,
            ),
          ),
        )
      ],
    );
  }
}
