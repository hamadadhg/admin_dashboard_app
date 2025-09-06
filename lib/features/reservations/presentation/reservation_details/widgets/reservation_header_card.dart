import 'package:flutter/material.dart';
import 'package:flutter_admin_dashboard/core/app_theme.dart';
import 'package:flutter_admin_dashboard/features/reservations/data/widgets/custom_icon_widget.dart';

class ReservationHeaderCard extends StatelessWidget {
  final Map<String, dynamic> reservation;

  const ReservationHeaderCard({
    Key? key,
    required this.reservation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowLight,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      (reservation['guestName'] as String?) ?? 'Unknown Guest',
                      style:
                          AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimaryLight,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                    SizedBox(height: 1),
                    Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'people',
                          color: AppTheme.textSecondaryLight,
                          size: 20,
                        ),
                        SizedBox(width: 2),
                        Text(
                          '${reservation['partySize'] ?? 0} guests',
                          style:
                              AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                            color: AppTheme.textSecondaryLight,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              _buildStatusBadge(reservation['status'] as String? ?? 'pending'),
            ],
          ),
          SizedBox(height: 2),
          Row(
            children: [
              CustomIconWidget(
                iconName: 'calendar_today',
                color: AppTheme.primaryLight,
                size: 20,
              ),
              SizedBox(width: 2),
              Text(
                (reservation['date'] as String?) ?? 'No date',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(width: 4),
              CustomIconWidget(
                iconName: 'access_time',
                color: AppTheme.primaryLight,
                size: 20,
              ),
              SizedBox(width: 2),
              Text(
                (reservation['time'] as String?) ?? 'No time',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color statusColor;
    Color textColor = Colors.white;

    switch (status.toLowerCase()) {
      case 'confirmed':
        statusColor = AppTheme.successLight;
        break;
      case 'pending':
        statusColor = AppTheme.warningLight;
        textColor = AppTheme.textPrimaryLight;
        break;
      case 'rejected':
      case 'canceled':
        statusColor = AppTheme.errorLight;
        break;
      default:
        statusColor = AppTheme.textSecondaryLight;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3, vertical: 1),
      decoration: BoxDecoration(
        color: statusColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.toUpperCase(),
        style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
          color: textColor,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
