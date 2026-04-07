import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:unseen/core/utils/loader.dart';
import 'package:unseen/core/utils/toast.dart';
import 'package:unseen/modules/auth/data/models/auth.inputs.dart';
import 'package:unseen/modules/auth/domain/usecases/register.usecase.dart';
import 'package:unseen/modules/auth/presentation/pages/names_setup_page.dart';
import 'package:unseen/modules/auth/presentation/pages/phone_setup_page.dart';
import 'package:unseen/modules/auth/presentation/pages/verify_page.dart';
import 'package:unseen/modules/home/presentation/pages/home_page.dart';

class RegisterController extends GetxController {
  final registerUsecase = Get.find<RegisterUsecase>();

  // Step 1 — credentials
  final emailCTRL = TextEditingController();
  final passwordCTRL = TextEditingController();
  final confirmPasswordCTRL = TextEditingController();

  // Step 2 — phone
  final phoneCTRL = TextEditingController();
  RxString countryCode = '+254'.obs;

  // Step 3 — OTP
  final List<TextEditingController> otpControllers =
      List.generate(6, (_) => TextEditingController());

  // Step 4 — names
  final firstNameCTRL = TextEditingController();
  final lastNameCTRL = TextEditingController();

  RxBool obscurePass = true.obs;
  RxBool obscureConfirmPass = true.obs;

  void toggleObscurePass() => obscurePass.value = !obscurePass.value;
  void toggleObscureConfirmPass() =>
      obscureConfirmPass.value = !obscureConfirmPass.value;

  void continueToPhone(GlobalKey<FormState> formKey) {
    if (formKey.currentState?.validate() != true) return;
    Get.toNamed(PhoneSetupPage.route);
  }

  void sendVerificationCode() {
    if (phoneCTRL.text.trim().isEmpty) {
      Toast.error('Enter a valid phone number');
      return;
    }
    Get.toNamed(VerifyPage.route);
  }

  void verifyAndContinue() {
    final otp = otpControllers.map((c) => c.text).join();
    if (otp.length < 6) {
      Toast.error('Enter the 6-digit code');
      return;
    }
    Get.toNamed(NamesSetupPage.route);
  }

  Future<void> completeSignup(GlobalKey<FormState> formKey) async {
    if (formKey.currentState?.validate() != true) return;

    Loader.show(message: 'Creating account...');
    final response = await registerUsecase(
      RegisterInput(
        name: '${firstNameCTRL.text.trim()} ${lastNameCTRL.text.trim()}',
        location: '',
        owner: (
          name: '${firstNameCTRL.text.trim()} ${lastNameCTRL.text.trim()}',
          email: emailCTRL.text.trim(),
          phone: '${countryCode.value}${phoneCTRL.text.trim()}',
          password: passwordCTRL.text.trim(),
        ),
      ),
    );
    Loader.dismiss();

    response.fold(
      (ex) => Toast.error(ex.message),
      (_) => Get.offAllNamed(HomePage.route),
    );
  }

  @override
  void onClose() {
    emailCTRL.dispose();
    passwordCTRL.dispose();
    confirmPasswordCTRL.dispose();
    phoneCTRL.dispose();
    for (final c in otpControllers) {
      c.dispose();
    }
    firstNameCTRL.dispose();
    lastNameCTRL.dispose();
    super.onClose();
  }
}
