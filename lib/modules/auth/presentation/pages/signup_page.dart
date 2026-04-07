import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unseen/config/colors.dart';
import 'package:unseen/core/utils/size.util.dart';
import 'package:unseen/modules/auth/presentation/controllers/register_controller.dart';
import 'package:unseen/modules/auth/presentation/widgets/auth_widgets.dart';

class SignupPage extends GetView<RegisterController> {
  static const String route = '/signup';

  const SignupPage({super.key});

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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                24.verticalSpace,
                GestureDetector(
                  onTap: () => Get.back(),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.chevron_left,
                        color: AppColors.textPrimary,
                        size: 22,
                      ),
                      Text(
                        'Back to Login',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
                40.verticalSpace,
                const Text(
                  'Create Account',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                10.verticalSpace,
                const Text(
                  'Join the network of scouts and clients.',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 15,
                  ),
                ),
                32.verticalSpace,
                AuthTextField(
                  controller: controller.emailCTRL,
                  hint: 'Email Address',
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
                    validator: (v) => (v == null || v.length < 8)
                        ? 'Minimum 8 characters'
                        : null,
                  ),
                ),
                16.verticalSpace,
                Obx(
                  () => AuthTextField(
                    controller: controller.confirmPasswordCTRL,
                    hint: 'Confirm Password',
                    obscureText: controller.obscureConfirmPass.value,
                    prefixIcon: const Icon(
                      Icons.lock_outline,
                      color: AppColors.iconColor,
                      size: 20,
                    ),
                    validator: (v) => v != controller.passwordCTRL.text
                        ? 'Passwords do not match'
                        : null,
                  ),
                ),
                36.verticalSpace,
                PrimaryButton(
                  label: 'Continue',
                  onPressed: () => controller.continueToPhone(formKey),
                ),
                28.verticalSpace,
                const AuthDivider(text: 'OR'),
                28.verticalSpace,
                GoogleButton(
                  label: 'Sign up with Google',
                  onPressed: () {},
                ),
                32.verticalSpace,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
