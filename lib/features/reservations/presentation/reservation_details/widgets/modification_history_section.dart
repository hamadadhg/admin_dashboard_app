import 'package:flutter/material.dart';
import 'package:flutter_admin_dashboard/core/app_theme.dart';
import 'package:flutter_admin_dashboard/features/reservations/data/widgets/custom_icon_widget.dart';

class ModificationHistorySection extends StatelessWidget {
  final Map<String, dynamic> reservation;

  const ModificationHistorySection({
    Key? key,
    required this.reservation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> history = _getModificationHistory();

    if (history.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 4, vertical: 1),
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowLight,
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'history',
                color: AppTheme.primaryLight,
                size: 20,
              ),
              SizedBox(width: 2),
              Text(
                'Modification History',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimaryLight,
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: history.length,
            separatorBuilder: (context, index) => SizedBox(height: 5),
            itemBuilder: (context, index) {
              final item = history[index];
              return _buildHistoryItem(item);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryItem(Map<String, dynamic> item) {
    final String action = (item['action'] as String?) ?? '';
    final String timestamp = (item['timestamp'] as String?) ?? '';
    final String user = (item['user'] as String?) ?? 'System';

    Color actionColor;
    String actionIcon;

    switch (action.toLowerCase()) {
      case 'created':
        actionColor = AppTheme.primaryLight;
        actionIcon = 'add_circle';
        break;
      case 'confirmed':
        actionColor = AppTheme.successLight;
        actionIcon = 'check_circle';
        break;
      case 'rejected':
      case 'canceled':
        actionColor = AppTheme.errorLight;
        actionIcon = 'cancel';
        break;
      case 'modified':
        actionColor = AppTheme.warningLight;
        actionIcon = 'edit';
        break;
      default:
        actionColor = AppTheme.textSecondaryLight;
        actionIcon = 'info';
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 8,
          height: 8,
          margin: EdgeInsets.only(top: 1),
          decoration: BoxDecoration(
            color: actionColor,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 3),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CustomIconWidget(
                    iconName: actionIcon,
                    color: actionColor,
                    size: 16,
                  ),
                  SizedBox(width: 2),
                  Expanded(
                    child: Text(
                      action,
                      style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: actionColor,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 0.5),
              Text(
                'by $user',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.textSecondaryLight,
                ),
              ),
              SizedBox(height: 0.5),
              Text(
                timestamp,
                style: AppTheme.getMonospaceStyle(
                  isLight: true,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ).copyWith(
                  color: AppTheme.textSecondaryLight,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<Map<String, dynamic>> _getModificationHistory() {
    // Mock modification history based on reservation data
    final List<Map<String, dynamic>> history = [];

    // Add creation entry
    history.add({
      'action': 'Created',
      'timestamp':
          (reservation['bookingTimestamp'] as String?) ?? '2025-01-05 10:30 AM',
      'user': (reservation['guestName'] as String?) ?? 'Guest',
    });

    // Add status-based entries
    final String status = (reservation['status'] as String?) ?? 'pending';
    if (status != 'pending') {
      String statusAction;
      switch (status.toLowerCase()) {
        case 'confirmed':
          statusAction = 'Confirmed';
          break;
        case 'rejected':
          statusAction = 'Rejected';
          break;
        case 'canceled':
          statusAction = 'Canceled';
          break;
        default:
          statusAction = 'Modified';
      }

      history.add({
        'action': statusAction,
        'timestamp': '2025-01-05 2:15 PM',
        'user': 'Restaurant Staff',
      });
    }

    return history.reversed.toList(); // Show most recent first
  }
}
