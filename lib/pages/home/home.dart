import 'package:apollo_tracker_mobile/commons/services/attendance.service.dart';
import 'package:apollo_tracker_mobile/commons/services/auth.service.dart';
import 'package:apollo_tracker_mobile/theme/texts.dart';
import 'package:fl_query_hooks/fl_query_hooks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart'; // Import Phosphor icons

class HomePage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final attendanceCheckQuery = useQuery(
      'attendance-check-home',
      () => attendance$.check(),
      onData: (value) {
        // Parse the time string into a DateTime object

        if (value.data.time != null) {
          final DateFormat dateFormat = DateFormat('MMM. dd, yyyy hh:mm a');
          final DateTime timeInDate = dateFormat.parse(value.data.time ?? '');
          final bool isNotToday = timeInDate.toLocal().day !=
                  DateTime.now().toLocal().day ||
              timeInDate.toLocal().month != DateTime.now().toLocal().month ||
              timeInDate.toLocal().year != DateTime.now().toLocal().year;

          if (isNotToday) {
            // Show alert with options
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Attendance Reminder'),
                  content: const Text(
                      'You have not checked out yet. Please proceed to the attendance page.'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        // Navigate to the attendance page
                        context.pop();
                        context.push('/attendance');
                      },
                      child: const Text('Time out'),
                    ),
                    TextButton(
                      onPressed: () {
                        // Close the dialog
                        context.pop();
                      },
                      child: const Text('Cancel'),
                    ),
                  ],
                );
              },
            );
          }
        }
      },
    );

    // Get today's date and format it
    final String currentDate = DateFormat('MMM d, yyyy').format(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Hi, ${auth$.user?.agent.firstName ?? 'Agent'}",
              style: AppTextTheme.BodySmMediumPrimary,
            ),
            Text(
              currentDate,
              style: AppTextTheme.CaptionMd,
            ),
          ],
        ),
        centerTitle: false,
      ),
      body: Center(
          // Center the button
          child: Column(
        children: [
          ElevatedButton.icon(
            onPressed: () {
              // Navigate to the /attendance route
              context.push('/attendance');
            },
            icon: Icon(
              PhosphorIcons.calendarCheck(
                  PhosphorIconsStyle.bold), // Phosphor icon for attendance
              size: 24,
            ),
            label: const Text(
              'Attendance',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              // Navigate to the /attendance route
              context.push('/view-locations');
            },
            icon: Icon(
              PhosphorIcons.mapPin(
                  PhosphorIconsStyle.bold), // Phosphor icon for attendance
              size: 24,
            ),
            label: const Text(
              'View Location',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      )),
    );
  }
}
