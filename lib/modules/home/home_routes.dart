import 'package:get/get.dart';
import 'package:unseen/core/routes/app_route.dart';
import 'package:unseen/modules/home/presentation/controllers/home_controller.dart';
import 'package:unseen/modules/home/presentation/pages/home_page.dart';

class HomeRoutes implements AppRoute {
  @override
  List<GetPage> pages = [
    GetPage(
      name: HomePage.route,
      page: () => const HomePage(),
      binding: BindingsBuilder(() {
        Get.lazyPut<HomeController>(() => HomeController(), fenix: true);
      }),
    ),
  ];
}
