import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:apollo_tracker_mobile/commons/forms/users.form.dart';
import 'package:apollo_tracker_mobile/commons/models/ticket.model.dart';
import 'package:apollo_tracker_mobile/commons/services/auth.service.dart';
import 'package:apollo_tracker_mobile/commons/services/fsr.service.dart';
import 'package:apollo_tracker_mobile/commons/services/ticket.service.dart';
import 'package:apollo_tracker_mobile/commons/services/toast.service.dart';
import 'package:apollo_tracker_mobile/theme/colors.dart';
import 'package:apollo_tracker_mobile/theme/texts.dart';
import 'package:apollo_tracker_mobile/widgets/custom_checkbox.dart';
import 'package:apollo_tracker_mobile/widgets/custom_checkbox_rate.dart';
import 'package:apollo_tracker_mobile/widgets/custom_counter.dart';
import 'package:apollo_tracker_mobile/widgets/custom_date_picker.dart';
import 'package:apollo_tracker_mobile/widgets/custom_dropdown_field.dart';
import 'package:apollo_tracker_mobile/widgets/custom_inputs.dart';
import 'package:dio/dio.dart';
import 'package:fl_query_hooks/fl_query_hooks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:reactive_date_time_picker/reactive_date_time_picker.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:signature/signature.dart';

class CreateFieldServiceReportPage extends HookWidget {
  final FieldServiceReportForm reportForm = FieldServiceReportForm();
  final String? id; // ticket id
  
  CreateFieldServiceReportPage({super.key, this.id});

  @override

