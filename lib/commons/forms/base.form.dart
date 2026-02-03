import "package:dio/dio.dart";
import "package:reactive_forms/reactive_forms.dart";

import "package:apollo_tracker_mobile/commons/utils/helper.util.dart";


class Form {
  late FormGroup _form;
  String? nonFieldError;

  Form(
      {required Map<String, Object> fields,
      List<Validator<dynamic>>? validators}) {
    _form = FormBuilder().group(fields, validators ?? []);
  }

  bool get isValid {
    return _form.valid;
  }

  valid(String f) {
    return !(!_form.control(f).valid && _form.control(f).touched);
  }

  FormGroup get form => _form;

  void setFormErrors(Map<String, dynamic> errors) {
    void _setObjError(Map<String, dynamic> errs, [FormGroup? parent]) {
      parent ??= _form;
      errs.forEach((key, value) {
        try {
          var control = (parent)?.control(key);
          if (control is FormArray) {
            if (value is List<String>) {
              control.setErrors({'error': value});
            } else if (value is List<Map<String, dynamic>>) {
              for (var i = 0; i < value.length; i++) {
                _setObjError(value[i], control.controls[i] as FormGroup);
              }
            }
          } else {
            control?.setErrors({'error': value[0]});
          }
        } catch (e) {}
      });
    }

    _setObjError(errors);

    if (errors.containsKey('non_field_errors')) {
      // Handle non field errors
      nonFieldError = (errors['non_field_errors'][0]).toString();
    }
  }

  FormData get formData {
    return objectToFormData(form.value);
  }
}
