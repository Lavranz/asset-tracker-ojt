import 'package:apollo_tracker_mobile/commons/constants/api.constant.dart';
import 'package:apollo_tracker_mobile/commons/models/ticket.model.dart';
import 'package:apollo_tracker_mobile/commons/utils/http.util.dart';
import 'package:flutter/cupertino.dart';

class FSRService extends ChangeNotifier {
  // Acknowledgments
  static const ackOthers = 'others';
  static const ackFullyOperational = 'fully_operational';
  static const ackPulledOut = 'pulled_out';

  // Diagnostics/Findings
  static const redLos = 'red_los';
  static const highloss = 'highloss';
  static const serviceAffected = 'service_affected';
  static const modemIssue = 'modem_issue';
  static const intermittentConnection = 'intermittent_connection';
  static const others = 'others';

  // Actions Taken
  static const reFastconnector = 're_fastconnector';
  static const layoutFoc = 'layout_foc';
  static const reSpliced = 're_spliced';
  static const changedCore = 'changed_core';
  static const changedModem = 'changed_modem';
  static const othersAction = 'others';

  static const actionChoices = [
    (reFastconnector, 'Re-fastconnector'),
    (layoutFoc, 'Layout FOC'),
    (reSpliced, 'Re-spliced'),
    (changedCore, 'Changed core'),
    (changedModem, 'Changed modem'),
    (othersAction, 'Others'),
  ];

  // Materials Used
  static const fastConnector = 'fast_connector';
  static const coupler = 'coupler';
  static const modular = 'modular';
  static const patchcord = 'patchcord';
  static const sleeve = 'sleeve';
  static const pigtail = 'pigtail';
  static const dropFiber = 'drop_fiber';
  static const othersMaterial = 'others';

  // Materials Used Choices
  static const materialChoices = [
    (fastConnector, 'Fast connector'),
    (coupler, 'Coupler'),
    (modular, 'Modular'),
    (patchcord, 'Patchcord'),
    (sleeve, 'Sleeve'),
    (pigtail, 'Pigtail'),
    (dropFiber, 'Drop fiber'),
    (othersMaterial, 'Others'),
  ];

  // Findings Choices
  static const findingsChoices = [
    (redLos, 'Red LOS (Fibercut)'),
    (highloss, 'Highloss'),
    (serviceAffected, 'Service are affected (Fiberbreak)'),
    (modemIssue, 'Modem Issue'),
    (intermittentConnection, 'Intermittent connection'),
    (others, 'Others'),
  ];

  static const satisfactionLevels = [
    ['Very Dissatisfied', '1'],
    ['Dissatisfied', '2'],
    ['Neutral', '3'],
    ['Satisfied', '4'],
    ['Most Satisfied', '5']
  ];

  // API Methods
  Future<dynamic> create(dynamic data) async {
    final res = await dio.post<dynamic>(
      apiFSR,
      data: data,
    );
    return res.data;
  }

  Future<List<ShortFSR>> getFSRList() async {
    final res = await dio.get<dynamic>(
      apiFSR,
    );
    // Ensure the response data is a list and deserialize each item
    final data = (res.data as List<dynamic>).map((element) {
      return ShortFSR.fromJson(element);
    }).toList();

    return data;
  }

  Future<List<TicketID>> getFSRTickets() async {
    final res = await dio.get<dynamic>(
      apiFSRTickets,
    );
    // Ensure the response data is a list and deserialize each item
    final data = (res.data as List<dynamic>).map((element) {
      return TicketID.fromJson(element);
    }).toList();

    return data;
  }
}

FSRService fsr$ = FSRService();
