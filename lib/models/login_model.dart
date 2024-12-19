class LoginModel {
  final int id;
  final String role;
  final String accessToken;

  LoginModel({
    required this.id,
    required this.role,
    required this.accessToken,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
        id: json["id"],
        role: json["role"],
        accessToken: json["access_token"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "role": role,
        "access_token": accessToken,
      };
}
