import 'package:common_package/common_package.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app.dart';
import 'core/di/injection.dart';

Future<void> main() async {
  final navigatorKey = GlobalKey<NavigatorState>();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ),
  );
  await bootstrapApp(
    AppBootstrapConfig(
      navigatorKey: navigatorKey,
      app: App(navigatorKey: navigatorKey),
      configureDependencies: configureInjection,
      enableNotifications: true,
      fallbackLocale: const Locale('ar'),
      supportedLocales: const <Locale>[Locale('en'), Locale('ar')],
      startLocale: Locale("ar"),
      translationsAssetPath: 'assets/translations',
      fcmTokenKey: 'fcm_token',
    ),
  );
}
