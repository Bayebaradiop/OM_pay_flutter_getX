import 'package:get/get.dart';

import '../modules/activate/bindings/activate_binding.dart';
import '../modules/activate/views/activate_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/register/bindings/register_binding.dart';
import '../modules/register/views/register_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.LOGIN;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => const RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: _Paths.ACTIVATE,
      page: () => const ActivateView(),
      binding: ActivateBinding(),
    ),
    // Route commentée car on utilise Get.bottomSheet au lieu de Get.toNamed
    // GetPage(
    //   name: _Paths.TRANNSACTION_DETAILS,
    //   page: () => const TrannsactionDetailsView(),
    //   binding: TrannsactionDetailsBinding(),
    // ),
  ];
}
