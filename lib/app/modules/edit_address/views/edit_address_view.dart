import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/edit_address_controller.dart';

class EditAddressView extends GetView<EditAddressController> {
  const EditAddressView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EditAddressView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'EditAddressView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
