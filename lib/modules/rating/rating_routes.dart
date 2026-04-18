import 'package:get/get.dart';
import 'package:unseen/core/routes/app_route.dart';
import 'package:unseen/modules/rating/presentation/pages/rate_scout_page.dart';

class RatingRoutes implements AppRoute {
  @override
  List<GetPage> pages = [
    GetPage(name: RateScoutPage.route, page: () => const RateScoutPage()),
  ];
}
