import 'package:apollo_tracker_mobile/commons/forms/users.form.dart';
import 'package:apollo_tracker_mobile/commons/services/attendance.service.dart';
import 'package:apollo_tracker_mobile/commons/services/auth.service.dart';
import 'package:dio/dio.dart';
import 'package:fl_query_hooks/fl_query_hooks.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:device_info_plus/device_info_plus.dart'; // New Import
import 'dart:io';

final form = AttendanceForm();

class AttendancePage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final dateTime = useState(DateFormat('MMM. d, yyyy hh:mm a').format(DateTime.now()));
    final checkInTime = useState<String?>(null);  // To hold the check-in time
    final isTimeIn = useState<bool>(false);  // To hold the check-in time
    final queryClient = useQueryClient();

    final attendanceCheckQuery = useQuery(
      'attendance-check', 
      () => attendance$.check(),
      onData: (value) {
        // Check if the user has already checked in
        checkInTime.value = null;  // Store the check-in time
        isTimeIn.value = value.data.timeIn;
        if (value.data.timeIn) {
          checkInTime.value = value.data.time;  // Store the check-in time
        }
      },
      onError: (DioException err) {
      },
    );

    final attendanceCheckIn = useMutation(
      'agent-check-in', 
      (data) => attendance$.checkIn(data),
      onData: (value, revData) {
          queryClient.refreshQuery('attendance-check');
          final response = value; 
          // auth$.currentUser!.timeInToday = response;
          if (response != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Time In successfully!')),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Time-in failed!')),
            );
          }
      },
      onError: (DioException err, obj) {
        if (err.response!.data != null) {
          final Map<String, dynamic> errors = err.response!.data;
          final msg = errors['status']['message'] ?? '';

          if (msg.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(errors['status']['message'] ?? ''),
              ),
            );
          }
        }
      },
    );

    final attendanceCheckOut = useMutation(
      'agent-check-out', 
      (data) => attendance$.checkOut(data),
      onData: (data, revData) {
        final hoursWorked = data.hoursWorked;
        queryClient.refreshQuery('attendance-check');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("$hoursWorked hours worked!")),
        );
      },
      onError: (DioException err, obj) {
        if (err.response!.data != null) {
          final Map<String, dynamic> errors = err.response!.data;
          final msg = errors['status']['message'] ?? '';

          if (msg.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(errors['status']['message'] ?? ''),
              ),
            );
          }
        }
      },
    );

    Future initForm() async {
      // Get the current location
      final hasPermission = await _handlePermission();
      if (hasPermission) {
        final position = await Geolocator.getCurrentPosition(locationSettings: const LocationSettings(accuracy: LocationAccuracy.high));
        form.form.control('latitude').value = position.latitude.toString();
        form.form.control('longitude').value = position.longitude.toString();
        form.form.control('accuracy').value = position.accuracy.toString();
      }

      // Set the hardware ID
      final hardwareId = await _getDeviceId();
      form.form.control('hardwareId').value = hardwareId;

    }

    useEffect(() {
      // Timer to update the dateTime state every minute
      final timer = Stream.periodic(const Duration(seconds: 60)).listen((_) {
        dateTime.value = DateFormat('MMM. d, yyyy hh:mm a').format(DateTime.now());
      });

      queryClient.refreshQuery('attendance-check');

      initForm();
      
      return timer.cancel;
    }, []);

    if (attendanceCheckQuery.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (attendanceCheckQuery.hasError) {
      return const Scaffold(body: Text('Error loading user data'));
    }

    Future checkOut() async {
      // Reset and initialize the form
      form.form.reset();
      await initForm();

      // Parse the check-in time
      if (checkInTime.value != null) {
        final checkInDateTime = DateFormat('MMM. d, yyyy hh:mm a').parse(checkInTime.value!);
        final currentDateTime = DateTime.now();

        // Calculate the duration in minutes
        final duration = currentDateTime.difference(checkInDateTime).inHours;

        if (duration < 8) {
          // Show confirmation dialog if duration is less than 1 hour
          final confirm = await showDialog<bool>(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text('You are currently undertime'),
              content: const Text(
                'Are you sure you want to time-out?',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(false), // Cancel
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(true), // Confirm
                  child: const Text('Time Out'),
                ),
              ],
            ),
          );

          // If the user cancels, return early
          if (confirm != true) return;
        }
      }

      // Proceed with the check-out
      attendanceCheckOut.mutate(form.form.value);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                dateTime.value,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              if (checkInTime.value != null)
                Text(
                  'Time In at: ${checkInTime.value}',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),

              if (!isTimeIn.value)
                ElevatedButton(
                  onPressed: attendanceCheckIn.isMutating ? null : () async {
                    // Handle Check-In logic here
                    await initForm();
                    if (form.form.valid) {
                      // Prepare data to send to the checkIn function
                      final data = form.form.value;
                      await attendanceCheckIn.mutate(data); // Call the checkIn function
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Form is incomplete!')),
                      );
                    }
                  },
                  child: const Text('Time In'),
                ),
              const SizedBox(height: 16),
              if (isTimeIn.value)
                ElevatedButton(
                  onPressed: attendanceCheckIn.isMutating ? null : () {
                    // Handle Check-In logic here
                    if (form.form.valid) {
                      // Prepare data to send to the checkIn function
                      checkOut();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Form is incomplete!')),
                      );
                    }
                  },
                  child: const Text('Time Out'),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _handlePermission() async {
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

  Future<String> _getDeviceId() async {
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
}