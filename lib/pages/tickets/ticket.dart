import 'package:apollo_tracker_mobile/commons/models/ticket.model.dart';
import 'package:apollo_tracker_mobile/commons/services/ticket.service.dart';
import 'package:apollo_tracker_mobile/commons/services/agent-location.service.dart';
import 'package:apollo_tracker_mobile/commons/services/toast.service.dart';
import 'package:apollo_tracker_mobile/commons/utils/image.util.dart';
import 'package:apollo_tracker_mobile/pages/tickets/_widgets/ticket_attachments.dart';
import 'package:apollo_tracker_mobile/pages/tickets/_widgets/ticket_dates.dart';
import 'package:apollo_tracker_mobile/pages/tickets/_widgets/ticket_history.dart';
import 'package:apollo_tracker_mobile/pages/tickets/_widgets/ticket_people.dart';
import 'package:apollo_tracker_mobile/theme/app_bar.dart';
import 'package:apollo_tracker_mobile/theme/colors.dart';
import 'package:apollo_tracker_mobile/theme/texts.dart';
import 'package:apollo_tracker_mobile/widgets/custom_image_view.dart';
import 'package:apollo_tracker_mobile/widgets/ticket_status.dart';
import 'package:fl_query_hooks/fl_query_hooks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '_widgets/_modals.dart';

class TicketPage extends HookWidget {
  final dynamic id;

  const TicketPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final isTimedIn = useState(false);

    String formatDuration(Duration duration) {
      final hours = duration.inHours.toString().padLeft(2, '0');
      final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
      return "$hours:$minutes hrs";
    }

    String getDuration(String? timeIn, String? timeOut) {
      DateTime _timeIn = DateTime.parse(timeIn ?? '');
      DateTime _timeOut = DateTime.parse(timeOut ?? '');

      return formatDuration(_timeOut.difference(_timeIn));
    }


    final ticketQuery = useQuery(
      "ticket_detail-$id",
      () => ticket$.detail(id),
      onData: (data) {
      },
    );

    final logQ = useMutation(
      'create-ticket-log-$id',
      (data) => ticket$.createLog(id, data),
      onData: (data, revData) {
        ticketQuery.refresh();

        if (data != null) {
          if (data['type'] == 'time_in') {
            toastSuccess(context, "Log time started");
            isTimedIn.value = true;
          } else {
            toastSuccess(context, "Log time finished");
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Log time failed!')),
          );
        }
      },
    );    

    if (ticketQuery.isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final ticket = ticketQuery.data;

    void submitLog(String type) async {
      Duration duration = Duration.zero;

      if (type == 'time_out') {
        DateTime timeIn = DateTime.parse(ticket?.timeIn! ?? '');
        duration = DateTime.now().difference(timeIn);
      }
      
      showTimeOutModal(context, duration, type=type, () async {
        Position? position = await agentLocation$.getCurrentLocation();
        logQ.mutate({
          'type': type,
          'latitude': position?.latitude,
          'longitude': position?.longitude,
        });
      });
    }

    if (ticket == null) {
      return Scaffold(
        body: Center(
          child: Text(
            'Error loading ticket details',
            style: AppTextTheme.H6MediumPrimary,
          ),
        ),
      );
    }

    Future<Position> _getCurrentLocation() async {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // Location services are not enabled, show an error or prompt the user to enable them
        throw 'Location services are disabled.';
      }

      // Request location permission
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Handle the case where permission is denied
        throw 'Location permission denied.';
      }

