class AdminModel {
  final int id;
  final String mobile;
  final String? createdAt;
  final String? updatedAt;

  AdminModel({
    required this.id,
    required this.mobile,
    this.createdAt,
    this.updatedAt,
  });

  factory AdminModel.fromJson(Map<String, dynamic> json) {
    return AdminModel(
      id: json["id"] ?? 0,
      mobile: json["mobile"] ?? "",
      createdAt: json["created_at"],
      updatedAt: json["updated_at"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "mobile": mobile,
      "created_at": createdAt,
      "updated_at": updatedAt,
    };
  }

  @override
  String toString() {
    return 'AdminModel(id: $id, mobile: $mobile, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

class LoginResponse {
  final String token;
  final AdminModel admin;

  LoginResponse({
    required this.token,
    required this.admin,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json["token"] ?? "",
      admin: AdminModel.fromJson(json["admin"] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "token": token,
      "admin": admin.toJson(),
    };
  }
}


