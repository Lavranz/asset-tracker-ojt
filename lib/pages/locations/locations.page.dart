import 'package:apollo_tracker_mobile/commons/models/agent.model.dart';
import 'package:apollo_tracker_mobile/commons/services/agent-location.service.dart';
import 'package:apollo_tracker_mobile/theme/app_bar.dart';
import 'package:apollo_tracker_mobile/theme/base.dart';
import 'package:apollo_tracker_mobile/theme/colors.dart';
import 'package:apollo_tracker_mobile/theme/texts.dart';
import 'package:dio/dio.dart';
import 'package:fl_query_hooks/fl_query_hooks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';

class LocationsPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final agentLocationListQ = useQuery(
      'agent-location-list',
      () => agentLocation$.list(),
      onData: (value) {
        // Check if the user has already checked in
      },
      onError: (DioException err) {},
    );
    final queryClient = useQueryClient();

    // Function to refresh the query when pull-to-refresh is triggered
    Future<void> _onRefresh() async {
      // Trigger the refresh of the ticket_list query
      queryClient.refreshQueries(["agent-location-list"]);
    }

    return Scaffold(
        appBar: customAppBar("Locations"),
        body: RefreshIndicator(
          onRefresh: _onRefresh,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 0.0),
            child: Column(
              children: [
                if (agentLocationListQ.isLoading)
                  const Expanded(child: Center(child: CircularProgressIndicator()))
                else if (agentLocationListQ.hasError)
                  Center(
                    child: Text(
                      agentLocationListQ.error.toString(),
                    ),
                  )
                else
                  Expanded(
                    child: SingleChildScrollView(
                      child: agentLocationListQ.isFetching
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : agentLocationListQ.data == null ||
                                  agentLocationListQ.data!.isEmpty
                              ? Center(
                                  child: Text(
                                    "No locations found",
                                    style: AppTextTheme
                                        .BodyMdPrimary, // Use a suitable text style from your theme
                                  ),
                                )
                              : Column(
                                  children: agentLocationListQ.data!
                                      .map((location) => _buildAttendanceLog(
                                          location, context))
                                      .toList(),
                                ),
                    ),
                  ),
              ],
            ),
          ),
        ));
  }

  Widget _buildAttendanceLog(AgentLocation location, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Longitude",
                      style: AppTextTheme.CaptionMd.copyWith(
                          fontWeight: FontWeight.w400),
                    ),
                    Text(
                      "${location.longitude}",
                      style: AppTextTheme.BodyMdPrimary.copyWith(
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Latitude",
                      style: AppTextTheme.CaptionMd.copyWith(
                          fontWeight: FontWeight.w400),
                    ),
                    Text(
                      "${location.latitude}",
                      style: AppTextTheme.BodyMdPrimary.copyWith(
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${location.accuracy}",
                style: AppTextTheme.H6MediumPrimary,
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            "${DateFormat('MMM dd yyyy').format(location.date)} • ${TimeOfDay.fromDateTime(location.date).format(context)}",
            style: AppTextTheme.LabelSmNeutral,
          ),
          const SizedBox(height: 16),
          const Divider(height: 1, color: AppColors.strokePrimary)
        ],
      ),
    );
  }
}
