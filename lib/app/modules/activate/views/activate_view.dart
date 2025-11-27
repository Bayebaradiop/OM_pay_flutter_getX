import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/activate_controller.dart';

class ActivateView extends GetView<ActivateController> {
  const ActivateView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ActivateView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'ActivateView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
