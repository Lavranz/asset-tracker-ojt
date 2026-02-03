import 'package:flutter/material.dart';
import 'package:apollo_tracker_mobile/theme/colors.dart';
import 'package:apollo_tracker_mobile/theme/texts.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

void showTimeOutModal(BuildContext context, Duration workedDuration, checkOut) {
  // Format the duration to a string like "08:01:34"
  String formatDuration(Duration duration) {
    final hours = duration.inHours.toString().padLeft(2, '0');
    final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    return "$hours:$minutes hrs";
  }

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Modal Title
              Row(
                children: [
                  Expanded(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Centered title
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            "Confirm time out",
                            style: AppTextTheme.H6MediumPrimary,
                          ),
                        ),
                        // Close button aligned to the right
                        Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            icon: Icon(
                              PhosphorIcons.x(PhosphorIconsStyle.bold),
                              color: AppColors.contentDefaultPrimary,
                              size: 18,
                            ),
                            onPressed: () {
                              Navigator.of(context).pop(); // Close the modal
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Subtitle
              Text(
                "You've worked a total of",
                style: AppTextTheme.LabelMdPrimary.copyWith(
                    color: AppColors.contentDefaultTertiary),
              ),
              const SizedBox(height: 8),
              // Total hours worked
              Text(
                formatDuration(workedDuration),
                style: AppTextTheme.H2MediumPrimary,
              ),
              const SizedBox(height: 24),
              // Action buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Cancel button
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the modal
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                        ),
                        side: const BorderSide(
                            color: Color.fromARGB(0, 158, 158, 158)),
                      ),
                      child: Text(
                        "Cancel",
                        style: AppTextTheme.LabelMdPrimary.copyWith(
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8), // Add spacing between buttons
                  // Confirm button
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle confirmation logic
                        Navigator.of(context).pop(); // Close the modal
                        checkOut();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary500,
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        "Confirm",
                        style: AppTextTheme.LabelMdPrimary.copyWith(
                          fontSize: 16.0,
                          color: AppColors.light,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

void showUnavailableModal(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Modal Title
              // Modal Title
              Row(
                children: [
                  Expanded(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Centered title
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            "Time In Unavailable",
                            style: AppTextTheme.H6MediumPrimary,
                          ),
                        ),
                        // Close button aligned to the right
                        Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            icon: Icon(
                              PhosphorIcons.x(PhosphorIconsStyle.bold),
                              color: AppColors.contentDefaultPrimary,
                              size: 18,
                            ),
                            onPressed: () {
                              Navigator.of(context).pop(); // Close the modal
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),
              // Clock icon
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.warning50,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Icon(
                  PhosphorIcons.clock(),
                  size: 32,
                  color: AppColors.warning500,
                ),
              ),
              const SizedBox(height: 16),
              // Subtitle
              Text(
                "You have already timed in for today. Your next time-in will be available tomorrow.",
                style: AppTextTheme.BodyMdPrimary,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 36),
              // Action button
              Row(
                children: [
                  Expanded(
                      child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the modal
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary500,
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 24,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text("Got it",
                        style: TextStyle(color: AppColors.light)),
                  )),
                ],
              )
            ],
          ),
        ),
      );
    },
  );
}
