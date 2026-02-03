import 'package:apollo_tracker_mobile/commons/services/fsr.service.dart';
import 'package:apollo_tracker_mobile/theme/app_bar.dart';
import 'package:dio/dio.dart';
import 'package:fl_query_hooks/fl_query_hooks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:apollo_tracker_mobile/theme/colors.dart';
import 'package:apollo_tracker_mobile/theme/texts.dart';

class FieldServiceReportPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final fsrQuery = useQuery(
      'user-fsr-list',
      () => fsr$.getFSRList(),
      onData: (value) {
        // Check if the user has already checked in
      },
      onError: (DioException err) {},
    );
    final queryClient = useQueryClient();

    // Function to refresh the query when pull-to-refresh is triggered
    Future<void> _onRefresh() async {
      // Trigger the refresh of the ticket_list query
      await queryClient.refreshQueries(["user-fsr-list"]);
    }


    return Scaffold(
      appBar: customAppBar("Field Service Reports"),
      bottomSheet: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        color: Colors.white,
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              // Handle Create FSR logic here
              GoRouter.of(context).push('/create-fsr');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary500,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              "Create report",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          if (fsrQuery.isFetching)
            const Column(children: [
              SizedBox(height: 16),
              Center(child: CircularProgressIndicator())
            ]),
          if (fsrQuery.hasData && fsrQuery.data!.isEmpty)
            const Expanded(child: Center(child: Text('No Field Service Reports found'))),

          if (fsrQuery.hasError)
            const Expanded(child: Center(child: Text('An error occurred while fetching data'))),

          if (fsrQuery.hasData)
            Expanded(
              child: RefreshIndicator(
                onRefresh: _onRefresh,
                child: ListView.builder(
                  itemCount: fsrQuery.data!.length,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemBuilder: (context, index) {
                    final fsr = fsrQuery.data![index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Ticket no. ${fsr.ticketId ?? 'N/A'}",
                          style: AppTextTheme.LabelSmNeutral,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          fsr.customer ?? 'N/A',
                          style: AppTextTheme.BodySmPrimary.copyWith(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (index < fsrQuery.data!.length - 1)
                          const Divider(
                            height: 24,
                            color: AppColors.strokePrimary,
                          ),
                      ],
                    );
                  },
                ),
              ),
            ),
     
        ],
      ),
    );
  }
}
