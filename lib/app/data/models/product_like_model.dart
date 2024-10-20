class ProductLikeModel {
  ProductLikeModel({
    required this.name,
    required this.price,
    required this.category,
    required this.description,
    required this.imageThumbnail,
    required this.imageDetails,
    required this.id,
  });

  String name;
  int price;
  String category;
  String description;
  String imageThumbnail;
  List<String> imageDetails;
  String id;

  factory ProductLikeModel.fromJson(Map<String, dynamic> json) =>
      ProductLikeModel(
        name: json["name"],
        price: json["price"],
        category: json["category"],
        description: json["description"],
        imageThumbnail: json["image_thumbnail"],
        imageDetails: List<String>.from(json["image_details"].map((x) => x)),
        id: json["_id"],
      );
}
