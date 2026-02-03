import 'package:apollo_tracker_mobile/commons/models/ticket.model.dart';
import 'package:apollo_tracker_mobile/commons/services/attendance.service.dart';
import 'package:apollo_tracker_mobile/commons/services/auth.service.dart';
import 'package:apollo_tracker_mobile/commons/services/ticket.service.dart';
import 'package:apollo_tracker_mobile/theme/colors.dart';
import 'package:apollo_tracker_mobile/theme/texts.dart';
import 'package:apollo_tracker_mobile/widgets/ticket_card.dart';
import 'package:dio/dio.dart';
import 'package:fl_query_hooks/fl_query_hooks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class DashboardPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final active = useState<int>(2);
    final queryClient = useQueryClient();
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
                      'You have not timed out yet. Please proceed to the attendance page.'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        // Navigate to the attendance page
                        context.pop();
                        context.push('/attendance');
                      },
                      child: const Text('Time out'),
                    ),
                    // TextButton(
                    //   onPressed: () {
                    //     // Close the dialog
                    //     context.pop();
                    //   },
                    //   child: const Text('Cancel'),
                    // ),
                  ],
                );
              },
            );
          }
        }
      },
    );

    final userQuery = useQuery('auth-user', () => auth$.getUser());
    final ticketListQuery = useQuery(
      "ticket_list",
      () => ticket$.list(),
      onData: (data) {},
      onError: (e) {},
    );
    final statQuery = useQuery(
      "ticket_stat",
      () => ticket$.stats(),
      onData: (data) {},
    );

    void onButtonClick(int index) {
      active.value = index;
    }

    // Function to refresh the query when pull-to-refresh is triggered
    Future<void> _onRefresh() async {
      // Trigger the refresh of the ticket_list query
      queryClient.refreshQueries(["ticket_list"]);
    }

    // Get today's date and format it
    final String currentDate = DateFormat('MMM d, yyyy').format(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  onSubmitted: (String value) {
                    if (value.isNotEmpty) {
                      FocusScope.of(context).unfocus();
                      GoRouter.of(context)
                          .push('/tickets-search?query=$value');
                    }
                  },
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      PhosphorIcons.magnifyingGlass(),
                      color: AppColors.neutral300,
                      size: 18,
                    ), // Search icon as prefix
                    iconColor: AppColors.neutral300,
                    hintText: 'Quick search...',
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors.strokePrimary, // Border color
                        width: 1.0, // Border width
                      ),
                    ),
                    hintStyle: const TextStyle(
                      color: AppColors.neutral300,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Hi, ${auth$.currentUser?.firstName ?? 'Agent'}",
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
      body:  Container(
        color: AppColors.neutral50,
        child: Column(
          children: [
            Expanded(
              child: RefreshIndicator(
                onRefresh: _onRefresh,
                child: ticketListQuery.isLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : ticketListQuery.data == null ||
                            ticketListQuery.data!.isEmpty
                        ? Center(
                            child: Text(
                              "No tickets available",
                              style: AppTextTheme.BodyMdPrimary,
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: ticketListQuery.data?.length ?? 0,
                            itemBuilder: (context, index) {
                              final ticket = ticketListQuery.data![index];
                              return TicketCard(ticket: ticket);
                            },
                          ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
