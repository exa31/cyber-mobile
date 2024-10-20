class OrderItemModel {
  String product;
  int quantity;
  int price;
  String name;

  OrderItemModel({
    required this.product,
    required this.quantity,
    required this.price,
    required this.name,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      product: json['_id'],
      quantity: json['quantity'],
      price: json['price'],
      name: json['name'],
    );
  }
}
