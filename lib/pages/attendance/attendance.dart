import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:apollo_tracker_mobile/theme/colors.dart';
import 'package:apollo_tracker_mobile/theme/texts.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class AttendancePage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    // Use a Hook to track the "Time In" state and current work duration
    final isTimedIn = useState(false);
    final startTime = useState<DateTime?>(null);
    final currentDuration = useState(Duration.zero);

    // A periodic timer to update the displayed work duration
    useEffect(() {
      if (isTimedIn.value) {
        final timer = Timer.periodic(const Duration(seconds: 1), (timer) {
          currentDuration.value = DateTime.now().difference(startTime.value!);
        });
        return timer.cancel;
      }
      return null;
    }, [isTimedIn.value]);

    // Function to handle "Time In" button press
    void handleTimeIn() {
      if (!isTimedIn.value) {
        isTimedIn.value = true;
        startTime.value = DateTime.now();
      }
    }

    // Format the duration as HH:mm:ss
    String formatDuration(Duration duration) {
      final hours = duration.inHours.toString().padLeft(2, '0');
      final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
      final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
      return "$hours:$minutes:$seconds";
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Attendance",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(PhosphorIcons.calendarBlank(), size: 20, color: Colors.grey),
                      const SizedBox(width: 8),
                      Text(
                        "November 28, 2024",
                        style: AppTextTheme.BodyMdPrimary,
                      ),
                    ],
                  ),
                  Text(
                    "8:49 AM",
                    style: AppTextTheme.BodyMdPrimary,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                isTimedIn.value ? "You're working!" : "Let’s get to work!",
                style: AppTextTheme.H4SemiBoldPrimary,
              ),
              const SizedBox(height: 8),
              Text(
                formatDuration(currentDuration.value),
                style: AppTextTheme.H4SemiBoldPrimary.copyWith(color: Colors.grey),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: isTimedIn.value ? null : handleTimeIn,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary500,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: const Text(
                  "Time In",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 32),
              Text(
                "This week's logs",
                style: AppTextTheme.BodyMdPrimary,
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView(
                  children: [
                    _buildAttendanceLog("Nov 28, 2024", "08:01 total hrs", "09:00 AM - 5:01 PM"),
                    _buildAttendanceLog("Nov 27, 2024", "08:01 total hrs", "09:00 AM - 5:01 PM"),
                    _buildAttendanceLog("Nov 26, 2024", "08:01 total hrs", "09:00 AM - 5:01 PM"),
                    _buildAttendanceLog("Nov 25, 2024", "08:01 total hrs", "09:00 AM - 5:01 PM"),
                    _buildAttendanceLog("Nov 24, 2024", "08:01 total hrs", "09:00 AM - 5:01 PM"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAttendanceLog(String date, String hours, String timeRange) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                date,
                style: AppTextTheme.BodyMdPrimary,
              ),
              Text(
                hours,
                style: AppTextTheme.BodySmSecondary,
              ),
            ],
          ),
          Text(
            timeRange,
            style: AppTextTheme.BodyMdPrimary,
          ),
        ],
      ),
    );
  }
}
