import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:apollo_tracker_mobile/theme/colors.dart';
import 'package:apollo_tracker_mobile/theme/texts.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class ReactiveDropdownInput extends HookWidget {
  const ReactiveDropdownInput({
    Key? key,
    required this.label,
    required this.formControlName,
    required this.items,
    this.hintText,
    this.readOnly = false,
  }) : super(key: key);

  final String label;
  final String formControlName;
  final List<DropdownMenuItem<String>> items;
  final String? hintText;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
          child: Text(
            label,
            style: AppTextTheme.LabelMdPrimary,
          ),
        ),
        ReactiveDropdownField<String>(
          formControlName: formControlName,
          isExpanded: true,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            border: const OutlineInputBorder(borderSide: BorderSide(color: AppColors.strokePrimary)),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(width: 1, color: AppColors.strokePrimary),
              borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(width: 1),
              borderRadius: BorderRadius.circular(8),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(width: 1),
              borderRadius: BorderRadius.circular(8),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: const BorderSide(width: 1),
              borderRadius: BorderRadius.circular(8),
            ),
            hintText: hintText,
            hintStyle: const TextStyle(color: AppColors.surfaceInvertTertiary),
            // suffixIcon: Icon(PhosphorIcons.caretDown(), color: AppColors.surfaceInvertTertiary),
          ),
          items: items,
          readOnly: readOnly,
        ),
      ],
    );
  }
}
