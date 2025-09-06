import 'package:flutter/material.dart';
import 'package:flutter_admin_dashboard/core/app_theme.dart';
import 'package:flutter_admin_dashboard/features/reservations/data/widgets/custom_icon_widget.dart';

class ReservationInfoSection extends StatelessWidget {
  final Map<String, dynamic> reservation;

  const ReservationInfoSection({
    Key? key,
    required this.reservation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          Text(
            'Reservation Details',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimaryLight,
            ),
          ),
          SizedBox(height: 10),
          _buildInfoRow(
            'Reservation ID',
            (reservation['id']?.toString()) ?? 'N/A',
            isMonospace: true,
          ),
          SizedBox(height: 5),
          _buildInfoRow(
            'Table Number',
            (reservation['tableNumber']?.toString()) ?? 'Not assigned',
          ),
          SizedBox(height: 5),
          _buildInfoRow(
            'Booking Date',
            (reservation['bookingTimestamp'] as String?) ?? 'Unknown',
          ),
          if (reservation['specialRequests'] != null &&
              (reservation['specialRequests'] as String).isNotEmpty) ...[
            SizedBox(height: 10),
            _buildSpecialRequestsSection(),
          ],
          if (reservation['notes'] != null &&
              (reservation['notes'] as String).isNotEmpty) ...[
            SizedBox(height: 10),
            _buildNotesSection(),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isMonospace = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
              color: AppTheme.textSecondaryLight,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: isMonospace
                ? AppTheme.getMonospaceStyle(
                    isLight: true,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  )
                : AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                    color: AppTheme.textPrimaryLight,
                  ),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        ),
      ],
    );
  }

  Widget _buildSpecialRequestsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CustomIconWidget(
              iconName: 'restaurant_menu',
              color: AppTheme.warningLight,
              size: 20,
            ),
            SizedBox(width: 2),
            Text(
              'Special Requests',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimaryLight,
              ),
            ),
          ],
        ),
        SizedBox(height: 1),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: AppTheme.warningLight.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppTheme.warningLight.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Text(
            (reservation['specialRequests'] as String?) ?? '',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.textPrimaryLight,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNotesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CustomIconWidget(
              iconName: 'note',
              color: AppTheme.primaryLight,
              size: 20,
            ),
            SizedBox(width: 2),
            Text(
              'Notes',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimaryLight,
              ),
            ),
          ],
        ),
        SizedBox(height: 1),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: AppTheme.primaryLight.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppTheme.borderLight,
              width: 1,
            ),
          ),
          child: Text(
            (reservation['notes'] as String?) ?? '',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.textPrimaryLight,
            ),
          ),
        ),
      ],
    );
  }
}
