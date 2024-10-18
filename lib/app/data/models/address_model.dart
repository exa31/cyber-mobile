class AddressModel {
  String id;
  String provinsi;
  String kabupaten;
  String name;
  String kecamatan;
  String kelurahan;
  String detail;
  String user;

  AddressModel({
    required this.id,
    required this.provinsi,
    required this.kabupaten,
    required this.name,
    required this.kecamatan,
    required this.kelurahan,
    required this.detail,
    required this.user,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['_id'],
      provinsi: json['provinsi'],
      kabupaten: json['kabupaten'],
      name: json['name'],
      kecamatan: json['kecamatan'],
      kelurahan: json['kelurahan'],
      detail: json['detail'],
      user: json['user'],
    );
  }
}
