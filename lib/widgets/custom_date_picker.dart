import 'package:apollo_tracker_mobile/theme/colors.dart';
import 'package:apollo_tracker_mobile/theme/texts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:reactive_date_time_picker/reactive_date_time_picker.dart';

class ReactiveDateTimeInput extends HookWidget {
  const ReactiveDateTimeInput({
    Key? key,
    required this.label,
    required this.formControlName,
    this.hintText,
    this.readOnly = false,
    this.type = ReactiveDatePickerFieldType.date,
    this.dateFormat,
  }) : super(
          key: key,
        );

  final String label;

  final ReactiveDatePickerFieldType type;

  final String formControlName;

  final String? hintText;

  final bool readOnly;

  final DateFormat? dateFormat;

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
        AbsorbPointer(
          absorbing: readOnly,
          child: ReactiveDateTimePicker(
            formControlName: formControlName,
            type: type,
            dateFormat: dateFormat,
            decoration: InputDecoration(
              filled: readOnly,
              fillColor: readOnly ? AppColors.surfaceInvertTertiary.withOpacity(0.1) : null,
              contentPadding: const EdgeInsets.only(top: 10, bottom: 10, left: 16, right: 16),
              // border: const OutlineInputBorder(borderSide: BorderSide(color: AppColors.surfaceInvertTertiary)),
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
              hintStyle: const TextStyle(color: AppColors.surfaceInvertTertiary),
              prefixIcon: Icon(type == ReactiveDatePickerFieldType.date ? PhosphorIcons.calendarBlank() : PhosphorIcons.clock(), color: AppColors.surfaceInvertTertiary),
            ),
          )
        )
      ],
    );
  }
}
