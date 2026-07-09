import 'package:common_package/common_package.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'app.dart';
import 'core/di/injection.dart';
import 'core/session/session_expired_handler.dart';

Future<void> _debugLog({
  required String hypothesisId,
  required String location,
  required String message,
  required Map<String, dynamic> data,
  required String runId,
}) async {
  await Future<void>.microtask(() async {
    try {
      final HttpClientRequest request = await HttpClient().postUrl(
        Uri.parse('http://127.0.0.1:7625/ingest/5042b628-86a8-4a41-b5e3-25a2f8284269'),
      );
      request.headers.contentType = ContentType.json;
      request.headers.set('X-Debug-Session-Id', '5a0c08');
      request.write(
        jsonEncode(<String, dynamic>{
          'sessionId': '5a0c08',
          'runId': runId,
          'hypothesisId': hypothesisId,
          'location': location,
          'message': message,
          'data': data,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        }),
      );
      await request.close();
    } catch (_) {}
  });
}

Future<void> main() async {
  const runId = 'initial';
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    // #region agent log
    await _debugLog(
      hypothesisId: 'H1',
      location: 'lib/main.dart:40',
      message: 'main_started',
      data: <String, dynamic>{'stage': 'binding_initialized'},
      runId: runId,
    );
    // #endregion

    FlutterError.onError = (FlutterErrorDetails details) {
      // #region agent log
      _debugLog(
        hypothesisId: 'H4',
        location: 'lib/main.dart:50',
        message: 'flutter_framework_error',
        data: <String, dynamic>{
          'exception': details.exceptionAsString(),
          'library': details.library ?? 'unknown',
        },
        runId: runId,
      );
      // #endregion
      FlutterError.presentError(details);
    };

    final navigatorKey = GlobalKey<NavigatorState>();
    SessionExpiredHandler.navigatorKey = navigatorKey;
    // #region agent log
    await _debugLog(
      hypothesisId: 'H2',
      location: 'lib/main.dart:67',
      message: 'before_bootstrap_app',
      data: <String, dynamic>{
        'fallbackLocale': 'ar',
        'supportedLocales': <String>['en', 'ar'],
        'notificationsEnabled': true,
      },
      runId: runId,
    );
    // #endregion

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

    // #region agent log
    await _debugLog(
      hypothesisId: 'H3',
      location: 'lib/main.dart:90',
      message: 'bootstrap_completed',
      data: <String, dynamic>{'status': 'success'},
      runId: runId,
    );
    // #endregion
  }, (Object error, StackTrace stackTrace) {
    // #region agent log
    _debugLog(
      hypothesisId: 'H5',
      location: 'lib/main.dart:99',
      message: 'uncaught_zone_error',
      data: <String, dynamic>{
        'error': error.toString(),
        'stackTrace': stackTrace.toString(),
      },
      runId: runId,
    );
    // #endregion
  });
}
