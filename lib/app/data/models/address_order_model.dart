class AddressOrderModel {
  String provinsi;
  String kabupaten;
  String name;
  String kecamatan;
  String kelurahan;
  String detail;

  AddressOrderModel({
    required this.provinsi,
    required this.kabupaten,
    required this.name,
    required this.kecamatan,
    required this.kelurahan,
    required this.detail,
  });

  factory AddressOrderModel.fromJson(Map<String, dynamic> json) {
    return AddressOrderModel(
      provinsi: json['provinsi'],
      kabupaten: json['kabupaten'],
      name: json['name'],
      kecamatan: json['kecamatan'],
      kelurahan: json['kelurahan'],
      detail: json['detail'],
    );
  }
}
