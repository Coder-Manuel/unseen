import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:unseen/config/env.dart';
import 'package:unseen/core/bindings/initial_binding.dart';
import 'package:unseen/core/services/storage_service/storage.service.dart';

import 'services/analytics_service/analytics_service.dart';
import 'services/monitor_service/monitor.service.dart';

class Initializer {
  /// Docs for injecting services [Future]
  static Future<void> _injectServices() async {
    InitialBinding().dependencies();
  }

  static Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();

    // try {
    //   await Firebase.initializeApp(
    //     options: DefaultFirebaseOptions.currentPlatform,
    //   );
    // } catch (_) {}

    Env.init();
    await MonitorService.init();
    await StorageService.init();
    await AnalyticsService.init();

    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    await _injectServices();
  }
}
