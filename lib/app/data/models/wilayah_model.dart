class WilayahModel {
  final String id;
  final String name;

  WilayahModel({
    required this.id,
    required this.name,
  });

  factory WilayahModel.fromJson(Map<String, dynamic> json) {
    return WilayahModel(
      id: json['id'],
      name: json['name'],
    );
  }
}
