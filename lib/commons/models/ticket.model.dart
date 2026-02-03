class TicketStat {
  int all;
  int today;
  int due;

  TicketStat({
    required this.all,
    required this.today,
    required this.due,
  });

  factory TicketStat.fromJson(Map<String, dynamic> json) {
    return TicketStat(
      all: json['all'] as int,
      today: json['today'] as int,
      due: json['due'] as int,
    );
  }
}

class TicketItem {
  final int id;
  final String ticketId;
  final String? arNumber;
  final String status;
  final String? agentCode;
  final String? agentName;
  final String queue;
  final String requestor;
  final String subject;
  final String description;
  final int? siteId;
  final String dateCreated; // Keeping date as string
  final String? dateAccepted; // Keeping date as string
  final String? timeIn;
  final bool hasReport;
  final String? timeOut; 
  final bool isAccepted;
  final String source;
  final String? remarks;
  final bool isArchived;
  final String? assignedSite;
  final int? agent;
  final String? rtQueue;
  final String coordinates;
  final String services;
  final String priority;
  final String told;
  final String due;
  final String starts;
  final String sla;
  final String resolved;
  final String started;
  final String created; // Keeping date as string
  final String region; // Keeping date as string
  final String lastUpdated; // Keeping date as string
  final List<String> cc;
  final List<String> requestors;
  final List<String> adminCc;
  final String owner;
  final String numericalId;

  final String? accountName;
  final String? contactNumber;
  final String? serviceAddress;
  final String? clientType;


  TicketItem({
    required this.id,
    required this.ticketId,
    required this.region,
    this.arNumber,
    required this.status,
    this.agentCode,
    this.agentName,
    required this.queue,
    required this.requestor,
    required this.subject,
    required this.description,
    this.siteId,
    required this.dateCreated,
    this.dateAccepted,
    this.timeIn,
    this.timeOut,
    required this.hasReport,
    required this.isAccepted,
    required this.source,
    this.remarks,
    required this.isArchived,
    this.assignedSite,
    this.agent,
    this.rtQueue,
    required this.coordinates,
    required this.sla,
    required this.services,
    required this.priority,
    required this.told,
    required this.starts,
    required this.due,
    required this.resolved,
    required this.started,
    required this.created,
    required this.lastUpdated,
    required this.cc,
    required this.requestors,
    required this.adminCc,
    required this.owner,
    required this.numericalId,
    this.accountName,
    this.contactNumber,
    this.serviceAddress,
    this.clientType
  });

  // Factory constructor to create a TicketItem from JSON
  factory TicketItem.fromJson(Map<String, dynamic> json) {
    return TicketItem(
      id: json['id'],
      ticketId: json['ticket_id'],
      region: json['region'],
      arNumber: json['ar_number'],
      status: json['status'],
      sla: json['sla'],
      agentCode: json['agent_code'],
      agentName: json['agent_name'],
      queue: json['queue'],
      requestor: json['requestor'],
      subject: json['subject'],
      description: json['description'],
      siteId: json['site_id'],
      dateCreated: json['date_created'],
      dateAccepted: json['date_accepted'],
      timeIn: json['time_in'],
      timeOut: json['time_out'],
      hasReport: json['has_report'],
      isAccepted: json['is_accepted'],
      source: json['source'],
      remarks: json['remarks'],
      isArchived: json['is_archived'],
      assignedSite: json['assigned_site'],
      agent: json['agent'],
      rtQueue: json['rt_queue'],
      coordinates: json['coordinates'],
      services: json['services'],
      priority: json['priority'],
      told: json['told'],
      starts: json['starts'],
      due: json['due'],
      resolved: json['resolved'],
      started: json['started'],
      created: json['created'],
      lastUpdated: json['last_updated'],
      cc: List<String>.from(json['cc']),
      requestors: List<String>.from(json['requestors']),
      adminCc: List<String>.from(json['admin_cc']),
      owner: json['owner'],
      numericalId: json['numerical_id'],
      accountName: json['account_name'],
      contactNumber: json['contact_number'],
      serviceAddress: json['service_address'],
      clientType: json['client_type'],
    );
  }

