class ResponMidtransModel {
  String token;
  String redirectUrl;

  ResponMidtransModel({
    required this.token,
    required this.redirectUrl,
  });

  factory ResponMidtransModel.fromJson(Map<String, dynamic> json) {
    return ResponMidtransModel(
      token: json['token'],
      redirectUrl: json['url'],
    );
  }
}
