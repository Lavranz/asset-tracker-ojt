import 'package:apollo_tracker_mobile/commons/constants/api.constant.dart';
import 'package:apollo_tracker_mobile/commons/constants/config.constant.dart';
import 'package:apollo_tracker_mobile/commons/models/ticket.model.dart';
import 'package:apollo_tracker_mobile/commons/models/users.model.dart';
import 'package:apollo_tracker_mobile/commons/utils/http.util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class _TicketService extends ChangeNotifier {
  final _storage = const FlutterSecureStorage();

  Future<List<TicketItem>> list() async {
    final res = await dio.get<dynamic>(
      apiTicketList,
    );
    final data = (res.data as List).map((element) {
      return TicketItem.fromJson(element);
    });
    return List.from(data);
  }

  Future<TicketStat> stats() async {
    final res = await dio.get<dynamic>(
      apiTicketListStat,
    );

    return TicketStat.fromJson(res.data);
  }

  Future<TicketItem> detail(dynamic id) async {
    final res = await dio.get<dynamic>(
      urlEncode([apiTicketList, id]),
    );
    return TicketItem.fromJson(res.data);
  }

  Future<dynamic> createLog(dynamic id, dynamic data) async {
    final res = await dio.post<dynamic>(
      urlEncode([apiTicketList, id, 'logs']),
      data: data
    );
    return res.data;
  }


  Future<dynamic> createResponse(dynamic id, dynamic data) async {
    final res = await dio.post<dynamic>(
      urlEncode([apiTicketList, id, 'response']),
      data: data
    );
    return res.data;
  }

  Future<dynamic> createComment(dynamic id, dynamic data) async {
    final res = await dio.post<dynamic>(
      urlEncode([apiTicketList, id, 'comment']),
      data: data
    );
    return res.data;
  }

  Future<List<TicketHistory>> histories(dynamic id) async {
    final res = await dio.get<dynamic>(
      urlEncode([apiTicketList, id, 'histories']),
    );

    // Ensure the response data is a list and deserialize each item
    final data = (res.data as List<dynamic>).map((element) {
      return TicketHistory.fromJson(element as Map<String, dynamic>);
    }).toList();

    return data;
  }

  Future<List<FileAttachment>> attachments(dynamic id) async {
    final res = await dio.get<dynamic>(
      urlEncode([apiTicketList, id, 'attachments']),
    );

    // Ensure the response data is a list and deserialize each item
    final data = (res.data as List<dynamic>).map((element) {
      return FileAttachment.fromJson(element as Map<String, dynamic>);
    }).toList();

    return data;
  }

  change() {
    ticket$ = _TicketService();
  }
}

_TicketService ticket$ = _TicketService();
