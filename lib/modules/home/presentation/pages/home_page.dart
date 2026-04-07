import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unseen/config/colors.dart';
import 'package:unseen/modules/home/presentation/pages/tabs/maps_tab.dart';
import 'package:unseen/modules/home/presentation/pages/tabs/missions_tab.dart';
import 'package:unseen/modules/home/presentation/pages/tabs/notifications_tab.dart';
import 'package:unseen/modules/home/presentation/pages/tabs/settings_tab.dart';
import 'package:unseen/modules/home/presentation/controllers/home_controller.dart';

class HomePage extends GetView<HomeController> {
  static const String route = '/home';

  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        return IndexedStack(
          index: controller.currentIndex.value,
          children: const [
            MapsTab(),
            MissionsTab(),
            NotificationsTab(),
            SettingsTab(),
          ],
        );
      }),
      bottomNavigationBar: Obx(
        () => Container(
          decoration: const BoxDecoration(
            color: AppColors.surface,
            border: Border(
              top: BorderSide(color: AppColors.divider, width: 0.5),
            ),
          ),
          child: BottomNavigationBar(
            currentIndex: controller.currentIndex.value,
            onTap: controller.changePage,
            backgroundColor: AppColors.surface,
            selectedItemColor: AppColors.primary,
            unselectedItemColor: AppColors.textSecondary,
            type: BottomNavigationBarType.fixed,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            elevation: 0,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.map_outlined),
                activeIcon: Icon(Icons.map),
                label: 'Maps',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.my_location_outlined),
                activeIcon: Icon(Icons.my_location),
                label: 'Missions',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.notifications_outlined),
                activeIcon: Icon(Icons.notifications),
                label: 'Notifications',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings_outlined),
                activeIcon: Icon(Icons.settings),
                label: 'Settings',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
