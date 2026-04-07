import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unseen/config/colors.dart';
import 'package:unseen/core/utils/size.util.dart';
import 'package:unseen/modules/auth/presentation/controllers/login_controller.dart';
import 'package:unseen/modules/auth/presentation/pages/signup_page.dart';
import 'package:unseen/modules/auth/presentation/widgets/auth_widgets.dart';

class LoginPage extends GetView<LoginController> {
  static const String route = '/login';

  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                80.verticalSpace,
                const Text(
                  'UnSeen',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                8.verticalSpace,
                const Text(
                  'See anywhere. Know everything.',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 15,
                  ),
                ),
                64.verticalSpace,
                AuthTextField(
                  controller: controller.emailCTRL,
                  hint: 'Email address',
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: const Icon(
                    Icons.mail_outline,
                    color: AppColors.iconColor,
                    size: 20,
                  ),
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'Enter your email' : null,
                ),
                16.verticalSpace,
                Obx(
                  () => AuthTextField(
                    controller: controller.passwordCTRL,
                    hint: 'Password',
                    obscureText: controller.obscurePass.value,
                    prefixIcon: const Icon(
                      Icons.lock_outline,
                      color: AppColors.iconColor,
                      size: 20,
                    ),
                    suffixIcon: GestureDetector(
                      onTap: controller.toggleObscurePass,
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Icon(
                          controller.obscurePass.value
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: AppColors.iconColor,
                          size: 20,
                        ),
                      ),
                    ),
                    validator: (v) =>
                        (v == null || v.isEmpty) ? 'Enter your password' : null,
                  ),
                ),
                40.verticalSpace,
                PrimaryButton(
                  label: 'Login',
                  onPressed: () => controller.login(formKey),
                ),
                32.verticalSpace,
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: AppColors.biometricBg,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Icon(
                      Icons.fingerprint,
                      color: AppColors.primary,
                      size: 36,
                    ),
                  ),
                ),
                10.verticalSpace,
                const Text(
                  'BIOMETRIC LOGIN',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.2,
                  ),
                ),
                28.verticalSpace,
                const AuthDivider(),
                28.verticalSpace,
                GoogleButton(
                  label: 'Continue with Google',
                  onPressed: () {},
                ),
                40.verticalSpace,
                GestureDetector(
                  onTap: () => Get.toNamed(SignupPage.route),
                  child: RichText(
                    text: const TextSpan(
                      text: "Don't have an account? ",
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 15,
                      ),
                      children: [
                        TextSpan(
                          text: 'Sign Up',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                40.verticalSpace,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
