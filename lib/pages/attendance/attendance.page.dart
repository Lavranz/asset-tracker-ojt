import 'dart:async';
import 'package:another_flushbar/flushbar.dart';
import 'package:apollo_tracker_mobile/commons/forms/users.form.dart';
import 'package:apollo_tracker_mobile/commons/models/attendance.model.dart';
import 'package:apollo_tracker_mobile/commons/services/attendance.service.dart';
import 'package:apollo_tracker_mobile/commons/services/toast.service.dart';
import 'package:apollo_tracker_mobile/commons/utils/helper.util.dart';
import 'package:apollo_tracker_mobile/pages/attendance/_modals.dart';
import 'package:apollo_tracker_mobile/theme/app_bar.dart';
import 'package:apollo_tracker_mobile/theme/custom_progress.dart';
import 'package:dio/dio.dart';
import 'package:fl_query_hooks/fl_query_hooks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:apollo_tracker_mobile/theme/colors.dart';
import 'package:apollo_tracker_mobile/theme/texts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

final form = AttendanceForm();

class AttendancePage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final dateTime =
        useState(DateFormat('MMMM d, yyyy').format(DateTime.now()));
    final timeState = useState(DateFormat('h:mm a').format(DateTime.now()));
    final isTimedIn = useState(false);
    final startTime = useState<DateTime?>(null);
    final currentDuration = useState(Duration.zero);
    final checkInTime = useState<String?>(null);
    final queryClient = useQueryClient();

    final attendanceCheckQuery = useQuery(
      'attendance-check',
      () => attendance$.check(),
      onData: (value) {
        checkInTime.value = null;
        if (value.data.timeIn) {
          checkInTime.value = value.data.time;
          DateFormat inputFormat = DateFormat("MMM. dd, yyyy h:mm a");
          startTime.value = inputFormat.parse(value.data.time!);
          currentDuration.value = DateTime.now().difference(startTime.value!);
        }
        isTimedIn.value = value.data.timeIn;
      },
      onError: (DioException err) {},
    );

    final apiAttendanceWeekLogs = useQuery(
      'attendance-week-logs',
      () => attendance$.getWeekLogs(),
      onData: (value) {},
      onError: (DioException err) {},
    );

    final attendanceCheckIn = useMutation(
      'agent-check-in',
      (data) => attendance$.checkIn(data),
      onData: (value, revData) {
        if (!isTimedIn.value) {
          isTimedIn.value = true;
          startTime.value = DateTime.now();
        }
        queryClient.refreshQuery('attendance-check');
        if (value != null) {
          toastSuccess(context, "Time In successfully!");
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Time-in failed!')),
          );
        }
      },
      onError: (DioException err, obj) {
        if (err.response?.data != null) {
          final Map<String, dynamic> errors = err.response!.data;
          final msg = errors['status']['message'] ?? '';
          if (msg.isNotEmpty) {
            if (msg.contains('Can only log in once')) {
              showUnavailableModal(context);
              return;
            }
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(msg)),
            );
          }
        }
      },
    );

    final attendanceCheckOut = useMutation(
      'agent-check-out',
      (data) => attendance$.checkOut(data),
      onData: (data, revData) {
        final hoursWorked = data.hoursWorked;
        queryClient
            .refreshQueries(['attendance-check', 'attendance-week-logs']);
        startTime.value = null;
        currentDuration.value = Duration.zero;
        toastSuccess(context, "You have timed out successfully!");
      },
      onError: (DioException err, obj) {
        if (err.response?.data != null) {
          final Map<String, dynamic> errors = err.response!.data;
          final msg = errors['status']['message'] ?? '';
          if (msg.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(msg)),
            );
          }
        }
      },
    );

    Future<void> initForm() async {
      final hasPermission = await handleLocationPermission();
      if (hasPermission) {
        final position = await Geolocator.getCurrentPosition(
            locationSettings:
                const LocationSettings(accuracy: LocationAccuracy.high));
        form.form.control('latitude').value = position.latitude.toString();
        form.form.control('longitude').value = position.longitude.toString();
        form.form.control('accuracy').value = position.accuracy.toString();
      }
      final hardwareId = await getDeviceId();
      form.form.control('hardwareId').value = hardwareId;
    }

    useEffect(() {
      final timer = Stream.periodic(const Duration(seconds: 60)).listen((_) {
        dateTime.value =
            DateFormat('MMMM d, yyyy h:mm a').format(DateTime.now());
      });

      queryClient.refreshQuery('attendance-check');
      initForm();

      return timer.cancel;
    }, []);

    Future<void> _onRefresh() async {
      await queryClient.refreshQueries(["attendance-week-logs"]);
    }

    void handleTimeIn() async {
      await initForm();
      if (form.form.valid) {
        final data = form.form.value;
        await attendanceCheckIn.mutate(data);
      }
    }

    void handleTimeOut() {
      showTimeOutModal(context, currentDuration.value, () async {
        form.form.reset();
        await initForm();
        attendanceCheckOut.mutate(form.form.value);
      });
    }

    String formatDuration(Duration duration) {
      final hours = duration.inHours.toString().padLeft(2, '0');
      final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
      return "$hours:$minutes hrs";
    }

    if (attendanceCheckQuery.isFetching) {
      return SpinningGradientCircle();
    }
    if (attendanceCheckQuery.hasError) {
      return const Scaffold(body: Text('Error loading attendance data'));
    }

    return Scaffold(
      appBar: customAppBar("Attendance"),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                Row(
                  children: [
                    Icon(PhosphorIcons.calendarBlank(),
                        size: 20, color: Colors.grey),
                    const SizedBox(width: 8),
                    Text(
                      dateTime.value,
                      style: AppTextTheme.LabelSmSecondary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      timeState.value,
                      style: AppTextTheme.LabelSmSecondary,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  isTimedIn.value ? "You have timed in" : "Let's get to work!",
                  style: AppTextTheme.H3MediumPrimary,
                ),
                const SizedBox(height: 8),
                Text(
                  formatDuration(currentDuration.value),
                  style: AppTextTheme.LabelMdPrimary.copyWith(
                      fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 32),
                if (!isTimedIn.value)
                  ElevatedButton(
                    onPressed:
                        attendanceCheckIn.isMutating ? null : handleTimeIn,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary500,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: attendanceCheckIn.isMutating
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : const Text(
                            "Time In",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                  ),
                if (isTimedIn.value)
                  ElevatedButton(
                    onPressed: handleTimeOut,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary500,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: attendanceCheckOut.isMutating
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : const Text(
                            "Time Out",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                  ),
                const SizedBox(height: 32),
                Text(
                  "This week's logs",
                  style: AppTextTheme.LabelSmTertiary.copyWith(
                      fontWeight: FontWeight.w500, fontSize: 16.0),
                ),
                const SizedBox(height: 16),
                if (apiAttendanceWeekLogs.isFetching)
                  const Center(child: CircularProgressIndicator())
                else if (apiAttendanceWeekLogs.data == null ||
                    apiAttendanceWeekLogs.data!.isEmpty)
                  Center(
                    child: Text(
                      "No logs found",
                      style: AppTextTheme.BodyMdPrimary,
                    ),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: apiAttendanceWeekLogs.data!.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          _buildAttendanceLog(
                              apiAttendanceWeekLogs.data![index]),
                          if (index != apiAttendanceWeekLogs.data!.length - 1)
                            const Divider(
                              color: AppColors.strokePrimary,
                              thickness: 1.0,
                              height:
                                  32.0, // Space between the log and the divider
                            ),
                        ],
                      );
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAttendanceLog(AttendanceWeekLog log) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                formatDate(log.timeIn,
                    format: 'MMM. dd, yyyy',
                    inputFormat: 'MMM. dd, yyyy h:mm a'),
                style: AppTextTheme.LabelSmNeutral,
              ),
              Text(
                '${log.duration} total hrs',
                style: AppTextTheme.BodyMdPrimary.copyWith(
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'In & Out',
                style: AppTextTheme.LabelSmNeutral,
              ),
              Text(
                formatDate(log.timeIn,
                        format: 'h:mm a', inputFormat: 'MMM. dd, yyyy h:mm a') +
                    ' - ' +
                    formatDate(log.timeOut,
                        format: 'h:mm a', inputFormat: 'MMM. dd, yyyy h:mm a'),
                style: AppTextTheme.BodyMdPrimary.copyWith(
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
