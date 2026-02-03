import 'dart:io';

import 'package:apollo_tracker_mobile/commons/forms/base.form.dart';
// import 'package:apollo_tracker_mobile/commons/forms/validator.form.dart';
import 'package:reactive_forms/reactive_forms.dart';

class LoginForm extends Form {
  LoginForm()
      : super(fields: {
          'username': FormControl(validators: [Validators.required]),
          'password': FormControl(validators: [Validators.required]),
        });
}

class FSRForm extends Form {
  FSRForm()
      : super(fields: {
          'name': FormControl<String>(validators: [Validators.required]),
          'remarks': FormControl<String>(validators: [Validators.required]),
          'signature': FormControl<String>(validators: [Validators.required]),
        });
}

class TicketResponseForm extends Form {
  TicketResponseForm()
      : super(fields: {
          'ticket_id': FormControl<String>(validators: [Validators.required]),
          'status': FormControl<String>(validators: [Validators.required]),
          'message': FormControl<String>(validators: [Validators.required]),
        });
}

class AttendanceForm extends Form {
  AttendanceForm()
      : super(fields: {
          'latitude': FormControl<String>(validators: [Validators.required]),
          'accuracy': FormControl<String>(validators: [Validators.required]),
          'longitude': FormControl<String>(validators: [Validators.required]),
          'hardwareId': FormControl<String>(validators: [Validators.required]),
        });
}

class TicketCommentForm extends Form {
  TicketCommentForm()
      : super(fields: {
          'bcc': FormControl<List<String>>(value: [], validators: []),
          'cc': FormControl<List<String>>(value: [], validators: []),
          'message': FormControl<String>(value: null, validators: [Validators.required]),
          'attachments': FormControl<List<File>>(
              value: [], validators: [Validators.required]),
        });
}

class FieldServiceReportForm extends Form {
  FieldServiceReportForm()
      : super(fields: {
          // Step 1
          'ticket': FormControl<String>(validators: []),
          'customer': FormControl<String>(validators: [Validators.required]),
          'contact_person':
              FormControl<String>(validators: [Validators.required]),
          'client_address':
              FormControl<String>(validators: [Validators.required]),
          'client_contact_no': FormControl<String>(validators: [
              Validators.required,
              Validators.minLength(11),
              Validators.maxLength(11),
              Validators.pattern(r'^[0-9]+$', validationMessage: 'Invalid number')
            ]
          ),
          'client_date':
              FormControl<DateTime>(validators: []),
          'client_time':
              FormControl<DateTime>(validators: []),
          'client_complain':
              FormControl<String>(validators: [Validators.required]),

          // Step 2
          'technical_team':
              FormControl<String>(validators: [Validators.required]),
          'date':
              FormControl<DateTime>(validators: [Validators.required]),
          'time_started':
              FormControl<DateTime>(validators: [Validators.required]),
          'time_finished':
              FormControl<DateTime>(validators: [Validators.required]),
          'equipment': FormControl<String>(),
          'brand': FormControl<String>(),
          'mac': FormControl<String>(),
          'serial': FormControl<String>(),

          // Diagnostics/Findings
          'red_los': FormControl<bool>(value: false),
          'highloss': FormControl<bool>(value: false),
          'service_affected': FormControl<bool>(value: false),
          'modem_issue': FormControl<bool>(value: false),
          'intermittent_connection': FormControl<bool>(value: false),
          'diagnostics_others': FormControl<String>(value: null),

          // Action Taken
          're_fastconnector': FormControl<bool>(value: false),
          'layout_foc': FormControl<bool>(value: false),
          're_spliced': FormControl<bool>(value: false),
          'changed_core': FormControl<bool>(value: false),
          'changed_modem': FormControl<bool>(value: false),
          'actions_others': FormControl<String>(value: null),          

          // Materials Used
          // 'fast_connector': FormControl<bool>(value: false),
          // 'coupler': FormControl<bool>(value: false),
          // 'modular': FormControl<bool>(value: false),
          // 'patchcord': FormControl<bool>(value: false),
          // 'sleeve': FormControl<bool>(value: false),
          // 'pigtail': FormControl<bool>(value: false),
          // 'drop_fiber': FormControl<bool>(value: false),
          // 'materials_others': FormControl<bool>(value: false),
          "fast_connector_qty":  FormControl(value: 0),
          "coupler_qty":  FormControl(value: 0),
          "modular_qty":  FormControl(value: 0),
          "patchord_qty":  FormControl(value: 0),
          "sleeve_qty":  FormControl(value: 0),
          "pigtail_qty":  FormControl(value: 0),
          "drop_fiber_mt":  FormControl<String>(value: null),
          "materials_others":  FormControl<String>(value: null),

          // Step 3

          // ACK_TYPES
          'ack_service_delivered': FormControl<bool>(value: false),
          'ack_unit_pulled_out': FormControl<bool>(value: false),
          'ack_others': FormControl<bool>(value: false),

          'ack_rating':
              FormControl<String>(validators: [Validators.required]),
          'ack_comments': FormControl<String>(),
          'signature': FormControl<String>(validators: [Validators.required]),
          'ack_clients_name': FormControl<String>(validators: [Validators.required]),
        });

    bool step1Valid(){
      form.control('ticket').markAsTouched();
      form.control('customer').markAsTouched();
      form.control('contact_person').markAsTouched();
      form.control('client_address').markAsTouched();
      form.control('client_contact_no').markAsTouched();
      form.control('client_date').markAsTouched();
      form.control('client_time').markAsTouched();
      form.control('client_complain').markAsTouched();

      return form.control('ticket').valid &&
          form.control('customer').valid &&
          form.control('contact_person').valid &&
          form.control('client_address').valid &&
          form.control('client_contact_no').valid &&
          form.control('client_date').valid &&
          form.control('client_time').valid &&
          form.control('client_complain').valid;
    }

    bool step2Valid(){
      form.control('technical_team').markAsTouched();
      form.control('date').markAsTouched();
      form.control('time_started').markAsTouched();
      form.control('time_finished').markAsTouched();
      form.control('equipment').markAsTouched();
      form.control('brand').markAsTouched();
      form.control('mac').markAsTouched();
      form.control('serial').markAsTouched();

      return form.control('technical_team').valid &&
          form.control('date').valid &&
          form.control('time_started').valid &&
          form.control('time_finished').valid &&
          form.control('equipment').valid &&
          form.control('brand').valid &&
          form.control('mac').valid &&
          form.control('serial').valid;
    }

    bool step3Valid(){
      form.control('ack_service_delivered').markAsTouched();
      form.control('ack_unit_pulled_out').markAsTouched();
      form.control('ack_others').markAsTouched();
      form.control('satisfaction_level').markAsTouched();
      form.control('comments').markAsTouched();
      form.control('signature').markAsTouched();
      form.control('client_name').markAsTouched();

      return form.control('ack_service_delivered').valid &&
          form.control('ack_unit_pulled_out').valid &&
          form.control('ack_others').valid &&
          form.control('satisfaction_level').valid &&
          form.control('comments').valid &&
          form.control('signature').valid &&
          form.control('client_name').valid;
    }
}
