class UserModel {
  final String username;
  final String mobile;

  UserModel({
    required this.username,
    required this.mobile,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      username: json['username'] ?? '',
      mobile: json['mobile'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'mobile': mobile,
    };
  }

  @override
  String toString() {
    return 'UserModel(username: $username, mobile: $mobile)';
  }
}

class UsersResponse {
  final int count;
  final List<UserModel> users;

  UsersResponse({
    required this.count,
    required this.users,
  });

  factory UsersResponse.fromJson(Map<String, dynamic> json) {
    var usersList = json['users'] as List? ?? [];
    List<UserModel> users =
        usersList.map((user) => UserModel.fromJson(user)).toList();

    return UsersResponse(
      count: json['count'] ?? 0,
      users: users,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'count': count,
      'users': users.map((user) => user.toJson()).toList(),
    };
  }
}
