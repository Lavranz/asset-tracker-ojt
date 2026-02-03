import 'package:reactive_forms/reactive_forms.dart';

final validationConfigs = {
  ValidationMessage.required: (_) => 'This field is required',
  ValidationMessage.minLength: (_) => 'This field must have at least ${_['requiredLength']} characters',
  ValidationMessage.maxLength: (_) => 'This field must not exceed to ${_['requiredLength']} characters',
  ValidationMessage.email: (_) => 'This field must be a valid email',
  ValidationMessage.mustMatch: (_) => 'Password does not match',
  'uniqueEmail': (_) => 'This email is already in use',
  'error': (_) => _.toString(),
};
