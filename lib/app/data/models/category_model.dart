class CategoryModel {
  CategoryModel({
    required this.name,
    required this.id,
  });

  String name;
  String id;

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        name: json["name"],
        id: json["_id"],
      );
}
