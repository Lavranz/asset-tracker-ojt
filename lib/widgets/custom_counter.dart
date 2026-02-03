import 'package:apollo_tracker_mobile/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:reactive_forms/reactive_forms.dart';
class CounterFormField extends HookWidget {
  final String label;
  final String formControlName;

  const CounterFormField({
    Key? key,
    required this.label,
    required this.formControlName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Retrieve the form control from the ReactiveForm context
    final control = ReactiveForm.of(context)!.findControl(formControlName);
    // Initialize a state variable for the count
    final count = useState<int>(control?.value ?? 0);

    // Listen to changes in the form control and update the count state
    useEffect(() {
      control?.valueChanges.listen((value) {
        count.value = value;
      });
      return null;
    }, [control]);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              // Minus button
              Container(
                decoration: BoxDecoration(
                  color: AppColors.neutral50,
                  border: Border.all(color: AppColors.neutral100),
                  borderRadius: BorderRadius.circular(100.0),
                ),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: const Icon(Icons.remove),
                  // Disable the button if the count is 0
                  onPressed: count.value > 0
                      ? () {
                          control?.value = count.value - 1;
                        }
                      : null,
                ),
              ),
              const SizedBox(width: 16.0),
              // Display the current count
              Text('${count.value}', style: const TextStyle(fontSize: 24.0)),
              const SizedBox(width: 16.0),
              // Plus button
              Container(
                decoration: BoxDecoration(
                  color: AppColors.neutral50,
                  border: Border.all(color: AppColors.neutral100),
                  borderRadius: BorderRadius.circular(100.0),
                ),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    control?.value = count.value + 1;
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}