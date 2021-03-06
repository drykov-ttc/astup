import 'package:astup/app/controllers/auth_controller.dart';
import 'package:astup/app/controllers/controllers.dart';
import 'package:astup/app/controllers/vlan_controller.dart';
import 'package:astup/app/helpers/helpers.dart';
import 'package:astup/app/ui/components/components.dart';
import 'package:astup/app/utils/app_routes.dart';
import 'package:astup/app/utils/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await GetStorage.init();
  await init();
  FirebaseFirestore.instance.settings = const Settings(
      persistenceEnabled: false, cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED);
  runApp(const MyApp());
}

Future<void> init() async {
  Get.put<AuthController>(AuthController());
  Get.put<ThemeController>(ThemeController());
  Get.put<LanguageController>(LanguageController());
  Get.put<LocationController>(LocationController());
  Get.put<VlanController>(VlanController());
  Get.put<ObjectController>(ObjectController("0000"));
}

class MyApp extends StatelessWidget {
  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeController.to.getThemeModeFromStore();
    return GetBuilder<LanguageController>(
      builder: (languageController) => Loading(
        child: GetMaterialApp(
          translations: Localization(),
          locale: languageController.getLocale,
          // <- Current locale
          navigatorObservers: [observer],
          debugShowCheckedModeBanner: false,
          defaultTransition: Transition.fade,
          theme: AppThemes.lightTheme,
          darkTheme: AppThemes.darkTheme,
          themeMode: ThemeMode.system,
          initialRoute: "/",
          getPages: AppRoutes.routes,
        ),
      ),
    );
  }
}
