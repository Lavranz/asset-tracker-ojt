import 'package:apollo_tracker_mobile/commons/forms/users.form.dart';
import 'package:apollo_tracker_mobile/commons/services/ticket.service.dart';
import 'package:apollo_tracker_mobile/commons/services/toast.service.dart';
import 'package:apollo_tracker_mobile/theme/app_bar.dart';
import 'package:dio/dio.dart';
import 'package:fl_query_hooks/fl_query_hooks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:go_router/go_router.dart';

import 'package:apollo_tracker_mobile/theme/colors.dart';
import 'package:apollo_tracker_mobile/theme/texts.dart';
import 'package:apollo_tracker_mobile/widgets/custom_inputs.dart';

TicketResponseForm ticketResponseForm = TicketResponseForm();

class TicketResponsePage extends HookWidget {
  final dynamic id;

  const TicketResponsePage({
    super.key,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    final queryClient = useQueryClient();

    final createResponseQ = useMutation(
      'create-response-$id',
      (data) => ticket$.createResponse(id, data),
      onData: (data, revData) async {
      
        queryClient.refreshQueries(['ticket_list']);
        GoRouter.of(context).go('/tickets');
        WidgetsBinding.instance.addPostFrameCallback((_) {
          toastSuccess(context, data['status']['message'] ?? 'Success!');
        });
      },
      onError: (DioException error, recoveryData) {
        if (error.response!.data != null) {
          final Map<String, dynamic> errors = error.response!.data;
          ticketResponseForm.setFormErrors(errors);

          if (errors.containsKey('status')) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(errors['status']['message'] ?? ''),
              ),
            );
          }
        }
      },
    );

    // Pre-populate ticket_id in the form (readonly)
    ticketResponseForm.form.control('ticket_id').value = id;

    // Function to submit the form
    void submit() async {
      if (ticketResponseForm.form.valid) {
        // Simulate form submission logic
        createResponseQ.mutate(ticketResponseForm.form.value);
      } else {
        ticketResponseForm.form.markAllAsTouched();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please complete all required fields')),
        );
      }
    }

    useEffect(() {
      return () {
        ticketResponseForm.form.reset();
      };
    }, []);

    // Function to cancel the form
    void cancel() {
      ticketResponseForm.form.reset();
      context.pop();
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: customAppBar('Ticket Response'),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ReactiveForm(
              formGroup: ticketResponseForm.form,
              child: Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Ticket ID field (readonly)
                      ReactiveTextInput(
                        label: 'Ticket ID',
                        formControlName: 'ticket_id',
                        hintText: 'Ticket ID',
                        readOnly: true,
                      ),
                      const SizedBox(height: 16),

                      // Status dropdown
                      ReactiveDropdownField<String>(
                        formControlName: 'status',
                        decoration: const InputDecoration(
                          labelText: 'Status',
                        ),
                        items: [
                          DropdownMenuItem(
                            value: 'RESOLVED',
                            child: Text('RESOLVED'),
                          ),
                          DropdownMenuItem(
                            value: 'CLOSED',
                            child: Text('CLOSED'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Message field (textarea)
                      const ReactiveTextInput(
                        label: 'Message',
                        formControlName: 'message',
                        hintText: 'Enter your message',
                        maxLines: 3,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                // Cancel button
                Expanded(
                  child: ElevatedButton(
                    onPressed: cancel,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.light,
                      foregroundColor: Colors.white,
                      padding:
                          const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Cancel',
                      style: AppTextTheme.LabelSmMediumPrimary,
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                // Submit button
                Expanded(
                  child: ElevatedButton(
                    onPressed: createResponseQ.isMutating ? null : submit,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      backgroundColor: AppColors.primary500,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: createResponseQ.isMutating
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
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
