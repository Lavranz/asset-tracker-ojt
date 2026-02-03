import 'package:apollo_tracker_mobile/commons/models/ticket.model.dart';
import 'package:apollo_tracker_mobile/commons/utils/helper.util.dart';
import 'package:apollo_tracker_mobile/theme/colors.dart';
import 'package:apollo_tracker_mobile/theme/texts.dart';
import 'package:apollo_tracker_mobile/widgets/ticket_status.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TicketDatesWidget extends StatelessWidget {
  final TicketItem ticket;

  const TicketDatesWidget({
    super.key, 
    required this.ticket
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Created:',
                style: AppTextTheme.LabelSmTertiary.copyWith(
                  fontWeight: FontWeight.w500
                ),
              ),
              Row(
                children: [
                  Text(
                    formatDate(ticket.created, format: 'MMM dd, yyyy'),
                    style: AppTextTheme.LabelSmTertiary.copyWith(
                      color: AppColors.surfaceInvertPrimary
                    ),
                  ),
                  const SizedBox(width: 8),

                  Text(
                    '|',
                    style: AppTextTheme.LabelSmTertiary.copyWith(
                      color: AppColors.strokePrimary
                    ),
                  ),
                  const SizedBox(width: 8),

                  Text(
                    formatDate(ticket.created, format: 'hh:mm a'),
                    style: AppTextTheme.LabelSmTertiary.copyWith(
                      color: AppColors.surfaceInvertPrimary
                    ),
                  )       
                ],
              ),
            ],
          ),
          const SizedBox(height: 12.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Starts:',
                style: AppTextTheme.LabelSmTertiary.copyWith(
                  fontWeight: FontWeight.w500
                ),
              ),
              Row(
                children: [
                  Text(
                    formatDate(ticket.starts, format: 'MMM dd, yyyy'),
                    style: AppTextTheme.LabelSmTertiary.copyWith(
                      color: AppColors.surfaceInvertPrimary
                    ),
                  ),
                  const SizedBox(width: 8),

                  Text(
                    '|',
                    style: AppTextTheme.LabelSmTertiary.copyWith(
                      color: AppColors.strokePrimary
                    ),
                  ),
                  const SizedBox(width: 8),

                  Text(
                    formatDate(ticket.starts, format: 'hh:mm a'),
                    style: AppTextTheme.LabelSmTertiary.copyWith(
                      color: AppColors.surfaceInvertPrimary
                    ),
                  )       
                ],
              ),
            ],
          ),
          const SizedBox(height: 12.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Started:',
                style: AppTextTheme.LabelSmTertiary.copyWith(
                  fontWeight: FontWeight.w500
                ),
              ),
              Row(
                children: [
                  Text(
                    formatDate(ticket.started, format: 'MMM dd, yyyy'),
                    style: AppTextTheme.LabelSmTertiary.copyWith(
                      color: AppColors.surfaceInvertPrimary
                    ),
                  ),
                  const SizedBox(width: 8),

                  Text(
                    '|',
                    style: AppTextTheme.LabelSmTertiary.copyWith(
                      color: AppColors.strokePrimary
                    ),
                  ),
                  const SizedBox(width: 8),

                  Text(
                    formatDate(ticket.started, format: 'hh:mm a'),
                    style: AppTextTheme.LabelSmTertiary.copyWith(
                      color: AppColors.surfaceInvertPrimary
                    ),
                  )       
                ],
              ),
            ],
          ),
          const SizedBox(height: 12.0),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Last contact:',
                style: AppTextTheme.LabelSmTertiary.copyWith(
                  fontWeight: FontWeight.w500
                ),
              ),
              Row(
                children: [
                  Text(
                    formatDate(ticket.told, format: 'MMM dd, yyyy'),
                    style: AppTextTheme.LabelSmTertiary.copyWith(
                      color: AppColors.surfaceInvertPrimary
                    ),
                  ),
                  const SizedBox(width: 8),

                  Text(
                    '|',
                    style: AppTextTheme.LabelSmTertiary.copyWith(
                      color: AppColors.strokePrimary
                    ),
                  ),
                  const SizedBox(width: 8),

                  Text(
                    formatDate(ticket.told, format: 'hh:mm a'),
                    style: AppTextTheme.LabelSmTertiary.copyWith(
                      color: AppColors.surfaceInvertPrimary
                    ),
                  )       
                ],
              ),
            ],
          ),
          const SizedBox(height: 12.0),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Due:',
                style: AppTextTheme.LabelSmTertiary.copyWith(
                  fontWeight: FontWeight.w500
                ),
              ),
              Row(
                children: [
                  Text(
                    formatDate(ticket.due, format: 'MMM dd, yyyy'),
                    style: AppTextTheme.LabelSmTertiary.copyWith(
                      color: AppColors.surfaceInvertPrimary
                    ),
                  ),
                  const SizedBox(width: 8),

                  Text(
                    '|',
                    style: AppTextTheme.LabelSmTertiary.copyWith(
                      color: AppColors.strokePrimary
                    ),
                  ),
                  const SizedBox(width: 8),

                  Text(
                    formatDate(ticket.due, format: 'hh:mm a'),
                    style: AppTextTheme.LabelSmTertiary.copyWith(
                      color: AppColors.surfaceInvertPrimary
                    ),
                  )       
                ],
              ),
            ],
          ),
          const SizedBox(height: 12.0),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Closed:',
                style: AppTextTheme.LabelSmTertiary.copyWith(
                  fontWeight: FontWeight.w500
                ),
              ),
              Row(
                children: [
                  Text(
                    formatDate(ticket.resolved, format: 'MMM dd, yyyy'),
                    style: AppTextTheme.LabelSmTertiary.copyWith(
                      color: AppColors.surfaceInvertPrimary
                    ),
                  ),
                  const SizedBox(width: 8),

                  Text(
                    '|',
                    style: AppTextTheme.LabelSmTertiary.copyWith(
                      color: AppColors.strokePrimary
                    ),
                  ),
                  const SizedBox(width: 8),

                  Text(
                    formatDate(ticket.resolved, format: 'hh:mm a'),
                    style: AppTextTheme.LabelSmTertiary.copyWith(
                      color: AppColors.surfaceInvertPrimary
                    ),
                  )       
                ],
              ),
            ],
          ),
          const SizedBox(height: 12.0),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Updated:',
                style: AppTextTheme.LabelSmTertiary.copyWith(
                  fontWeight: FontWeight.w500
                ),
              ),
              Row(
                children: [
                  Text(
                    formatDate(ticket.lastUpdated, format: 'MMM dd, yyyy'),
                    style: AppTextTheme.LabelSmTertiary.copyWith(
                      color: AppColors.surfaceInvertPrimary
                    ),
                  ),
                  const SizedBox(width: 8),

                  Text(
                    '|',
                    style: AppTextTheme.LabelSmTertiary.copyWith(
                      color: AppColors.strokePrimary
                    ),
                  ),
                  const SizedBox(width: 8),

                  Text(
                    formatDate(ticket.lastUpdated, format: 'hh:mm a'),
                    style: AppTextTheme.LabelSmTertiary.copyWith(
                      color: AppColors.surfaceInvertPrimary
                    ),
                  )       
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
