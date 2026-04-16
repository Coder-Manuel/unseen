import 'package:get/get.dart';
import 'package:unseen/core/routes/app_route.dart';
import 'package:unseen/modules/stream/presentation/pages/join_stream_page.dart';

class StreamRoutes implements AppRoute {
  @override
  List<GetPage> pages = [
    GetPage(name: JoinStreamPage.route, page: () => const JoinStreamPage()),
  ];
}
