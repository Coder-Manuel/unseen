import 'package:get/get.dart';
import 'package:unseen/modules/auth/auth_routes.dart';
import 'package:unseen/modules/home/home_routes.dart';

class AppPages {
  static final List<GetPage> routes = [
    ...AuthRoutes().pages,
    ...HomeRoutes().pages,
  ];
}
