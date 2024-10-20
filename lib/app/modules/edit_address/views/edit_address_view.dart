import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/edit_address_controller.dart';

class EditAddressView extends GetView<EditAddressController> {
  const EditAddressView({super.key});

  @override
  Widget build(BuildContext context) {
    final editAddressController = Get.find<EditAddressController>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Address'),
        centerTitle: true,
      ),
      body: GetBuilder(
          init: editAddressController,
          builder: (controller) {
            return controller.isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : SingleChildScrollView(
                    child: Container(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("nama: ${controller.address!.name}"),
                            SizedBox(
                              height: 10,
                            ),
                            Text("detail: ${controller.address!.detail}"),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                                "Kelurahan/Desa: ${controller.address!.kelurahan}"),
                            SizedBox(
                              height: 10,
                            ),
                            Text("Kecamatan: ${controller.address!.kecamatan}"),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                                "Kabupaten/Kota: ${controller.address!.kabupaten}"),
                            SizedBox(
                              height: 10,
                            ),
                            Text("Provinsi: ${controller.address!.provinsi}"),
                            SizedBox(
                              height: 10,
                            ),
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
                                  if (controller.nameController.text.isEmpty ||
                                      controller
                                          .detailController.text.isEmpty) {
                                    Get.snackbar('Error',
                                        'All field must be filledasasas');
                                  } else if (controller
                                          .provinceController.text.isNotEmpty &&
                                      (controller.kotaController.text.isEmpty ||
                                          controller
                                              .kecController.text.isEmpty ||
                                          controller
                                              .kelController.text.isEmpty)) {
                                    Get.snackbar(
                                        'Error', 'All field must be filledas');
                                  } else if (controller
                                          .detailController.text.length <
                                      10) {
                                    Get.snackbar(
                                      'Error',
                                      'Detail must be more than 10 characters',
                                    );
                                  } else if (controller
                                          .nameController.text.length <
                                      3) {
                                    Get.snackbar(
                                      'Error',
                                      'Name must be more than 3 characters',
                                    );
                                  } else {
                                    await controller.updateAddress();
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
                        )
                      ],
                    ),
                  ));
          }),
    );
  }
}
