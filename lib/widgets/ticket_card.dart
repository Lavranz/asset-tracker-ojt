import 'package:apollo_tracker_mobile/commons/models/ticket.model.dart';
import 'package:apollo_tracker_mobile/commons/utils/helper.util.dart';
import 'package:apollo_tracker_mobile/theme/colors.dart';
import 'package:apollo_tracker_mobile/theme/texts.dart';
import 'package:apollo_tracker_mobile/widgets/ticket_status.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class TicketCard extends StatelessWidget {
  final TicketItem ticket;

  const TicketCard({
    super.key, 
    required this.ticket
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => GoRouter.of(context).push('/ticket/${ticket.ticketId}'),
      child: Card(
        elevation: 2.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: AppColors.strokePrimary,
                      width: 1,
                    ),
                  )
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: Text(
                              ticket.ticketId,
                              style: AppTextTheme.H6MediumPrimary,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          // TicketStatus(status: ticket.priority)
                        ],
                      ),
                    ),
                    Flexible(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Flexible(
                            child: Text(
                              ticket.status,
                              style: AppTextTheme.LabelSmMediumPrimary, 
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              "|"
                            ), 
                          ),
                          Flexible(
                            child: Text(
                              formatDate(ticket.due, format: "MMMM d, H:m"),
                              style: AppTextTheme.LabelSmSecondary, 
                              overflow: TextOverflow.ellipsis,
                            ),
                          ), 
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  ticket.subject == '' ? '(No Subject)' : ticket.subject,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextTheme.LabelMdPrimary,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      ticket.queue,
                      style: AppTextTheme.LabelSmSecondary,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  ticket.services.isNotEmpty 
                    ? Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.strokePrimary,
                          borderRadius: BorderRadius.circular(256),
                        ),
                        child: Text(
                          ticket.services,
                          style: AppTextTheme.LabelSmMediumPrimary,
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    : const SizedBox.shrink()
                ]
              )
            ],
          ),
        ),
      ),
    );
  }
}