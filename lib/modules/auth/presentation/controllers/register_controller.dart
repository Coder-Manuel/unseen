import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:unseen/core/utils/loader.dart';
import 'package:unseen/core/utils/toast.dart';
import 'package:unseen/modules/auth/data/models/auth.inputs.dart';
import 'package:unseen/modules/auth/domain/usecases/register.usecase.dart';
import 'package:unseen/modules/auth/domain/usecases/setup_names.usecase.dart';
import 'package:unseen/modules/auth/domain/usecases/setup_phone.usecase.dart';
import 'package:unseen/modules/auth/domain/usecases/verify_phone_otp.usecase.dart';
import 'package:unseen/modules/auth/presentation/pages/names_setup_page.dart';
import 'package:unseen/modules/auth/presentation/pages/phone_setup_page.dart';
import 'package:unseen/modules/auth/presentation/pages/verify_page.dart';
import 'package:unseen/modules/home/presentation/pages/home_page.dart';

class RegisterController extends GetxController {
  final _signupUsecase = Get.find<RegisterUsecase>();
  final _setupPhoneUsecase = Get.find<SetupPhoneUseCase>();
  final _verifyPhoneOtpUsecase = Get.find<VerifyPhoneOtpUseCase>();
  final _setupNamesUsecase = Get.find<SetupNamesUseCase>();

  // ─── Step 1 — Credentials ─────────────────────────────────────────────────
  final emailCTRL = TextEditingController();
  final passwordCTRL = TextEditingController();
  final confirmPasswordCTRL = TextEditingController();
  RxBool obscurePass = true.obs;
  RxBool obscureConfirmPass = true.obs;

  void toggleObscurePass() => obscurePass.value = !obscurePass.value;
  void toggleObscureConfirmPass() =>
      obscureConfirmPass.value = !obscureConfirmPass.value;

  // ─── Step 2 — Phone ───────────────────────────────────────────────────────
  final phoneCTRL = TextEditingController();
  RxString countryCode = '+254'.obs;

  // ─── Step 3 — OTP ─────────────────────────────────────────────────────────
  final List<TextEditingController> otpControllers = List.generate(
    6,
    (_) => TextEditingController(),
  );

  // ─── Step 4 — Names ───────────────────────────────────────────────────────
  final firstNameCTRL = TextEditingController();
  final lastNameCTRL = TextEditingController();

  // ── Actions ─────────────────────────────────────────────────────────────────

  /// Step 1: create account → navigate to phone setup.
  Future<void> continueToPhone(GlobalKey<FormState> formKey) async {
    if (formKey.currentState?.validate() != true) return;

    Loader.show(message: 'Creating account...');
    final response = await _signupUsecase(
      SignupInput(
        email: emailCTRL.text.trim(),
        password: passwordCTRL.text.trim(),
      ),
    );
    Loader.dismiss();

    response.fold(
      (ex) => Toast.error(ex.message),
      (_) => Get.toNamed(PhoneSetupPage.route),
    );
  }

  /// Step 2: send SMS OTP to the entered phone number.
  Future<void> sendVerificationCode() async {
    final phone = phoneCTRL.text.trim();
    if (phone.isEmpty) {
      Toast.error('Enter a valid phone number');
      return;
    }

    Loader.show(message: 'Sending code...');
    final response = await _setupPhoneUsecase(
      PhoneSetupInput(phone: '${countryCode.value}$phone'),
    );
    Loader.dismiss();

    response.fold(
      (ex) => Toast.error(ex.message),
      (_) => Get.toNamed(VerifyPage.route),
    );
  }

  /// Step 3: verify the SMS OTP.
  Future<void> verifyAndContinue() async {
    final otp = otpControllers.map((c) => c.text).join();
    if (otp.length < 6) {
      Toast.error('Enter the 6-digit code');
      return;
    }

    Loader.show(message: 'Verifying...');
    final response = await _verifyPhoneOtpUsecase(
      VerifyOtpInput.phone(
        otp: otp,
        phone: '${countryCode.value}${phoneCTRL.text.trim()}',
      ),
    );
    Loader.dismiss();

    response.fold(
      (ex) => Toast.error(ex.message),
      (_) => Get.toNamed(NamesSetupPage.route),
    );
  }

  /// Step 4: save names and complete signup.
  Future<void> completeSignup(GlobalKey<FormState> formKey) async {
    if (formKey.currentState?.validate() != true) return;

    Loader.show(message: 'Almost done...');
    final response = await _setupNamesUsecase(
      NamesInput(
        firstName: firstNameCTRL.text.trim(),
        lastName: lastNameCTRL.text.trim(),
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
