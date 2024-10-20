import 'package:cyber/helper/main.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/order_history_controller.dart';

class OrderHistoryView extends GetView<OrderHistoryController> {
  const OrderHistoryView({super.key});
  @override
  Widget build(BuildContext context) {
    final OrderHistoryController orderController =
        Get.find<OrderHistoryController>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order History'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Text(
                "Order History",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 20),
              GetBuilder(
                init: orderController,
                builder: (controller) {
                  return ListView.separated(
                    itemCount: controller.orders.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    separatorBuilder: (context, index) {
                      return const SizedBox(height: 30);
                    },
                    itemBuilder: (context, index) {
                      final order = controller.orders[index];
                      final createdAt = DateTime.parse(order.createdAt);
                      final updatedAt = DateTime.parse(order.updatedAt);
                      final formattedDate = DateFormat('dd MMMM yyyy').format(
                        createdAt == updatedAt ? createdAt : updatedAt,
                      );
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                formattedDate,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                Helper.formatPrice(order.total),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Text(
                            "${order.orderItems.length} items",
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          const SizedBox(height: 5),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                Get.toNamed(
                                  '/invoice/${order.id}',
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(color: Colors.black),
                                  borderRadius: BorderRadius.circular(50),
                                ),
                              ),
                              child: Text("View Invoice"),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
