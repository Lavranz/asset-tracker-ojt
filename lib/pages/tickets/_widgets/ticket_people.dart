import 'package:apollo_tracker_mobile/commons/models/ticket.model.dart';
import 'package:apollo_tracker_mobile/commons/utils/image.util.dart';
import 'package:apollo_tracker_mobile/theme/colors.dart';
import 'package:apollo_tracker_mobile/theme/texts.dart';
import 'package:apollo_tracker_mobile/widgets/custom_image_view.dart';
import 'package:apollo_tracker_mobile/widgets/ticket_status.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TicketPeopleWidget extends StatelessWidget {
  final TicketItem ticket;

  const TicketPeopleWidget({
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
            children: [
              Expanded(
                child: Container(
                  child: Text(
                    'Owner:',
                    style: AppTextTheme.LabelSmTertiary.copyWith(
                      fontWeight: FontWeight.w500
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  child: Text(
                    ticket.owner,
                    style: AppTextTheme.LabelSmTertiary.copyWith(
                      color: AppColors.surfaceInvertPrimary
                    ),
                  ),
                )
              ),
            ],
          ),
          const SizedBox(height: 12.0),
          Row(
            children: [
              Expanded(
                child: Container(
                  child: Text(
                    'Requestors:',
                    style: AppTextTheme.LabelSmTertiary.copyWith(
                      fontWeight: FontWeight.w500
                    ),
                  ),
                ),
              ),

              Expanded(
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (var cc in ticket.requestors) 
                        Text(
                          cc,
                          style: AppTextTheme.LabelSmTertiary.copyWith(
                            color: AppColors.surfaceInvertPrimary
                          ),
                        )
                    ],
                  ),
                )
              ),
            ],
          ),
          const SizedBox(height: 12.0),
          Row(
            children: [
              Expanded(
                child: Container(
                  child: Text(
                    'Cc:',
                    style: AppTextTheme.LabelSmTertiary.copyWith(
                      fontWeight: FontWeight.w500
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (var cc in ticket.cc) 
                        Text(
                          cc,
                          style: AppTextTheme.LabelSmTertiary.copyWith(
                            color: AppColors.surfaceInvertPrimary
                          ),
                        )
                    ],
                  ),
                )
              ),
            ],
          ),
          const SizedBox(height: 12.0),
          Row(
            children: [
              Expanded(
                child: Container(
                  child: Text(
                    'AdminCc:',
                    style: AppTextTheme.LabelSmTertiary.copyWith(
                      fontWeight: FontWeight.w500
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  child: Column(
                    children: [
                      for (var adminCc in ticket.adminCc)
                        Text(
                          adminCc,
                          style: AppTextTheme.LabelSmTertiary.copyWith(
                            color: AppColors.surfaceInvertPrimary
                          ),
                        ),
                    ],
                  ) 
                )
              ),
            ],
          ),
        ],
      ),
    );
  }
}
