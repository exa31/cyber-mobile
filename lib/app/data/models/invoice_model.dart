import 'package:cyber/app/data/models/address_order_model.dart';
import 'package:cyber/app/data/models/order_model.dart';
import 'package:cyber/app/data/models/user_invoice_model.dart';

class InvoiceModel {
  UserInvoiceModel user;
  AddressOrderModel deliveryAddress;
  int total;
  int tax;
  OrderModel order;
  String? paymentMethod;
  int shipping;
  String statusPayment;
  int discount;
  String statusDelivery;

  InvoiceModel({
    required this.user,
    required this.deliveryAddress,
    required this.total,
    required this.tax,
    required this.order,
    required this.paymentMethod,
    required this.shipping,
    required this.statusPayment,
    required this.discount,
    required this.statusDelivery,
  });

  factory InvoiceModel.fromJson(Map<String, dynamic> json) {
    return InvoiceModel(
      user: UserInvoiceModel.fromJson(json['user']),
      deliveryAddress: AddressOrderModel.fromJson(json['delivery_address']),
      total: json['total'],
      tax: json['tax'],
      order: OrderModel.fromJson(json['order']),
      paymentMethod: json['payment_method'],
      shipping: json['shipping'],
      statusPayment: json['status_payment'],
      discount: json['discount'],
      statusDelivery: json['status_delivery'],
    );
  }
}