  Widget build(BuildContext context) {
    ScrollController _scrollController = ScrollController();
    final currentStep = useState(0); // Tracks the current step (0, 1, or 2)
    final ticketOptions = useState<List<TicketID>>([]);
    final queryClient = useQueryClient();
    final ticketID = useState<String?>(reportForm.form.control('ticket').value);
   
    final ticketQuery = useQuery(
      "ticket_detail-${ticketID.value}",
      enabled: ticketID.value != null,
      () => ticket$.detail(ticketID.value),
      onData: (data) {
        reportForm.form.patchValue({
          'customer': data.accountName ?? reportForm.form.control('customer').value,
          'client_address': data.serviceAddress ?? reportForm.form.control('client_address').value,
          'client_contact_no': data.contactNumber ?? reportForm.form.control('client_contact_no').value,
          'ack_clients_name': data.accountName ?? reportForm.form.control('ack_clients_name').value,
        });
   
        if (data.timeIn != null) {
          DateTime timeIn = DateTime.parse(data.timeIn ?? '');
          reportForm.form.patchValue({
            'date': timeIn,
            'time_started': timeIn,
          });
        };
        if (data.timeOut != null) {
          DateTime timeOut = DateTime.parse(data.timeOut ?? '');
          reportForm.form.control('time_finished').updateValue(timeOut);
        };
      },
    );

    final userQuery = useQuery('auth-user', () => auth$.getUser(), onData: (value) => {
      reportForm.form.control('technical_team').updateValue(value.firstName),
    });


    final ticket = ticketQuery.data;

    final createFSRQ = useMutation(
      'create-fsr',
      (data) => fsr$.create(data),
      onData: (data, revData) async {
        if (data != null) {
          queryClient.refreshQueries(['user-fsr-list']);
          GoRouter.of(context).pop();

          toastSuccess(context, data['status']['message'] ?? '');
        }
      },
      onError: (DioException error, recoveryData) {
        if (error.response!.data != null) {
          final Map<String, dynamic> errors = error.response!.data;
          reportForm.setFormErrors(errors);

          if (errors.containsKey('status')) {
            dangerNativeToast(errors['status']['message'] ?? '');
            // ScaffoldMessenger.of(context).showSnackBar(
            //   SnackBar(
            //     content: Text(errors['status']['message'] ?? ''),
            //   ),
            // );
          }
        }
      },
    );
    final signatureController =
        useState(SignatureController(penStrokeWidth: 2.0));

    final ticketListQuery = useQuery(
      "ticket_id_list",
      () => fsr$.getFSRTickets(),
      onData: (data) {
        ticketOptions.value = data;
      },
      onError: (e) {},
    );

    useEffect(() {
      if (ticketID.value != null) {
        queryClient.refreshQuery("ticket_detail-${ticketID.value}");
      }
      return null;
    }, [ticketID.value]);
        
    useEffect(() {
      ticketListQuery.refresh();
      reportForm.form.reset();
      ticketID.value = id;
      reportForm.form.patchValue({
        'ack_rating': FSRService.satisfactionLevels[2][1],
        'ticket': id,
      });

      reportForm.form.control('ticket').valueChanges.listen((value) {
        // id.value = $value
        ticketID.value = value;
      });

      // reportForm.form.patchValue({
      //   // 'ticket': 'RT000018771',
      //   'customer': "John Doe",
      //   'contact_person': "Test 123",
      //   'client_address': "123 Test St.",
      //   'client_contact_no': "09123456789",
      //   'client_date': DateTime.now(),
      //   'client_time': DateTime.now(),
      //   'client_complain': 'Test complaint',
      //   'technical_team': "John Doe",
      //   // 'date': DateTime.now(),
      //   // 'time_started': DateTime.now(),
      //   // 'time_finished': DateTime.now(),
      //   'equipment': 'test 123',
      //   'mac': 'test 123',
      //   'serial': 'test 123',
      //   'red_los': true,
      //   'highloss': true,
      //   'service_affected': true,
      //   'modem_issue': true,
      //   'intermittent_connection': true,
      //   'diagnostics_others': 'other',
      //   're_fastconnector': true,
      //   'layout_foc': true,
      //   're_spliced': true,
      //   'changed_core': true,
      //   'changed_modem': true,
      //   'actions_others': 'other',
      //   'fast_connector_qty': 1,
      //   'coupler_qty': 1,
      //   'modular_qty': 1,
      //   'patchcord_qty': 1,
      //   'sleeve_qty': 1,
      //   'pigtail_qty': 1,
      //   'drop_fiber': '',
      //   'materials_others': '',
      //   'ack_service_delivered': true,
      //   'ack_unit_pulled_out': true,
      //   'ack_others': true,
      //   'ack_rating': FSRService.satisfactionLevels[0][1],
      //   'ack_comments': "asd asd asdkja hdaksjdhakjshd",
      //   'ack_clients_name': "234 242 4234 234 24 234 23423 ",
      // });
      return () => reportForm.form.reset();
    }, []);


    onSubmit() async {
      // Access the form's raw value
      final rawValues = reportForm.form.value;
      // print(rawValues);

      // Transform boolean fields into arrays of strings
      Map<String, dynamic> transformedData = Map.from(rawValues)
          ..removeWhere((key, value) => value == null);

      // Formatters for date and time
      final DateFormat dateFormatter = DateFormat('yyyy-MM-dd');
      final DateFormat timeFormatter = DateFormat('HH:mm');

      // Parse all DateTime fields into the required formats
      transformedData.forEach((key, value) {
        if (value is DateTime) {
          if (key.contains('date')) {
            // Format as YYYY-MM-DD
            transformedData[key] = dateFormatter.format(value);
          } else if (key.contains('time')) {
            // Format as HH:MM
            transformedData[key] = timeFormatter.format(value);
          }
        }
      });

      // Diagnostics/Findings
      List<String> diagnostics = [];
      [
        'red_los',
        'highloss',
        'service_affected',
        'modem_issue',
        'intermittent_connection',
        'diagnostics_others'
      ].forEach((key) {
        if (key == 'diagnostics_others' && rawValues[key] != null ) {
          diagnostics.add(rawValues[key].toString());
        } else if (rawValues[key] == true) {
          diagnostics.add(key);
        }
        transformedData.remove(key);
      });

      // Action Taken
      List<String> actions = [];
      [
        're_fastconnector',
        'layout_foc',
        're_spliced',
        'changed_core',
        'changed_modem',
        'actions_others'
      ].forEach((key) {
        if (key == 'actions_others' && rawValues[key] != null ) {
          actions.add(rawValues[key].toString());
        } else if (rawValues[key] == true) {
          actions.add(key);
        }
        transformedData.remove(key);
      });

      // Materials Used
      List<String> materials = [];
      [
        'fast_connector',
        'coupler',
        'modular',
        'patchcord',
        'sleeve',
        'pigtail',
        'drop_fiber',
      ].forEach((key) {
        if (rawValues[key] == true) {
          materials.add(key);
        }
        transformedData.remove(key);
      });

      // ACK_TYPES
      List<String> ackTypes = [];
      ['ack_service_delivered', 'ack_unit_pulled_out', 'ack_others']
          .forEach((key) {
        if (rawValues[key] == true) {
          ackTypes.add(key);
        }
        transformedData.remove(key);
      });

      // Add transformed lists back to the final payload
      transformedData['findings_diagnostics'] = diagnostics;
      transformedData['actions_taken'] = actions;
      transformedData['materials_used'] = materials;
      transformedData['ack_types'] = ackTypes;

      // Submit the transformed data
      await createFSRQ.mutate(transformedData);
    }

    void onNext() {
      switch (currentStep.value) {
        case 0:
          if (!reportForm.step1Valid()) {
            return;
          }
          break;
        case 1:
          if (!reportForm.step2Valid()) {
            return;
          }
          break;
        default:
      }
      if (currentStep.value < 2) {
        currentStep.value++;
      } else {
        if (reportForm.form.valid) {
          final data = reportForm.form.value;
          // Handle form submission logic here
          onSubmit();
        } else {
          reportForm.form.markAllAsTouched();
        }
      }

      // Reset scroll position to the top
      _scrollController.jumpTo(0.0);
    }

    void onBack() {
      if (currentStep.value > 0) {
        currentStep.value--;
      }
    }

    Widget buildProgressIndicator() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(3, (index) {
          return Expanded(
            child: Container(
              height: 4,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              color: index <= currentStep.value
                  ? AppColors.primary500
                  : Colors.grey.shade300,
            ),
          );
        }),
      );
    }

    List<Widget> stepContent() {
      return [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Client's Information",
              style: AppTextTheme.H3MediumPrimary,
            ),
            const SizedBox(height: 16),
            ReactiveDropdownInput(
                label: 'Select RT Ticket (optional)',
                formControlName: 'ticket',
                readOnly: ticketListQuery.isLoading,
                items: ticketOptions.value
                    .map((ticket) => DropdownMenuItem(
                          value: ticket.ticketId,
                          child: ClipRect(
                            child: Text(
                              '${ticket.ticketId} - ${ticket.subject}',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ))
                    .toList()),
            const SizedBox(height: 12),
            const ReactiveTextInput(
              label: 'Client’s Name',
              formControlName: 'customer',
              hintText: "Enter client’s name",
            ),
            const SizedBox(height: 12),
            const ReactiveTextInput(
              label: 'Contact Person',
              formControlName: 'contact_person',
              hintText: 'Enter contact person',
            ),
            const SizedBox(height: 12),
            const ReactiveTextInput(
              label: 'Address',
              formControlName: 'client_address',
              hintText: 'Enter address',
            ),
            const SizedBox(height: 12),
            const ReactiveTextInput(
              label: 'Contact No.',
              formControlName: 'client_contact_no',
              hintText: 'Enter contact number',
            ),
            const SizedBox(height: 12),
            // const ReactiveDateTimeInput(
            //   formControlName: 'client_date',
            //   label: 'Date Called',
            //   hintText: 'Enter Date',
            // ),
            // const SizedBox(height: 12),
            // ReactiveDateTimeInput(
            //   formControlName: 'client_time',
            //   type: ReactiveDatePickerFieldType.time,
            //   label: 'Time Called',
            //   hintText: 'Enter Time',
            //   dateFormat: DateFormat('hh:mm a'),
            // ),
            // const SizedBox(height: 16),
            const ReactiveTextInput(
              label: "Client's complaint",
              formControlName: 'client_complain',
              hintText: "Write client's complaint...",
              maxLines: 4,
            ),
          ],
        ),
        _buildStep2(ticket),
        _buildStep3()
      ];
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        title: Text(
          'File field service report',
          style: AppTextTheme.H6MediumPrimary.copyWith(
              fontWeight: FontWeight.w600),
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
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildProgressIndicator(), // Progress Indicator
            const SizedBox(height: 16),
            Expanded(
              child: ReactiveForm(
                formGroup: reportForm.form,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: stepContent()[currentStep.value],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              // add a border top in the button section
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (currentStep.value > 0)
                  Expanded(
                    // Ensure the "Back" button takes up full width in its space
                    child: ElevatedButton(
                      onPressed: createFSRQ.isMutating ? null : onBack,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 24.0),
                        side: const BorderSide(
                            color: Colors
                                .transparent), // Optional: Remove border if you want a flat button
                        elevation: 0,
                        minimumSize: const Size(100, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: const Text(
                        'Back',
                        style: TextStyle(
                          color: Colors.black, // Default text color
                        ),
                      ),
                    ),
                  ),
                const SizedBox(width: 16),
                Expanded(
                  // Ensure the "Continue" button takes up full width in its space
                  child: ElevatedButton(
                    onPressed: createFSRQ.isMutating ? null : onNext,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 24.0),
                      backgroundColor: AppColors.primary500,
                      minimumSize: const Size(100, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: createFSRQ.isMutating
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : Text(
                            currentStep.value < 2 ? 'Continue' : 'Submit',
                            style: const TextStyle(color: Colors.white),
                          ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildStep3() {
    final signatureController =
        useState(SignatureController(penStrokeWidth: 2.0));
    final renderState = useState(0);

    signatureController.value.toSVG(width: 50, height: 50);

    useEffect(() {
      Timer? debounceTimer; // Declare a debounce timer

      Future<void> captureSignature() async {
        try {
          // Check if there is any drawing on the canvas
          if (signatureController.value.isEmpty) {
            reportForm.form.control('signature').updateValue(null);
            renderState.value++;
            return;
          }

          // Convert the signature to PNG bytes
          final Uint8List? signatureBytes =
              await signatureController.value.toPngBytes();

          if (signatureBytes == null) {
            reportForm.form.control('signature').updateValue(null);
            return;
          }

          // Convert PNG bytes to a Base64 string
          final String base64Signature = base64Encode(signatureBytes);

          // Update the form control with the Base64 string
          reportForm.form.control('signature').updateValue(base64Signature);
        } catch (e) {
          // Handle errors gracefully
          reportForm.form.control('signature').updateValue(null);
        }

        reportForm.form.control('signature').updateValueAndValidity();
        renderState.value++;
      }

      // Add listener to the SignatureController
      signatureController.value.addListener(() {
        // Cancel the existing timer, if any
        if (debounceTimer?.isActive ?? false) debounceTimer!.cancel();

        // Start a new timer
        debounceTimer = Timer(const Duration(milliseconds: 300), () {
          captureSignature(); // Call the async helper function after debounce time
        });
      });

      if (auth$.currentUser != null) {
        reportForm.form.control('technical_team').updateValue(auth$.currentUser!.firstName);
      };

      // Dispose the controller and cancel the timer on cleanup
      return () {
        debounceTimer?.cancel();
        signatureController.value.dispose();
      };
    }, []);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Client acknowledgment",
          style: AppTextTheme.H3MediumPrimary,
        ),
        const SizedBox(height: 24),

        // Checkbox 1
        CustomCheckbox(
          formControlName: 'ack_service_delivered',
          // label: "The above-stated services, installation, repair and/or replacement parts were delivered, installed, and fully operational.",
          label:
              'The above-stated services, installation, repair and/or replacement parts were delivered, installed and fully operational.',
          checkboxPosition: CheckboxPosition.start, // Override default
        ),
        const SizedBox(height: 4),
        // Checkbox 2
        CustomCheckbox(
          formControlName: 'ack_unit_pulled_out',
          // label: "The above-stated services, installation, repair and/or replacement parts were delivered, installed, and fully operational.",
          label: 'The above-described unit/s was/were pulled out.',
          checkboxPosition: CheckboxPosition.start, // Override default
        ),
        const SizedBox(height: 4),
        // Checkbox 3 (Others)
        CustomCheckbox(
          formControlName: 'ack_others',
          // label: "The above-stated services, installation, repair and/or replacement parts were delivered, installed, and fully operational.",
          label: 'Others',
          checkboxPosition: CheckboxPosition.start, // Override default
        ),

        const SizedBox(height: 4),

        Text(
          'How satisfied are you with the service call?',
          style: AppTextTheme.LabelMdMediumPrimary,
        ),

        const SizedBox(height: 24),
        SatisfactionSurvey(
          options: FSRService.satisfactionLevels,
          formControlName: 'ack_rating',
          form: reportForm.form,
          onOptionSelected: (selectedOption) {
            // Handle the selected option here
            print('Selected option: $selectedOption');
          },
        ),

        const SizedBox(height: 24),

        // Comments Field
        const ReactiveTextInput(
          label: "Comments",
          formControlName: 'ack_comments',
          hintText: "Write your comments...",
          maxLines: 4,
        ),

        const SizedBox(height: 24),
        const ReactiveTextInput(
          label: "Client's name",
          formControlName: 'ack_clients_name',
          hintText: 'Enter client’s name',
        ),
        const SizedBox(height: 24),

        Text(
          'Signature',
          style: AppTextTheme.BodySmSecondary,
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.strokePrimary),
            borderRadius: BorderRadius.circular(8.0),
          ),
          height: 150,
          child: Signature(
            controller: signatureController.value,
            backgroundColor: Colors.white,
          ),
        ),
        if (reportForm.form.control('signature').hasErrors) ...[
          const SizedBox(height: 8),
          Text(
            reportForm.form.control('signature').errors!.containsKey('required')
                ? 'Signature is required'
                : 'An error occurred while capturing the signature',
            style: const TextStyle(color: Colors.red),
          ),
        ],
        const SizedBox(height: 16),
        TextButton(
          onPressed: () => signatureController.value.clear(),
          child: const Text(
            'Clear Signature',
            style: TextStyle(color: AppColors.primary500),
          ),
        ),
      ],
    );
  }

  Widget _buildStep2(TicketItem? ticket) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section: Technical Team
        const Text('Field Service Report',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),

        const ReactiveTextInput(
          label: 'Technical Team',
          formControlName: 'technical_team',
          hintText: "Enter team name",
        ),
        const SizedBox(height: 16),

        // Section: Date and Contact
        ReactiveDateTimeInput(
          label: 'Date Responded',
          type: ReactiveDatePickerFieldType.date,
          dateFormat: DateFormat('yyyy-MM-dd'),
          formControlName: 'date',
          hintText: "Enter date",
          readOnly: ticket?.timeIn != null,
        ),
        const SizedBox(height: 16),
        ReactiveDateTimeInput(
          formControlName: 'time_started',
          type: ReactiveDatePickerFieldType.time,
          label: 'Time Started',
          hintText: 'Enter time',
          dateFormat: DateFormat('hh:mm a'),
          readOnly: ticket?.timeIn != null,
          
        ),
        const SizedBox(height: 16),
        ReactiveDateTimeInput(
          formControlName: 'time_finished',
          type: ReactiveDatePickerFieldType.time,
          label: 'Time Finished',
          hintText: 'Enter Time',
          dateFormat: DateFormat('hh:mm a'),
          readOnly: ticket?.timeOut != null,

        ),
        const SizedBox(height: 16),

        // Equipment and Contact Number
        const ReactiveTextInput(
          label: 'Equipment',
          formControlName: 'equipment',
          hintText: 'Enter equipment',
        ),
        const SizedBox(height: 16),

        const ReactiveTextInput(
          label: 'Modem Brand',
          formControlName: 'brand',
          hintText: 'Enter brand',
        ),
        const SizedBox(height: 16),

        // Diagnostics/Findings
        const Text('Diagnostics/Findings',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        CustomCheckbox(
          formControlName: 'red_los',
          label: 'Red LOS (Fibercut)',
        ),
        CustomCheckbox(
          formControlName: 'highloss',
          label: 'Highloss',
        ),
        CustomCheckbox(
          formControlName: 'service_affected',
          label: 'Service are affected (Fiberbreak)',
        ),
        CustomCheckbox(
          formControlName: 'modem_issue',
          label: 'Modem Issue',
        ),
        CustomCheckbox(
          formControlName: 'intermittent_connection',
          label: 'Intermittent Connection',
        ),
        const Column(
          children: [
            ReactiveTextInput(
              label: 'Others, specify',
              formControlName: 'diagnostics_others',
              hintText: 'Please specify here...',
              maxLines: 4,
            ),
          ],
        ),
        const ReactiveTextInput(
          label: 'MAC Address',
          formControlName: 'mac',
          hintText: 'Enter mac address',
        ),
        const SizedBox(height: 12),
        const ReactiveTextInput(
          label: 'Serial No.',
          formControlName: 'serial',
          hintText: 'Enter serial number',
        ),
        const SizedBox(height: 24),

        // Action Taken
        const Text('Action Taken',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        CustomCheckbox(
          formControlName: 're_fastconnector',
          label: 'Re-fastconnector',
        ),
        CustomCheckbox(
          formControlName: 'layout_foc',
          label: 'Layout FOC',
        ),
        CustomCheckbox(
          formControlName: 're_spliced',
          label: 'Re-spliced',
        ),
        CustomCheckbox(
          formControlName: 'changed_core',
          label: 'Changed Core',
        ),
        CustomCheckbox(
          formControlName: 'changed_modem',
          label: 'Changed Modem',
        ),
        const Column(
          children: [
            ReactiveTextInput(
              label: 'Others, specify',
              formControlName: 'actions_others',
              hintText: 'Please specify here...',
              maxLines: 4,
            ),
          ],
        ),
        const SizedBox(height: 16),

        const Text('Materials Used',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const CounterFormField(
            label: 'Fast Connector', formControlName: 'fast_connector_qty'),
          
        const CounterFormField(
            label: 'Coupler', formControlName: 'coupler_qty'),
        const CounterFormField(
            label: 'Modular', formControlName: 'modular_qty'),
        const CounterFormField(
            label: 'Patchord', formControlName: 'patchord_qty'),
        const CounterFormField(label: 'Sleeve', formControlName: 'sleeve_qty'),
        const CounterFormField(
            label: 'Pigtail', formControlName: 'pigtail_qty'),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Drop fiber"),
            SizedBox(
              width: 156,
              child: ReactiveTextInput(
                formControlName: 'drop_fiber_mt',
                hintText: 'meters',
              ),
            ),
          ],
        ),
        const Column(
          children: [
            ReactiveTextInput(
              label: 'Others, specify',
              formControlName: 'materials_others',
              hintText: 'Please specify here...',
              maxLines: 4,
            ),
          ],
        )
      ],
    );
  }
}
