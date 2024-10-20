import 'package:cyber/app/modules/cart/controllers/cart_controller.dart';
import 'package:cyber/app/routes/app_pages.dart';
import 'package:cyber/helper/main.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/select_addresses_controller.dart';

class SelectAddressesView extends GetView<SelectAddressesController> {
  const SelectAddressesView({super.key});
  @override
  Widget build(BuildContext context) {
    final SelectAddressesController selectAddressController =
        Get.find<SelectAddressesController>();
    final CartController cartController = Get.find<CartController>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Addresses'),
        centerTitle: true,
      ),
      body: GetBuilder(
        init: selectAddressController,
        builder: (controller) {
          return controller.isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : controller.addresses.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/images/no_address.png'),
                          Text('No Address Found'),
                          SizedBox(height: 20),
                          ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  WidgetStateProperty.all(Colors.black26),
                            ),
                            onPressed: () {
                              Get.toNamed(Routes.CREATE_ADDRESS, arguments: {
                                'isEdit': false,
                              });
                            },
                            child: Text('Add Address',
                                style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
                    )
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          ListView.builder(
                            itemCount: controller.addresses.length,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(controller.addresses[index].name),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${controller.addresses[index].detail} ${controller.addresses[index].kelurahan} ${controller.addresses[index].kecamatan} ${controller.addresses[index].kabupaten} ${controller.addresses[index].provinsi}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                ),
                                leading: Radio(
                                    value: controller.addresses[index].id,
                                    groupValue: controller.currentAddressOption,
                                    onChanged: (value) {
                                      controller
                                          .selectAddress(value.toString());
                                    }),
                              );
                            },
                          ),
                        ],
                      ),
                    );
        },
      ),
      bottomNavigationBar: GetBuilder(
        init: selectAddressController,
        builder: (controller) {
          return controller.addresses.isEmpty
              ? SizedBox()
              : Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Subtotal',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            Helper.formatPrice(cartController.totalCart),
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          if (selectAddressController.currentAddressOption ==
                              null) {
                            Get.snackbar('Error', 'Please select address');
                            return;
                          }
                          Get.toNamed(Routes.CHECKOUT);
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Next',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
        },
      ),
    );
  }
}
