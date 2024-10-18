import 'package:cyber/app/routes/app_pages.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/address_controller.dart';

class AddressView extends GetView<AddressController> {
  AddressView({super.key});

  final addressController = Get.find<AddressController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Get.back();
          },
        ),
        title: const Text('Addresses'),
        centerTitle: true,
      ),
      body: GetBuilder(
        init: addressController,
        builder: (controller) {
          return controller.isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : controller.addresses!.isEmpty
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
                              Get.toNamed(
                                  "${Routes.ADDRESS}${Routes.CREATE_ADDRESS}");
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
                            itemCount: controller.addresses!.length,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(controller.addresses![index].name),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${controller.addresses![index].detail} ${controller.addresses![index].kelurahan} ${controller.addresses![index].kecamatan} ${controller.addresses![index].kabupaten} ${controller.addresses![index].provinsi}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                ),
                                trailing: IconButton(
                                    icon: Icon(Icons.edit),
                                    onPressed: () => Get.toNamed(
                                        "${Routes.ADDRESS}/edit-address/${controller.addresses![index].id}")),
                              );
                            },
                          ),
                          SizedBox(height: 20),
                          ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  WidgetStateProperty.all(Colors.black),
                            ),
                            onPressed: () {
                              Get.toNamed("${Routes.ADDRESS}/create-address");
                            },
                            child: Text('Add Address',
                                style: TextStyle(color: Colors.white)),
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                    );
        },
      ),
    );
  }
}
