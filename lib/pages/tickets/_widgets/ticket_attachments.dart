import 'package:apollo_tracker_mobile/commons/models/ticket.model.dart';
import 'package:apollo_tracker_mobile/commons/services/ticket.service.dart';
import 'package:apollo_tracker_mobile/theme/colors.dart';
import 'package:apollo_tracker_mobile/theme/texts.dart';
import 'package:apollo_tracker_mobile/widgets/_modals/image_viewer.dart';
import 'package:apollo_tracker_mobile/widgets/image_card.dart';
import 'package:apollo_tracker_mobile/widgets/ticket_status.dart';
import 'package:fl_query_hooks/fl_query_hooks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

class TicketAttachmentsWidget extends HookWidget {
  final TicketItem ticket;

  const TicketAttachmentsWidget({
    super.key, 
    required this.ticket
  });

  @override
  Widget build(BuildContext context) {
    final attachmentsQuery = useQuery("ticket-attachments-${ticket.id}",
        () => ticket$.attachments(ticket.numericalId));

    if (!attachmentsQuery.isLoading && (attachmentsQuery.data == null || attachmentsQuery.data?.isEmpty == true)) {
      return const Center(
        child: Text('No attachments found'),
      );
    }

    if (attachmentsQuery.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return GridView(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 8,
      ),
      children: [
        for (final attachment in attachmentsQuery.data ?? [])
          InkWell(
            onTap: () {
              showImageViewerDialog(context, [attachment.downloadUrl], 0);
            },
            child: ImageCardWidget(
              imageUrl: attachment.downloadUrl,
              title: attachment.name,
              subtitle: attachment.fileSize,
            ),
          )
          
      ],
    );
  }
}
