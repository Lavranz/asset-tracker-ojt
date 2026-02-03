class LoginResult {
  final Agent agent;
  final User user;

  LoginResult({required this.agent, required this.user});

  factory LoginResult.fromJson(Map<String, dynamic> json) => LoginResult(
        agent: Agent.fromJson(json['agent'][0]),
        user: User.fromJson(json['user'][0]),
      );
}

class Agent {
  final int id;
  final String status;
  final String firstName;
  final String agentCode;
  final String lastName;

  Agent({
    required this.id,
    required this.status,
    required this.firstName,
    required this.agentCode,
    required this.lastName,
  });

  factory Agent.fromJson(Map<String, dynamic> json) => Agent(
        id: json['id'],
        status: json['status'],
        firstName: json['first_name'],
        agentCode: json['agent_code'],
        lastName: json['last_name'],
      );
}

class User {
  final bool isAdmin;

  User({required this.isAdmin});

  factory User.fromJson(Map<String, dynamic> json) => User(
        isAdmin: json['is_admin'] ?? false,
      );
}