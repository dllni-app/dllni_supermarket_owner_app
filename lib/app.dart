import 'package:common_package/helpers/shared_preferences_helper.dart';
import 'package:dllni_supermarket_owner_app/features/auth/view/screens/login_screen.dart';
import 'package:dllni_supermarket_owner_app/features/main_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'core/routes/app_router.dart';
import 'core/themes/app_theme.dart';
import 'features/home/view/home_screen.dart';

class App extends StatelessWidget {
  const App({super.key, required this.navigatorKey});

  final GlobalKey<NavigatorState> navigatorKey;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Dllni',
      theme: AppTheme.light,
      debugShowCheckedModeBanner: false,
      locale: context.locale,
      supportedLocales: context.supportedLocales,
      localizationsDelegates: context.localizationDelegates,
      onGenerateRoute: AppRouter.onGenerateRoute,
      home:
          SharedPreferencesHelper.getData(key: 'token') != null &&
              SharedPreferencesHelper.getData(key: 'token') != ""
          ? MainPage()
          : LoginScreen(),
    );
  }
}
