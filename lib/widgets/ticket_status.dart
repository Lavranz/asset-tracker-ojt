import 'package:apollo_tracker_mobile/commons/models/ticket.model.dart';
import 'package:apollo_tracker_mobile/theme/colors.dart';
import 'package:apollo_tracker_mobile/theme/texts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class TicketStatus extends HookWidget {
  final String status;

  const TicketStatus({
    super.key,
    required this.status,
  });

  Color _getBackgroundColor(String status) {
    switch (status.toLowerCase()) {
      case '100':
        return AppColors.negativePrimary; // High priority color
      case '50':
        return AppColors.warning500; // Medium priority color
      case '0':
        return AppColors.positive500; // Low priority color
      default:
        return Colors.grey; // Default color for unknown status
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusText = useMemoized(() {
      switch (status.toLowerCase()) {
        case '100':
          return 'High';
        case '50':
          return 'Medium';
        default:
          return 'Low';
      }
    }, [status]); // Memoized computation of statusText based on status.

    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4), // Add padding for the pill shape
        decoration: BoxDecoration(
          color: _getBackgroundColor(status), // Background color of the pill
          borderRadius: BorderRadius.circular(256), // Rounded corners
        ),
        child: Text(
          statusText,
          style: AppTextTheme.CaptionMdLight,
        ),
      ),
    );
  }
}
