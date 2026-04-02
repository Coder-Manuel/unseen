import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:observe_internet_connectivity/observe_internet_connectivity.dart';
import 'package:unseen/core/remote/network_client.dart';
import 'package:unseen/core/services/connectivity_service/connectivity_controller.dart';
import 'package:unseen/core/services/url_launcher_service/url_launcher_service.dart';
import 'package:unseen/core/utils/navigation_middleware/navigation_controller.dart';

class InitialBinding extends Bindings {
  @override
  Future<void> dependencies() async {
    Get.lazyPut<Dio>(
      () => NetworkClient.dioClient(baseUrl: ''),
      tag: NetworkDioClientType.global.name,
      fenix: true,
    );

    Get.lazyPut(() => NavigationController(), fenix: true);
    Get.lazyPut<UrlLauncherService>(
      () => UrlLauncherServiceImpl(),
      fenix: true,
    );
    Get.put(
      ConnectivityController(strategy: DefaultObServingStrategy()),
      permanent: true,
    );
  }
}
