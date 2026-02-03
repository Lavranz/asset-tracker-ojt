import 'package:apollo_tracker_mobile/commons/forms/users.form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:signature/signature.dart';
import 'dart:convert';  // For base64 encoding
import 'package:go_router/go_router.dart';

import 'package:apollo_tracker_mobile/theme/colors.dart';
import 'package:apollo_tracker_mobile/theme/texts.dart';
import 'package:apollo_tracker_mobile/widgets/custom_inputs.dart';



FSRForm fsrForm = FSRForm();

class TicketFSRPage extends HookWidget {
   final dynamic id;

  const TicketFSRPage({
    super.key, 
    required this.id
  });

  @override
  Widget build(BuildContext context) {
    final signatureController = useState(SignatureController(penStrokeWidth: 2.0));

    useEffect(() {
      fsrForm.form.reset();
      return () => fsrForm.form.reset();
    }, []);

    void submit() async {
      // Convert the signature to a PNG byte array
      final signatureBytes = await signatureController.value.toPngBytes();
      if (signatureBytes != null) {
        // Convert the PNG bytes to base64 string
        final base64Signature = base64Encode(signatureBytes);

        // Set the base64 string in the form's signature control
        fsrForm.form.control('signature').value = base64Signature;
      } else {
        fsrForm.form.control('signature').setErrors({'required': true});
      }

      if (fsrForm.form.valid) {
        // Simulate form submission logic here
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Form Submitted Successfully!')),
        );
        GoRouter.of(context).go('/tickets'); // Navigate to the dashboard
      } else {
        fsrForm.form.markAllAsTouched();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please complete all required fields')),
        );
      }
    }

    void cancel() {
      fsrForm.form.reset();
      signatureController.value.clear();
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          'Field Service Report',
          style: AppTextTheme.H6MediumPrimary.copyWith(
            fontWeight: FontWeight.w600
          ),
        ),
        centerTitle: false,
        titleSpacing: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8),
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              size: 20,
            ),
            onPressed: () {
              GoRouter.of(context).pop();
            },
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ReactiveForm(
              formGroup: fsrForm.form,
              child: Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const ReactiveTextInput(
                        label: 'Name',
                        formControlName: 'name',
                        hintText: 'Enter your name',
                      ),
                      const SizedBox(height: 16),
                      const ReactiveTextInput(
                        label: 'Remarks',
                        formControlName: 'remarks',
                        hintText: 'Enter remarks',
                        maxLines: 3,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Signature',
                        style: AppTextTheme.BodySmSecondary,
                      ),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.neutral300),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        height: 150,
                        child: Signature(
                          controller: signatureController.value,
                          backgroundColor: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: () => signatureController.value.clear(),
                        child: const Text(
                          'Clear Signature',
                          style: TextStyle(color: AppColors.primary500),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: cancel,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      backgroundColor: AppColors.neutral300,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: submit,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      backgroundColor: AppColors.primary500,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: const Text(
                      'Submit',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
