class ProductModel {
  ProductModel({
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

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        name: json["name"],
        price: json["price"],
        category: json["category"]["name"],
        description: json["description"],
        imageThumbnail: json["image_thumbnail"],
        imageDetails: List<String>.from(json["image_details"].map((x) => x)),
        id: json["_id"],
      );
}
