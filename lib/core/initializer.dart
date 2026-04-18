import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:unseen/config/env.dart';
import 'package:unseen/core/bindings/initial_binding.dart';
import 'package:unseen/core/services/storage_service/storage.service.dart';
import 'package:unseen/firebase_options.dart';
import 'package:unseen/modules/auth/auth_bindings.dart';
import 'package:unseen/modules/home/home_bindings.dart';
import 'package:unseen/modules/missions/missions_bindings.dart';
import 'package:unseen/modules/rating/rating_bindings.dart';
import 'package:unseen/modules/stream/stream_bindings.dart';
import 'package:unseen/modules/user/user_bindings.dart';

import 'services/analytics_service/analytics_service.dart';
import 'services/monitor_service/monitor.service.dart';
import 'services/notification_service/notification_service.dart';

class Initializer {
  /// Docs for injecting services [Future]
  static Future<void> _injectServices() async {
    InitialBinding().dependencies();
    AuthBindings().dependencies();
    MissionsBindings().dependencies();
    UserBindings().dependencies();
    HomeBindings().dependencies();
    StreamBindings().dependencies();
    RatingBindings().dependencies();
  }

  static Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    Env.init();
    await MonitorService.init();
    await NotificationService.init();
    await StorageService.init();
    await AnalyticsService.init();
    await Supabase.initialize(
      url: Env.supabaseURL,
      anonKey: Env.supabaseAnonKey,
    );

    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    await _injectServices();
  }
}
