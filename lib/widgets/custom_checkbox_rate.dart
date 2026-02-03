import 'package:apollo_tracker_mobile/theme/base.dart';
import 'package:apollo_tracker_mobile/theme/colors.dart';
import 'package:apollo_tracker_mobile/theme/texts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:reactive_forms/reactive_forms.dart';

class SatisfactionSurvey extends HookWidget {
  final List<List<String>> options;
  final ValueChanged<String> onOptionSelected;
  final String formControlName; // Add this line
  final FormGroup form; // Add this line

  const SatisfactionSurvey({
    Key? key,
    required this.options,
    required this.onOptionSelected,
    required this.formControlName, // Add this line
    required this.form, // Add this line
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use a hook to manage the selected option state
    final selectedOption = useState<String>(options[2][0]); // Default to "Neutral"

    // Get screen width and calculate dynamic width
    final screenWidth = MediaQuery.of(context).size.width;
    final optionWidth = screenWidth / options.length * 0.9; // Adjust ratio as needed

    useEffect(() {
      selectedOption.value = form.control(formControlName).value;

      return () {
        form.control(formControlName).value = selectedOption.value;
      };
    }, []);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: options.map((option) {
            final isSelected = option[1] == selectedOption.value;

            return GestureDetector(
              onTap: () {
                selectedOption.value = option[1];
                onOptionSelected(option[1]);
                form.control(formControlName).value = option[1];
              },
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected ? AppColors.primary500 : AppColors.primary100,
                        width: 5.0,
                      ),
                      color: isSelected ? AppColors.primary500 : Colors.transparent,
                    ),
                    width: 40,
                    height: 40,
                    child: Center(
                      child: Icon(
                        isSelected ? Icons.check : null,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: optionWidth, // Dynamic width based on screen size
                    child: Text(
                      option[0],
                      textAlign: TextAlign.center,
                      style: AppTextTheme.Caption,
                      overflow: TextOverflow.clip,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
