import 'package:apollo_tracker_mobile/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

enum CheckboxPosition { start, end }

class CustomCheckbox extends StatelessWidget {
  final String label;
  final String formControlName;
  final Color activeColor;
  final Color checkColor;
  final CheckboxPosition checkboxPosition;

  CustomCheckbox({
    required this.label,
    required this.formControlName,
    this.activeColor = AppColors.primary500,
    this.checkColor = Colors.white,
    this.checkboxPosition = CheckboxPosition.end, // Default to end
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, // Set width to 100%
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center, // Align items to the top
        children: checkboxPosition == CheckboxPosition.start
            ? [
                ReactiveCheckbox(
                  formControlName: formControlName,
                  activeColor: activeColor,
                  checkColor: checkColor,
                ),
                const SizedBox(width: 8.0),
                Expanded(
                  child: Align(
                    alignment: Alignment.topLeft, // Align label to the top-left
                    child: Text(
                      label,
                      style: TextStyle(
                        color: AppColors.contentDefaultSecondary, // Example text color
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ),
              ]
            : [
                Expanded(
                  child: Align(
                    alignment: Alignment.topLeft, // Align label to the top-left
                    child: Text(
                      label,
                      style: TextStyle(
                        color: AppColors.contentDefaultSecondary, // Example text color
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                ReactiveCheckbox(
                  formControlName: formControlName,
                  activeColor: activeColor,
                  checkColor: checkColor,
                ),
              ],
      ),
    );
  }
}
