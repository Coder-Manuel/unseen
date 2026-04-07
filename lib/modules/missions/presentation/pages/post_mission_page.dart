import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unseen/config/colors.dart';
import 'package:unseen/core/utils/size.util.dart';
import 'package:unseen/modules/missions/presentation/controllers/post_mission_controller.dart';

class PostMissionPage extends GetView<PostMissionController> {
  static const String route = '/post-mission';

  const PostMissionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // ── App bar ─────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: Row(
                children: [
                  _CircleBackButton(),
                  const SizedBox(width: 14),
                  const Text(
                    'Post a Mission',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            16.verticalSpace,

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── GPS banner ───────────────────────────────────────
                      Obx(
                        () => _GpsBanner(location: controller.address.value),
                      ),
                      24.verticalSpace,

                      // ── Instructions to scout (description) ──────────────
                      _FieldLabel('INSTRUCTIONS TO SCOUT'),
                      6.verticalSpace,
                      _MissionTextField(
                        controller: controller.descriptionCTRL,
                        hint:
                            'e.g. Walk the block and show me the main gate...',
                        maxLines: 4,
                        validator: (v) => (v == null || v.isEmpty)
                            ? 'Enter instructions'
                            : null,
                      ),
                      20.verticalSpace,

                      // ── Duration (minutes) ────────────────────────────────
                      _FieldLabel('DURATION (MINUTES)'),
                      6.verticalSpace,
                      _MissionTextField(
                        controller: controller.durationCTRL,
                        hint: 'e.g. 5',
                        keyboardType: TextInputType.number,
                        validator: (v) => (v == null || v.isEmpty)
                            ? 'Enter duration in minutes'
                            : null,
                      ),
                      20.verticalSpace,

                      // ── Offer price ───────────────────────────────────────
                      _FieldLabel('OFFER PRICE'),
                      12.verticalSpace,
                      Obx(
                        () => Row(
                          children: List.generate(
                            controller.prices.length,
                            (i) => Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(
                                    right: i < controller.prices.length - 1
                                        ? 10
                                        : 0),
                                child: _PriceChip(
                                  label:
                                      '\$${controller.prices[i]}',
                                  selected:
                                      controller.selectedPriceIndex.value == i,
                                  onTap: () => controller.selectPrice(i),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      32.verticalSpace,

                      // ── Post button ───────────────────────────────────────
                      SizedBox(
                        width: double.infinity,
                        height: 58,
                        child: ElevatedButton(
                          onPressed: () => controller.postMission(formKey),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                          child: const Text(
                            'Post Mission  →',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                      32.verticalSpace,
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── GPS Banner ───────────────────────────────────────────────────────────────

class _GpsBanner extends StatelessWidget {
  final String location;
  const _GpsBanner({required this.location});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1A0E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primary.withAlpha(60),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          const Text('📍', style: TextStyle(fontSize: 16)),
          const SizedBox(width: 10),
          Text(
            '$location · GPS confirmed',
            style: const TextStyle(
              color: AppColors.primary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Field label ──────────────────────────────────────────────────────────────

class _FieldLabel extends StatelessWidget {
  final String label;
  const _FieldLabel(this.label);

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        color: AppColors.textSecondary,
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.1,
      ),
    );
  }
}

// ─── Mission text field ───────────────────────────────────────────────────────

class _MissionTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final int maxLines;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  const _MissionTextField({
    required this.controller,
    required this.hint,
    this.maxLines = 1,
    this.keyboardType,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
      style: const TextStyle(color: AppColors.textPrimary, fontSize: 15),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle:
            const TextStyle(color: AppColors.textSecondary, fontSize: 15),
        filled: true,
        fillColor: AppColors.inputBg,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }
}

// ─── Price chip ───────────────────────────────────────────────────────────────

class _PriceChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _PriceChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        height: 48,
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary.withAlpha(25)
              : AppColors.inputBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? AppColors.primary : Colors.transparent,
            width: 1.5,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: selected ? AppColors.primary : AppColors.textSecondary,
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

// ─── Circle back button ───────────────────────────────────────────────────────

class _CircleBackButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.back(),
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: AppColors.surface,
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.arrow_back,
          color: AppColors.textPrimary,
          size: 20,
        ),
      ),
    );
  }
}
