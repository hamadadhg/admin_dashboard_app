import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../features/orders/presentation/pages/orders_screen.dart';
import '../controllers/home_controller.dart';
import '../../users/views/user_list_screen.dart';
import '../../categories/views/category_list_screen.dart';
import 'dashboard_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.put(HomeController());

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Admin Dashboard',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.purpleAccent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: controller.refreshDashboard,
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onSelected: (value) {
              if (value == 'logout') {
                _showLogoutDialog(context, controller);
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem<String>(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Logout'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Obx(() {
        switch (controller.selectedIndex.value) {
          case 0:
            return const DashboardScreen();
          case 1:
            return const UserListScreen();
          case 2:
            return const CategoryListScreen();
          case 3:
            return const OrdersScreen();
          default:
            return const DashboardScreen();
        }
      }),
      bottomNavigationBar: Obx(() => BottomNavigationBar(
            currentIndex: controller.selectedIndex.value,
            onTap: controller.changeTabIndex,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Colors.purpleAccent,
            unselectedItemColor: Colors.grey,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.dashboard),
                label: 'Dashboard',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.people),
                label: 'Users',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.category),
                label: 'Categories',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.bookmark_add),
                label: 'Orders',
              ),
            ],
          )),
      floatingActionButton: Obx(() {
        // Show FAB only on categories tab
        if (controller.selectedIndex.value == 2) {
          return FloatingActionButton(
            onPressed: controller.navigateToAddCategory,
            backgroundColor: Colors.blue,
            child: const Icon(Icons.add, color: Colors.white),
          );
        }
        return const SizedBox.shrink();
      }),
    );
  }

  void _showLogoutDialog(BuildContext context, HomeController controller) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                controller.logout();
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }
}
