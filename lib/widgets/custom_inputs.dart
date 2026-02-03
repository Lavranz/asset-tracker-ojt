import 'package:apollo_tracker_mobile/commons/utils/image.util.dart';
import 'package:apollo_tracker_mobile/theme/colors.dart';
import 'package:apollo_tracker_mobile/theme/texts.dart';
import 'package:apollo_tracker_mobile/widgets/custom_image_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import "package:reactive_forms/reactive_forms.dart";

class ReactiveTextInput extends HookWidget {
  const ReactiveTextInput({
    Key? key,
    this.label = '',
    required this.formControlName,
    this.hintText,
    this.obscureText = false,
    this.maxLines = 1,
    this.suffixIcon = false,
    this.readOnly = false,
    this.required = false,
    this.suffixText = '',
  }) : super(
          key: key,
        );

  final String label;

  final String formControlName;

  final String? hintText;

  final bool obscureText;

  final bool suffixIcon;

  final bool required;

  final bool readOnly;

  final String suffixText;

  final int maxLines;

  @override
  Widget build(BuildContext context) {
    final $obscureText = useState(obscureText);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        if (label.isNotEmpty) 
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
            child: Row(
              children: [
                Text(
                  label,
                  style: AppTextTheme.LabelMdPrimary,
                ),
                if (required)
                  const Text(
                    ' *',
                    style: TextStyle(
                      color: AppColors.negative600,
                    ),
                  ),

              ]
            ) 
          ),
        ReactiveTextField(
          formControlName: formControlName,
          style: const TextStyle(fontWeight: FontWeight.w400),
          obscureText: $obscureText.value,
          maxLines: maxLines,
          readOnly: readOnly,
          autofocus: false,
          decoration: InputDecoration(
            prefixIconConstraints: BoxConstraints.tight(const Size(16, 42)),
            prefixIcon:  Container(width: 0),
            contentPadding: const EdgeInsets.only(top: 10, bottom: 10, left: 0, right: 16),
            border: const OutlineInputBorder(borderSide: BorderSide(color: AppColors.surfaceInvertTertiary)),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                width: 1,
                color: AppColors.strokePrimary,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                width: 1,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                width: 1,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                width: 1,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            hintText: hintText,
            hintStyle: const TextStyle(color: AppColors.surfaceInvertTertiary), // Added hint text color
            suffixText: suffixText,
            suffixStyle: const TextStyle(color: AppColors.surfaceInvertTertiary), // Added suffix text color
            suffixIcon: suffixIcon
                ? IconButton(
                    icon: CustomImageView(
                      imagePath: $obscureText.value
                          ? IconConstant.logo
                          : IconConstant.logo,
                      width: 24,
                      height: 24,
                    ),
                    onPressed: () {
                      $obscureText.value = !$obscureText.value;
                    },
                  )
                : null,
          ),
        )
      ],
    );
  }
}