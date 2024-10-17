class AuthModel {
  final String name;
  final String token;

  AuthModel({
    required this.name,
    required this.token,
  });

  factory AuthModel.fromJson(Map<String, dynamic> json) => AuthModel(
        name: json['name'],
        token: json['token'],
      );
}
