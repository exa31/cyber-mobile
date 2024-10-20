import 'package:cyber/app/routes/app_pages.dart';
import 'package:cyber/helper/main.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/invoice_controller.dart';

class InvoiceView extends GetView<InvoiceController> {
  const InvoiceView({super.key});
  @override
  Widget build(BuildContext context) {
    final InvoiceController invoiceController = Get.find<InvoiceController>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Invoice'),
        centerTitle: true,
      ),
      body: GetBuilder(
        init: invoiceController,
        builder: (controller) {
          return controller.loading
              ? const Center(child: CircularProgressIndicator())
              : Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'User: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(controller.invoice!.user.name),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Email: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(controller.invoice!.user.email),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Order Date: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(controller.formattedDate!),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Order ID: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(controller.invoice!.order.id),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Delivery Address ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Text(
                          "${controller.invoice!.deliveryAddress.detail} ${controller.invoice!.deliveryAddress.kelurahan} ${controller.invoice!.deliveryAddress.kecamatan} ${controller.invoice!.deliveryAddress.kabupaten} ${controller.invoice!.deliveryAddress.provinsi}"),
                      const SizedBox(height: 10),
                      const Text(
                        'Order',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: List.generate(
                            controller.invoice!.order.orderItems.length,
                            (index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Row(
                              children: [
                                Text(controller
                                    .invoice!.order.orderItems[index].name),
                                const SizedBox(width: 10),
                                Text(
                                    "${controller.invoice!.order.orderItems[index].quantity} item"),
                                const SizedBox(width: 10),
                                Text(Helper.formatPrice(controller
                                    .invoice!.order.orderItems[index].price)),
                              ],
                            ),
                          );
                        }),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Subtotal: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(Helper.formatPrice(controller.subtotal)),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Tax: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(Helper.formatPrice(controller.invoice!.tax)),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Shipping: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                              Helper.formatPrice(controller.invoice!.shipping)),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Discount: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(controller.invoice!.discount.toString()),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(Helper.formatPrice(controller.invoice!.total)),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Status Payment: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(controller.invoice!.statusPayment),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Payment Method: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(controller.invoice!.statusPayment == 'pending'
                              ? 'Select Payment Method'
                              : controller.invoice!.statusPayment == "cancelled"
                                  ? 'Cancel'
                                  : controller.invoice!.paymentMethod!),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Status Delivery: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(controller.invoice!.statusDelivery),
                        ],
                      ),
                      const SizedBox(height: 20),
                      controller.invoice?.statusPayment == 'pending' &&
                              controller.invoice!.paymentMethod == null
                          ? SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  Get.offNamed(Routes.SNAP_WEBVIEW, arguments: {
                                    'redirectUrl':
                                        controller.invoice!.order.urlRedirect,
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                ),
                                child: const Text('Pay Now',
                                    style: TextStyle(color: Colors.white)),
                              ),
                            )
                          : const SizedBox(),
                    ],
                  ),
                );
        },
      ),
    );
  }
}
