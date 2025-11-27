import 'package:get/get.dart';

import '../controllers/trannsaction_details_controller.dart';

class TrannsactionDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TrannsactionDetailsController>(
      () => TrannsactionDetailsController(),
    );
  }
}
