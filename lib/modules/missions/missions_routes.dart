import 'package:get/get.dart';
import 'package:unseen/core/routes/app_route.dart';
import 'package:unseen/modules/missions/missions_bindings.dart';
import 'package:unseen/modules/missions/presentation/pages/finding_scouts_page.dart';
import 'package:unseen/modules/missions/presentation/pages/post_mission_page.dart';

class MissionsRoutes implements AppRoute {
  @override
  List<GetPage> pages = [
    GetPage(
      name: PostMissionPage.route,
      page: () => const PostMissionPage(),
      binding: MissionsBindings(),
    ),
    GetPage(
      name: FindingScoutsPage.route,
      page: () => const FindingScoutsPage(),
      binding: MissionsBindings(),
    ),
  ];
}
