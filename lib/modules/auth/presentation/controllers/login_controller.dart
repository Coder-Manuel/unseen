import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unseen/core/utils/loader.dart';
import 'package:unseen/core/utils/toast.dart';
import 'package:unseen/modules/auth/data/models/auth.inputs.dart';
import 'package:unseen/modules/auth/domain/usecases/login.usecase.dart';
import 'package:unseen/modules/home/presentation/pages/home_page.dart';

class LoginController extends GetxController {
  final loginUsecase = Get.find<LoginUseCase>();

  final emailCTRL = TextEditingController();
  final passwordCTRL = TextEditingController();

  Rx<bool> obscurePass = true.obs;
  Rx<bool> canLoginWithBiometrics = false.obs;

  void toggleObscurePass() => obscurePass.value = !obscurePass.value;

  Future<void> login(GlobalKey<FormState> formKey) async {
    if (formKey.currentState?.validate() != true) return;

    Loader.show(message: 'Login...');
    final response = await loginUsecase(
      LoginInput(
        email: emailCTRL.text.trim(),
        password: passwordCTRL.text.trim(),
      ),
    );
    Loader.dismiss();

    response.fold(
      (ex) {
        Toast.error(ex.message);
      },
      (data) {
        Toast.success('Welcome ${data.name}');
        Get.offAllNamed(HomePage.route);
      },
    );
  }
}
