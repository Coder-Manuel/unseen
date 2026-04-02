import 'dart:developer';

enum Environment { staging, prod }

abstract class Env {
  static Environment env = Environment.staging;
  static bool get isProd {
    return env == Environment.prod;
  }

  // ======== API URL ============
  static const String baseUrl = String.fromEnvironment('BASE_URL');

  static const String mixpanelToken = String.fromEnvironment('MIXPANEL_TOKEN');

  static void init() {
    const envString = String.fromEnvironment('env', defaultValue: 'staging');
    Environment environment = Environment.values.firstWhere(
      (v) => v.name == envString.toLowerCase(),
      orElse: () => Environment.staging,
    );
    env = environment;

    switch (environment) {
      case Environment.staging:
        {
          break;
        }
      case Environment.prod:
        {
          break;
        }
    }

    log("BASE URL: $baseUrl");
  }
}
