import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/routes/app_pages.dart';
import 'app/data/providers/auth_provider.dart';
import 'app/data/providers/compte_provider.dart';
import 'app/data/providers/transaction_provider.dart';
import 'app/data/services/auth_service.dart';
import 'app/data/services/compte_service.dart';
import 'app/data/services/transaction_service.dart';
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialiser les services
  await initServices();
  
  runApp(
    GetMaterialApp(
      title: "OM Pay",
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );
}

Future<void> initServices() async {
  Get.put(AuthProvider());
  Get.put(CompteProvider());
  Get.put(TransactionProvider());
  Get.put(CompteService());
  Get.put(TransactionService());
  await Get.putAsync(() => AuthService().init());
}
