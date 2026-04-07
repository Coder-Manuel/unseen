import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:unseen/core/utils/loader.dart';
import 'package:unseen/core/utils/toast.dart';
import 'package:unseen/modules/missions/data/models/mission.inputs.dart';
import 'package:unseen/modules/missions/domain/usecases/post_mission.usecase.dart';
import 'package:unseen/modules/missions/presentation/pages/finding_scouts_page.dart';

class PostMissionController extends GetxController {
  final _postMissionUseCase = Get.find<PostMissionUseCase>();

  // Fields matching the DB schema
  final descriptionCTRL = TextEditingController();
  final durationCTRL = TextEditingController(); // user types minutes

  final RxString address = 'Westlands, Nairobi'.obs;
  final RxString currency = 'USD'.obs;
  final RxDouble latitude = (-1.2676).obs;
  final RxDouble longitude = (36.8108).obs;

  final List<int> prices = const [10, 20, 35, 50];
  final RxInt selectedPriceIndex = 1.obs;

  int get selectedPrice => prices[selectedPriceIndex.value];

  void selectPrice(int index) => selectedPriceIndex.value = index;

  Future<void> postMission(GlobalKey<FormState> formKey) async {
    if (formKey.currentState?.validate() != true) return;

    // Convert minutes entered by user → seconds for the DB
    final minutes = int.tryParse(durationCTRL.text.trim()) ?? 5;
    final durationInSec = minutes * 60;

    Loader.show(message: 'Posting mission...');
    final response = await _postMissionUseCase(
      PostMissionInput(
        address: address.value,
        latitude: latitude.value,
        longitude: longitude.value,
        description: descriptionCTRL.text.trim(),
        currency: currency.value,
        price: selectedPrice.toDouble(),
        durationInSec: durationInSec,
      ),
    );
    Loader.dismiss();

    response.fold(
      (ex) => Toast.error(ex.message),
      (_) => Get.toNamed(FindingScoutsPage.route),
    );
  }

  @override
  void onClose() {
    descriptionCTRL.dispose();
    durationCTRL.dispose();
    super.onClose();
  }
}
