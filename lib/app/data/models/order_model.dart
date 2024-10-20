import 'package:cyber/app/data/models/address_order_model.dart';
import 'package:cyber/app/data/models/order_item_model.dart';

class OrderModel {
  String user;
  String id;
  int tax;
  String statusDelivery;
  String? paymentMethod;
  int shipping;
  String token;
  List<OrderItemModel> orderItems;
  String urlRedirect;
  AddressOrderModel deliveryAddress;
  int discount;
  String createdAt;
  String updatedAt;
  int total;
  String statusPayment;

  OrderModel({
    required this.user,
    required this.tax,
    required this.statusDelivery,
    required this.paymentMethod,
    required this.shipping,
    required this.id,
    required this.token,
    required this.orderItems,
    required this.urlRedirect,
    required this.deliveryAddress,
    required this.discount,
    required this.total,
    required this.statusPayment,
    required this.createdAt,
    required this.updatedAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      user: json['user'],
      id: json['_id'],
      tax: json['tax'],
      statusDelivery: json['status_delivery'],
      paymentMethod: json['payment_method'],
      shipping: json['shipping'],
      token: json['token'],
      orderItems: List<OrderItemModel>.from(
          json['order_items'].map((x) => OrderItemModel.fromJson(x))),
      urlRedirect: json['url_redirect'],
      deliveryAddress: AddressOrderModel.fromJson(json['delivery_address']),
      discount: json['discount'],
      total: json['total'],
      statusPayment: json['status_payment'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}
