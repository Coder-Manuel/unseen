import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unseen/core/utils/loader.dart';
import 'package:unseen/core/utils/toast.dart';
import 'package:unseen/modules/missions/domain/entities/mission.entity.dart';
import 'package:unseen/modules/rating/data/models/rating.input.dart';
import 'package:unseen/modules/rating/domain/usecases/create_rating.usecase.dart';

class RatingController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final CreateRatingUseCase _createRatingUsecase;

  RatingController({required CreateRatingUseCase createRatingUsecase})
    : _createRatingUsecase = createRatingUsecase;

  late final MissionEntity mission;
  Rx<int> selectedStars = 0.obs;

  late final AnimationController checkCtrl;
  late final Animation<double> checkScale;

  Rx<bool> isRating = false.obs;

  String get scoutName => mission.scout?.displayName ?? 'Scout';

  String get paymentText =>
      'Payment of ${mission.currency} ${mission.price.toStringAsFixed(2)} '
      'has been released to $scoutName.';

  @override
  void onReady() {
    checkCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    super.onReady();
  }

  Future<void> init() async {
    mission = Get.arguments as MissionEntity;
    checkScale = CurvedAnimation(parent: checkCtrl, curve: Curves.elasticOut);
    // Pop the check icon in on entry.
    checkCtrl.forward();
  }

  Future<void> createRating() async {
    if (selectedStars.value <= 0) return onBackToHome();
    Loader.show(message: 'Posting rating...');
    final response = await _createRatingUsecase(
      CreateRatingInput(
        missionId: mission.id ?? '',
        toUserId: mission.scoutId ?? '',
        score: selectedStars.value,
      ),
    );
    Loader.dismiss();

    response.fold((ex) => Toast.error(ex.message), (_) {
      Toast.success('Rating Submitted');
      onBackToHome();
    });
  }

  void onBackToHome() => Get.until((route) => route.isFirst);

  @override
  void onClose() {
    checkCtrl.dispose();
    super.onClose();
  }
}