      // Get the current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      return position;
    }

    return Scaffold(
      backgroundColor: AppColors.light,
      resizeToAvoidBottomInset: false,
      appBar: customAppBar('Details'),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: Text(
                                '#${ticket.ticketId}',
                                style: AppTextTheme.H6MediumPrimary,
                              ),
                            ),
                            TicketStatus(status: ticket.priority)
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 12, bottom: 16),
                    child: Text(
                      ticket.subject == '' ? '(No Subject)' : ticket.subject,
                      overflow: TextOverflow.fade,
                      style: AppTextTheme.H6MediumPrimary,
                    ),
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          ticket.services,
                          style: AppTextTheme.LabelSmTertiary,
                        ),
                        Center(
                            child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.strokePrimary,
                            borderRadius: BorderRadius.circular(256),
                          ),
                          child: Text(
                            ticket.status,
                            style: AppTextTheme.LabelSmMediumPrimary,
                          ),
                        ))
                      ]),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        'SLA: ${ticket.sla}',
                        style: AppTextTheme.LabelSmSecondary,
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          "|",
                          style:
                              TextStyle(color: AppColors.surfaceInvertTertiary),
                        ),
                      ),
                      Text(
                        ticket.queue,
                        style: AppTextTheme.LabelSmMediumPrimary,
                      ),
                    ],
                  ),
                  if (ticket.region.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Region',
                          style: AppTextTheme.LabelSmSecondary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          ticket.region,
                          style: AppTextTheme.LabelSmMediumPrimary,
                        ),
                      ],
                    )
                  ],
                  // Check if coordinates is not empty and contains long ang lat
                  if (ticket.coordinates.isNotEmpty && ticket.coordinates.split(',').length == 2) ...[
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Coordinates',
                          style: AppTextTheme.LabelSmSecondary,
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: () async {
                            String coordinates =
                                ticket.coordinates; // Get your coordinates
                            print(coordinates);
                            // Split the coordinates to extract latitude and longitude
                            List<String> coordinateParts =
                                coordinates.split(',');

                            String destinationLatitude = coordinateParts[0];
                            String destinationLongitude = coordinateParts[1];

                            // Get the current location (latitude and longitude)
                            Position currentPosition =
                                await _getCurrentLocation();

                            // Construct the Google Maps URL for directions (origin -> destination)
                            String googleMapsUrl =
                                'https://www.google.com/maps/dir/?api=1&origin=${currentPosition.latitude},${currentPosition.longitude}&destination=$destinationLatitude,$destinationLongitude';
                            final Uri _url = Uri.parse(googleMapsUrl);
                            
                            print(googleMapsUrl);
                            // Add action for opening Google Maps
                            // if (await canLaunchUrl(_url)) {
                            await launchUrl(_url);
                            // } else {
                            //   // Handle error if the URL can't be launched
                            //   print('Could not open Google Maps');
                            // }
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                vertical: 4, horizontal: 12),
                            elevation: 0
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                PhosphorIconsBold.mapPinLine,
                                size: 20,
                                color: AppColors.surfaceInvertPrimary
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "Open google map",
                                style: AppTextTheme.LabelMdMediumPrimary,
                              ),
                            ],
                          )
                        ),
                      ],
                    )
                  ],
                  const SizedBox(height: 16),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Log time',
                        style: AppTextTheme.LabelSmSecondary,
                      ),
                      const SizedBox(width: 8),
                      if (ticket.timeIn == null) ...[
                        ElevatedButton(
                          onPressed: logQ.isMutating ? null : () => submitLog('time_in'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary500,
                            minimumSize: const Size(177, 48),
                            // minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          child: logQ.isMutating
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Text(
                                  "Start",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                        )
                      ],
                      if (ticket.timeIn != null && ticket.timeOut == null) ...[
                        ElevatedButton(
                          onPressed: logQ.isMutating ? null : () => submitLog('time_out'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary500,
                            minimumSize: const Size(177, 48),
                            // minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          child: logQ.isMutating
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Text(
                                  "Finish",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                        )
                      ],
                      if (ticket.timeIn != null && ticket.timeOut != null) ...[
                        Text(
                          getDuration(ticket.timeIn, ticket.timeOut),
                          style: AppTextTheme.LabelSmMediumPrimary,
                        ),
                      ]
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height *
                  0.60, // Adjust height as needed
              child: DefaultTabController(
                
                length: 4,
                child: Column(children: [
                  TabBar(
                    isScrollable: true,
                    tabAlignment: TabAlignment.start,
                    
                    tabs: const [
                      Tab(text: 'History'),
                      Tab(text: 'Dates'),
                      Tab(text: 'People'),
                      Tab(text: 'Attachments'),
                    ],
                    labelStyle: AppTextTheme.LabelSmMediumPrimary.copyWith(
                        color: AppColors.surfaceInvertSecondary),
                    dividerColor: AppColors.strokePrimary,
                    indicatorSize: TabBarIndicatorSize.tab,
                  ),
                  Flexible(
                      child: Container(
                    decoration: const BoxDecoration(),
                    child: TabBarView(
                      children: [
                        TicketHistoryWidget(ticket: ticket),
                        TicketDatesWidget(ticket: ticket),
                        TicketPeopleWidget(ticket: ticket),
                        TicketAttachmentsWidget(ticket: ticket)
                      ],
                    ),
                  )),
                ]),
              ),
            )
          ],
        ),
      ),
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: ExpandableFab(
        openButtonBuilder: RotateFloatingActionButtonBuilder(
          child: const Icon(Icons.add),
          fabSize: ExpandableFabSize.regular,
          backgroundColor: AppColors.primary500,
          shape: const CircleBorder(),
        ),
        closeButtonBuilder: FloatingActionButtonBuilder(
          size: 56,
          builder: (BuildContext context, void Function()? onPressed,
              Animation<double> progress) {
            return IconButton(
              onPressed: onPressed,
              color: AppColors.surfaceInvertPrimary,
              style: const ButtonStyle(
                backgroundColor: WidgetStatePropertyAll<Color>(
                    AppColors.light),
              ),
              icon: const Icon(
                Icons.close,
                size: 35,
              ),
            );
          },
        ),
        distance: 120,
        overlayStyle: ExpandableFabOverlayStyle(
          color: Colors.grey.withOpacity(0.9),
        ),
        children: [
          IconButton(
            onPressed: () {
              // Navigate to the ticket comment page
              context.push('/ticket/$id/comment');
            },
            style: const ButtonStyle(
                backgroundColor: WidgetStatePropertyAll<Color>(
                    AppColors.light),
            ),
            icon: const Icon(
              PhosphorIconsBold.chatTeardropDots,
              size: 40,
              color: AppColors.warning500,
            ),
          ),
          IconButton(
            onPressed: () {
              // Navigate to the ticket comment page
              context.push('/ticket-response/$id');
            },
            style: const ButtonStyle(
                backgroundColor: WidgetStatePropertyAll<Color>(
                    AppColors.light),
            ),
            icon: const Icon(
              PhosphorIconsBold.clipboardText,
              size: 40,
              color: AppColors.negative600,
            ),
          ),
          IconButton(
            onPressed: ticket.hasReport ? null : () {
              // Navigate to the ticket comment page
              context.push('/create-fsr?id=$id');
            },
            style: const ButtonStyle(
              backgroundColor: WidgetStatePropertyAll<Color>(
                AppColors.light,
              ),
            ),
            icon: CustomImageView(
              imagePath: ticket.hasReport ? IconConstant.fsrDisabled : IconConstant.fsr,
              width: 40,
              height: 40,
            ),
          )
          // FloatingActionButton.small(
          //   heroTag: null,
          //   child: const Icon(Icons.edit),
          //   onPressed: () {},
          // ),
          // FloatingActionButton.small(
          //   heroTag: null,
          //   child: const Icon(Icons.search),
          //   onPressed: () {},
          // ),
        ],
      ),
      // floatingActionButton: Row(
      //   mainAxisAlignment: MainAxisAlignment.end,
      //   children: [
      //     FloatingActionButton(
      //       heroTag: 'commentButton',
      //       onPressed: () {
      //         // Navigate to the ticket comment page
      //         context.push('/ticket/$id/comment');
      //       },
      //       backgroundColor: AppColors.neutral300,
      //       child: const Icon(PhosphorIconsRegular.chatTeardropDots),
      //     ),
      //     const SizedBox(width: 16),
      //     // FloatingActionButton(
      //     //   heroTag: 'fsrButton',
      //     //   onPressed: () {
      //     //     // Navigate to the ticket FSR page
      //     //     context.push('/ticket-fsr/$id');
      //     //   },
      //     //   backgroundColor: AppColors.neutral300,
      //     //   child: const Icon(Icons.assignment),
      //     // ),
      //     FloatingActionButton(
      //       heroTag: 'ticketResponse',
      //       onPressed: () {
      //         // Navigate to the ticket FSR page
      //         context.push('/ticket-response/$id');
      //       },
      //       backgroundColor: AppColors.primary500,
      //       child: const Icon(Icons.assignment),
      //     ),
      //   ],
      // ),
    );
  }
}