  // Method to convert a TicketItem to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ticket_id': ticketId,
      'region': region,
      'ar_number': arNumber,
      'status': status,
      'agent_code': agentCode,
      'sla': sla,
      'agent_name': agentName,
      'queue': queue,
      'requestor': requestor,
      'subject': subject,
      'description': description,
      'site_id': siteId,
      'date_created': dateCreated,
      'date_accepted': dateAccepted,
      'time_in': timeIn,
      'time_out': timeOut,
      'has_report': hasReport,
      'is_accepted': isAccepted,
      'source': source,
      'remarks': remarks,
      'is_archived': isArchived,
      'assigned_site': assignedSite,
      'agent': agent,
      'rt_queue': rtQueue,
      'coordinates': coordinates,
      'services': services,
      'priority': priority,
      'told': told,
      'due': due,
      'resolved': resolved,
      'starts': starts,
      'started': started,
      'created': created,
      'last_updated': lastUpdated,
      'cc': cc,
      'requestors': requestors,
      'admin_cc': adminCc,
      'owner': owner,
      'numerical_id': numericalId,
      'account_name': accountName,
      'contact_number': contactNumber,
      'service_address': serviceAddress,
      'client_type': clientType
    };
  }
}


class TicketHistory {
  final String id;
  final String created;
  final String description;
  final String content;
  final String creator;
  final List<Attachment> attachments;

  TicketHistory({
    required this.id,
    required this.created,
    required this.description,
    required this.content,
    required this.creator,
    required this.attachments,
  });

  factory TicketHistory.fromJson(Map<String, dynamic> json) {
    return TicketHistory(
      id: json['id'] as String,
      created: json['created'] as String,
      description: json['description'] as String,
      content: json['content'] as String,
      creator: json['creator'] as String,
      attachments: (json['attachments'] as List<dynamic>)
          .map((attachment) => Attachment.fromJson(attachment as Map<String, dynamic>))
          .toList(),
    );
  }
}

class Attachment {
  final String content;
  final bool isFile;
  final int id;
  final String filename;
  final String contentType;
  final String downloadUrl;
  final String subject;

  Attachment({
    required this.content,
    required this.isFile,
    required this.id,
    required this.filename,
    required this.downloadUrl,
    required this.contentType,
    required this.subject,
  });

  factory Attachment.fromJson(Map<String, dynamic> json) {
    // Check if 'error' key exists in the JSON
    if (json.containsKey('error')) {
      return Attachment(
        content: 'Error loading content',
        isFile: false,
        id: 0,
        filename: 'error.jpg',
        contentType: 'text/plain',
        subject: 'Error',
        downloadUrl: '',
      );
    }

    return Attachment(
      content: json['content'] ?? '',
      isFile: json['is_file'] as bool,
      id: json['id'] as int,
      filename: json['filename'] as String,
      contentType: json['content_type'] as String,
      subject: json['subject'] as String,
      downloadUrl: json['download_url'] ?? '',
    );
  }
}



class FileAttachment {
  final String name;
  final String downloadUrl;
  final String fileSize;

  // Constructor
  FileAttachment({
    required this.name,
    required this.downloadUrl,
    required this.fileSize,
  });

  // Factory method to create an instance from JSON
  factory FileAttachment.fromJson(Map<String, dynamic> json) {
    return FileAttachment(
      name: json['name'],
      downloadUrl: json['download_url'],
      fileSize: json['file_size'],
    );
  }

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'download_url': downloadUrl,
      'file_size': fileSize,
    };
  }
}


class ShortFSR {
  final String? ticketId;
  final String dateCreated;
  final String customer;

  ShortFSR({
    required this.ticketId,
    required this.dateCreated,
    required this.customer,
  });

  // Factory constructor to create ShortFSR from JSON
  factory ShortFSR.fromJson(Map<String, dynamic> json) {
    return ShortFSR(
      ticketId: json['ticket_id'] as String?,
      dateCreated: json['date_created'] as String,
      customer: json['customer'] as String,
    );
  }
}


class TicketID {
  final String ticketId;
  final String subject;

  TicketID({
    required this.ticketId,
    required this.subject,
  });

  // Factory constructor to create ShortFSR from JSON
  factory TicketID.fromJson(Map<String, dynamic> json) {
    return TicketID(
      ticketId: json['ticket_id'] as String,
      subject: json['subject'] as String,
    );
  }
}