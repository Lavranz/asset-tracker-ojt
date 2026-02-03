class AgentAuth {
  final int id;
  final String firstName;
  final String lastName;
  final String agentCode;
  final String? mobileNumber;
  final String deviceKey;
  final String status; // Could also use an enum for specific statuses
  final String dateCreated; // Changed to String
  final int user;
  final String? islandGroup;
  final String? area;
  final String? group;
  dynamic timeInToday; // Changed to String

  AgentAuth({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.agentCode,
    this.mobileNumber,
    required this.deviceKey,
    required this.status,
    required this.dateCreated,
    required this.user,
    this.islandGroup,
    this.area,
    this.group,
    this.timeInToday,
  });

  // Factory constructor to create an Agent from a JSON map
  factory AgentAuth.fromJson(Map<String, dynamic> json) {
    return AgentAuth(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      agentCode: json['agent_code'],
      mobileNumber: json['mobile_number'],
      deviceKey: json['device_key'],
      status: json['status'],
      dateCreated: json['date_created'], // Directly assigning string
      user: json['user'],
      islandGroup: json['island_group'],
      area: json['area'],
      group: json['group'],
      timeInToday: json['time_in_today'], // Directly assigning string
    );
  }

  // Method to convert an Agent instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'agent_code': agentCode,
      'mobile_number': mobileNumber,
      'device_key': deviceKey,
      'status': status,
      'date_created': dateCreated, // No conversion, just return string
      'user': user,
      'island_group': islandGroup,
      'area': area,
      'group': group,
      'time_in_today': timeInToday, // No conversion, just return string
    };
  }
}



class AgentLocation {
  final double accuracy;
  final int id;
  final double latitude;
  final double longitude;
  final DateTime date;

  AgentLocation({
    required this.accuracy,
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.date,
  });

  /// Factory method to create an instance from JSON
  factory AgentLocation.fromJson(Map<String, dynamic> json) {
    return AgentLocation(
      accuracy: json['accuracy'] as double,
      id: json['id'] as int,
      latitude: json['latitude'] as double,
      longitude: json['longitude'] as double,
      date: DateTime.parse(json['date'] as String),
    );
  }

  /// Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'accuracy': accuracy,
      'id': id,
      'latitude': latitude,
      'longitude': longitude,
      'date': date.toIso8601String(),
    };
  }
}