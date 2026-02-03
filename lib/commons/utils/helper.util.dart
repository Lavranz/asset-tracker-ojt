// Check if object is empty.
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';

bool objIsEmpty(Map obj) {
  return obj.keys.isEmpty;
}

bool toBoolean(dynamic data) {
  return data != null;
}

FormData objectToFormData(Map<String, dynamic> data) {
  FormData formData = FormData();

  void processData(String prefix, dynamic data) {
    if (data is Map<String, dynamic>) {
      data.forEach((key, value) {
        String formKey = prefix.isEmpty ? key : "$prefix[$key]";
        processData(formKey, value);
      });
    } else if (data is List) {
      for (var i = 0; i < data.length; i++) {
        processData("$prefix[$i]", data[i]);
      }
    } else {
      if (data is File) {
        String fileName = data.path.split('/').last;
        formData.files.add(MapEntry(
            prefix, MultipartFile.fromFileSync(data.path, filename: fileName)));
      } else {
        formData.fields.add(MapEntry(prefix, data.toString()));
      }
    }
  }

  processData("", data);
  return formData;
}

FormData removeNullFields(FormData formData, List<String> fieldNames) {
  Map<String, dynamic> nonNullData = {};

  // Iterate through FormData fields
  for (var element in formData.fields) {
    // Check if the element's key is in the list of field names
    if (fieldNames.contains(element.key)) {
      // Only add the field if the value is not null
      if (element.value != "null") {
        nonNullData[element.key] = element.value;
      }
    } else {
      // If the field is not in the list, add it regardless of its value
      nonNullData[element.key] = element.value;
    }
  }
  // Iterate through FormData fields
  for (var file in formData.files) {
    // Check if the file's key is in the list of field names
    if (fieldNames.contains(file.key)) {
      // Only add the field if the value is not null
      if (file.value != "null") {
        nonNullData[file.key] = file.value;
      }
    } else {
      // If the field is not in the list, add it regardless of its value
      nonNullData[file.key] = file.value;
    }
  }

  // Return new FormData with non-null fields of interest
  return FormData.fromMap(nonNullData);
}

Future<bool> validateFileSize(String filePath, num limit) async {
  File file = File(filePath);
  int fileSize = await file.length(); // File size in bytes

  if (fileSize > limit) {
    return false;
  }
  return true;
}

String formatDate(String date, {String format = 'yyyy-MM-dd', String inputFormat = 'EEE MMM dd HH:mm:ss yyyy'}) {
  if (date == 'Not set' || date.isEmpty) {
    return date;
  }

  try {
    // Define the custom format that matches the input date string
    DateFormat inpF = DateFormat(inputFormat);

    // Parse the date string into a DateTime object
    DateTime parsedDate = inpF.parse(date);

    // Format the DateTime object into the desired output format
    return DateFormat(format).format(parsedDate);
  } catch (e) {
    // Handle parsing errors
    return 'Invalid date';
  }
}

Future<String> getDeviceId() async {
  final deviceInfo = DeviceInfoPlugin();

  if (kIsWeb) {
    return 'Web Browser'; // Web doesn't have a hardware ID
  } else if (Platform.isAndroid) {
    final androidInfo = await deviceInfo.androidInfo;
    return androidInfo.id; // Unique Android ID
  } else if (Platform.isIOS) {
    final iosInfo = await deviceInfo.iosInfo;
    return iosInfo.identifierForVendor ?? 'Unknown'; // Unique iOS identifier
  }
  return 'Unsupported Platform';
}

Future<bool> handleLocationPermission() async {
  final permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    final requestResult = await Geolocator.requestPermission();
    if (requestResult == LocationPermission.deniedForever) {
      // Permission is permanently denied
      return false;
    }
    return requestResult != LocationPermission.denied;
  }
  return permission != LocationPermission.denied;
}

bool validData(dynamic data) {
  if (data == null) return false;

  if (data is String) {
    return data.trim().isNotEmpty;
  }

  if (data is List) {
    return data.isNotEmpty;
  }

  if (data is Map) {
    return data.isNotEmpty;
  }

  if (data is num) {
    return true; // or add range checks if needed
  }

  if (data is bool) {
    return true;
  }

  // For any other object type
  return true;
}
