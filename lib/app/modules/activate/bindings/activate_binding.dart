import 'package:get/get.dart';
import '../controllers/activate_controller.dart';
import '../../../data/providers/auth_provider.dart';

class ActivateBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthProvider>(() => AuthProvider());
    Get.lazyPut<ActivateController>(() => ActivateController());
  }
}
