import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/user_controller.dart';
import '../../shared/widgets/loading_widget.dart';
import '../../shared/widgets/empty_state_widget.dart';

class UserListScreen extends StatelessWidget {
  const UserListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final UserController controller = Get.find<UserController>();

    return Scaffold(
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey[50],
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search users...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              onChanged: (value) {
                // Implement search functionality
                controller.update();
              },
            ),
          ),

          // User Count Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(() => Text(
                      'Total Users: ${controller.userCount.value}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                    )),
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: controller.refreshUsers,
                ),
              ],
            ),
          ),

          // User List
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const LoadingWidget();
              }

              if (controller.users.isEmpty) {
                return const EmptyStateWidget(
                  icon: Icons.people_outline,
                  title: 'No Users Found',
                  subtitle: 'There are no users to display at the moment.',
                );
              }

              return RefreshIndicator(
                onRefresh: controller.refreshUsers,
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: controller.users.length,
                  itemBuilder: (context, index) {
                    final user = controller.users[index];
                    return _buildUserCard(user, index);
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildUserCard(user, int index) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          radius: 25,
          backgroundColor: Colors.blue[100],
          child: Text(
            user.username.isNotEmpty ? user.username[0].toUpperCase() : 'U',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
        ),
        title: Text(
          user.username,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(
                  Icons.phone,
                  size: 16,
                  color: Colors.grey,
                ),
                const SizedBox(width: 4),
                Text(
                  user.mobile,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green[200]!),
              ),
              child: const Text(
                'Active',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.green,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            switch (value) {
              case 'view':
                _showUserDetails(user);
                break;
              case 'call':
                _callUser(user.mobile);
                break;
            }
          },
          itemBuilder: (BuildContext context) => [
            const PopupMenuItem<String>(
              value: 'view',
              child: Row(
                children: [
                  Icon(Icons.visibility, size: 18),
                  SizedBox(width: 8),
                  Text('View Details'),
                ],
              ),
            ),
            const PopupMenuItem<String>(
              value: 'call',
              child: Row(
                children: [
                  Icon(Icons.phone, size: 18),
                  SizedBox(width: 8),
                  Text('Call User'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showUserDetails(user) {
    Get.dialog(
      AlertDialog(
        title: const Text('User Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Username', user.username),
            const SizedBox(height: 8),
            _buildDetailRow('Mobile', user.mobile),
            const SizedBox(height: 8),
            _buildDetailRow('Status', 'Active'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Text(
            '$label:',
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  void _callUser(String mobile) {
    Get.snackbar(
      'Call User',
      'Calling $mobile...',
      icon: const Icon(Icons.phone, color: Colors.white),
      backgroundColor: Colors.green,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
    );
  }
}
