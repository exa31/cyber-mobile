class UserInvoiceModel {
  String id;
  String name;
  String email;

  UserInvoiceModel({
    required this.id,
    required this.name,
    required this.email,
  });

  factory UserInvoiceModel.fromJson(Map<String, dynamic> json) {
    return UserInvoiceModel(
      id: json['_id'],
      name: json['name'],
      email: json['email'],
    );
  }
}
