import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/create_address_controller.dart';

class CreateAddressView extends GetView<CreateAddressController> {
  const CreateAddressView({super.key});

  @override
  Widget build(BuildContext context) {
    final CreateAddressController createAddressController =
        Get.find<CreateAddressController>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Address'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              GetBuilder(
                  init: createAddressController,
                  builder: (controller) {
                    return Column(
                      children: [
                        //province
                        TextField(
                          controller: controller.nameController,
                          decoration: InputDecoration(
                            labelText: 'Name',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        DropdownMenu(
                          enabled: !controller.isLoadingProvince,
                          controller: controller.provinceController,
                          menuHeight: 300,
                          label: Text('Province'),
                          hintText: 'Select Province',
                          width: double.infinity,
                          onSelected: (value) {
                            controller.getKota(id: value);
                            if (controller.kotaController.text.isNotEmpty) {
                              controller.kotaController.clear();
                              controller.kecController.clear();
                              controller.kelController.clear();
                            }
                          },
                          dropdownMenuEntries: List.generate(
                            controller.provinces.length,
                            (index) {
                              return DropdownMenuEntry(
                                value: controller.provinces[index].id,
                                label: controller.provinces[index].name,
                              );
                            },
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        //kota
                        DropdownMenu(
                          enabled: !controller.isLoadingKota,
                          controller: controller.kotaController,
                          menuHeight: 300,
                          label: Text('Kota/Kabupaten'),
                          hintText: 'Select Kota/Kabupaten',
                          width: double.infinity,
                          onSelected: (value) {
                            controller.getKec(id: value);
                            if (controller.kecController.text.isNotEmpty) {
                              controller.kecController.clear();
                              controller.kelController.clear();
                            }
                          },
                          dropdownMenuEntries: List.generate(
                            controller.kota.length,
                            (index) {
                              return DropdownMenuEntry(
                                value: controller.kota[index].id,
                                label: controller.kota[index].name,
                              );
                            },
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        //kecamatan
                        DropdownMenu(
                          enabled: !controller.isLoadingKec,
                          controller: controller.kecController,
                          menuHeight: 300,
                          label: Text('Kecamatan'),
                          hintText: 'Select Kecamatan',
                          width: double.infinity,
                          onSelected: (value) {
                            controller.getKel(id: value);
                            if (controller.kelController.text.isNotEmpty) {
                              controller.kelController.clear();
                            }
                          },
                          dropdownMenuEntries: List.generate(
                            controller.kec.length,
                            (index) {
                              return DropdownMenuEntry(
                                value: controller.kec[index].id,
                                label: controller.kec[index].name,
                              );
                            },
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        //kelurahan
                        DropdownMenu(
                          enabled: !controller.isLoadingKel,
                          controller: controller.kelController,
                          menuHeight: 300,
                          label: Text('Kelurahan/Desa'),
                          hintText: 'Select Kelurahan/Desa',
                          width: double.infinity,
                          onSelected: (value) {},
                          dropdownMenuEntries: List.generate(
                            controller.kel.length,
                            (index) {
                              return DropdownMenuEntry(
                                value: controller.kel[index].id,
                                label: controller.kel[index].name,
                              );
                            },
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          height: 80,
                          child: TextField(
                            maxLines: 3,
                            onChanged: (value) {},
                            controller: controller.detailController,
                            decoration: InputDecoration(
                              labelText: 'Detail',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
                              if (controller.isSubmit) {
                              } else if (controller
                                      .nameController.text.isEmpty ||
                                  controller.provinceController.text.isEmpty ||
                                  controller.kotaController.text.isEmpty ||
                                  controller.kecController.text.isEmpty ||
                                  controller.kelController.text.isEmpty ||
                                  controller.detailController.text.isEmpty) {
                                Get.snackbar(
                                    'Error', 'All field must be filled');
                              } else if (controller
                                      .detailController.text.length <
                                  10) {
                                Get.snackbar(
                                  'Error',
                                  'Detail must be more than 10 characters',
                                );
                              } else if (controller.nameController.text.length <
                                  3) {
                                Get.snackbar(
                                  'Error',
                                  'Name must be more than 3 characters',
                                );
                              } else {
                                await controller.createAddress();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                            ),
                            child: Text(
                              'Submit',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        )
                      ],
                    );
                  })
            ],
          ),
        ),
      ),
    );
  }
}
