import 'package:apollo_tracker_mobile/commons/models/ticket.model.dart';
import 'package:apollo_tracker_mobile/commons/services/ticket.service.dart';
import 'package:apollo_tracker_mobile/theme/colors.dart';
import 'package:apollo_tracker_mobile/theme/texts.dart';
import 'package:apollo_tracker_mobile/widgets/_modals/image_viewer.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:fl_query_hooks/fl_query_hooks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_html/flutter_html.dart'; // For rendering HTML
import 'package:intl/intl.dart'; // For date formatting

class TicketHistoryWidget extends HookWidget {
  final TicketItem ticket;

  const TicketHistoryWidget({
    super.key,
    required this.ticket,
  });

  @override
  Widget build(BuildContext context) {    
    final queryClient = useQueryClient();
    final historyQuery = useQuery("ticket_history-${ticket.ticketId}",
        () => ticket$.histories(ticket.numericalId));

    // Group ticket history by month
    List<TicketHistory> ticketHistoryList = historyQuery.data ?? [];
    Map<String, List<TicketHistory>> groupedByMonth = {};

    // Group history by formatted month
    for (var ticketHistory in ticketHistoryList) {
      final createdDate = DateTime.parse(ticketHistory.created);
      final formattedMonth = DateFormat('MMMM yyyy').format(createdDate);

      if (!groupedByMonth.containsKey(formattedMonth)) {
        groupedByMonth[formattedMonth] = [];
      }
      groupedByMonth[formattedMonth]?.add(ticketHistory);
    }

    if (historyQuery.isLoading) {
      return const Padding(
        padding: EdgeInsets.only(top: 40 - 16),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    // Function to refresh the query when pull-to-refresh is triggered
    Future<void> _onRefresh() async {
      // Trigger the refresh of the ticket_list query
      queryClient.refreshQueries(["ticket_history-${ticket.ticketId}"]);
    }
  

    return RefreshIndicator(
        onRefresh: _onRefresh,
        child: Padding(
        padding: const EdgeInsets.only(top: 40 - 16),
        child: ListView(
          children: groupedByMonth.keys.map((month) {
            return IgnorePointer(
              ignoring: true,
              child: ExpansionTile(
                iconColor: AppColors.surfaceInvertSecondary,
                shape: const Border(),
                initiallyExpanded: true,
                title: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 4.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                            color: AppColors.strokePrimary, width: 1.0),
                        borderRadius: BorderRadius.circular(299),
                      ),
                      child: Text(
                        month, // Display month as title
                        style: AppTextTheme.LabelSmTertiary.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Container(
                        height: 1, // Line thickness
                        color: AppColors.strokePrimary, // Line color
                      ),
                    ),
                  ],
                ),
                children: [
                  ...groupedByMonth[month]!.map((ticketHistory) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Column(
                                children: [
                                  Icon(Icons.circle,
                                      size: 8,
                                      color: AppColors.surfaceInvertSecondary),
                                  SizedBox(height: 8),
                                  // Container(
                                  //   height: 200,
                                  //   child: const DottedLine(
                                  //     direction: Axis.vertical,
                                  //     dashColor: AppColors.surfaceInvertSecondary,
                                  //   ),
                                  // ),
                                ],
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Description
                                    Text(
                                      ticketHistory.description,
                                      style: AppTextTheme.BodyMdPrimary,
                                      softWrap:
                                          true, // Allow text to wrap within the container
                                    ),
                                    const SizedBox(
                                        height:
                                            8), // Add spacing between sections

                                    // Attachments
                                    if (ticketHistory.attachments.isNotEmpty) ...[
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: ticketHistory.attachments
                                            .map((attachment) {
                                          if (attachment.isFile) {
                                            // Render as image
                                            return Container(
                                                decoration: BoxDecoration(
                                                    color:
                                                        AppColors.strokePrimary,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12.0)),
                                                child: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 8.0,
                                                        horizontal: 8.0),
                                                    child: InkWell(
                                                      onTap:  () {
                                                        showImageViewerDialog(
                                                            context,
                                                            [attachment.downloadUrl],
                                                            0);
                                                      },
                                                      child: Image.network(
                                                        attachment.downloadUrl,
                                                        fit: BoxFit.cover,
                                                        errorBuilder: (context,
                                                            error, stackTrace) {
                                                          return const Text(
                                                            "File not available",
                                                            style: TextStyle(
                                                                color:
                                                                    Colors.red),
                                                          );
                                                        },
                                                      ),
                                                    )));
                                          } else {
                                            // Render as HTML
                                            return Container(
                                                decoration: BoxDecoration(
                                                    color:
                                                        AppColors.strokePrimary,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12.0)),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                          vertical: 8.0),
                                                  child: Html(
                                                    data: attachment.content,
                                                    style: {
                                                      "body": Style(
                                                        fontSize: FontSize.medium,
                                                        color: AppColors
                                                            .surfaceInvertPrimary,
                                                      ),
                                                    },
                                                  ),
                                                ));
                                          }
                                        }).toList(),
                                      ),
                                    ],

                                    // Date and Time
                                    const SizedBox(
                                        height:
                                            12), // Add spacing before date and time
                                    Row(
                                      children: [
                                        Text(
                                          DateFormat('MMM dd').format(
                                              DateTime.parse(
                                                  ticketHistory.created)),
                                          style: AppTextTheme.CaptionMd,
                                        ),
                                        const SizedBox(width: 8),
                                        const Icon(Icons.circle,
                                            size: 4,
                                            color:
                                                AppColors.surfaceInvertSecondary),
                                        const SizedBox(width: 8),
                                        Text(
                                          DateFormat('hh:mm a').format(
                                              DateTime.parse(ticketHistory.created).add(const Duration(hours: 8))),
                                          style: AppTextTheme.CaptionMd,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }),
                  const SizedBox(height: 80),
                ]),
            );
          }).toList(),
        ),
      ),
    );
  }
}
