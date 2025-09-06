import 'package:flutter/material.dart';
import 'package:flutter_admin_dashboard/core/app_theme.dart';
import 'package:flutter_admin_dashboard/features/reservations/data/widgets/custom_icon_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class GuestContactSection extends StatelessWidget {
  final Map<String, dynamic> reservation;

  const GuestContactSection({
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
            'Contact Information',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimaryLight,
            ),
          ),
          SizedBox(height: 10),
          _buildContactItem(
            icon: 'phone',
            label: 'Phone',
            value: (reservation['phone'] as String?) ?? 'No phone provided',
            onTap: reservation['phone'] != null
                ? () => _makePhoneCall(reservation['phone'] as String)
                : null,
            onLongPress: reservation['phone'] != null
                ? () =>
                    _showPhoneOptions(context, reservation['phone'] as String)
                : null,
          ),
          SizedBox(height: 5),
          _buildContactItem(
            icon: 'email',
            label: 'Email',
            value: (reservation['email'] as String?) ?? 'No email provided',
            onTap: reservation['email'] != null
                ? () => _sendEmail(reservation['email'] as String)
                : null,
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem({
    required String icon,
    required String label,
    required String value,
    VoidCallback? onTap,
    VoidCallback? onLongPress,
  }) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 1),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: AppTheme.primaryLight.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: CustomIconWidget(
                iconName: icon,
                color: AppTheme.primaryLight,
                size: 20,
              ),
            ),
            SizedBox(width: 3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                      color: AppTheme.textSecondaryLight,
                    ),
                  ),
                  SizedBox(height: 0.5),
                  Text(
                    value,
                    style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                      color: onTap != null
                          ? AppTheme.primaryLight
                          : AppTheme.textPrimaryLight,
                      decoration:
                          onTap != null ? TextDecoration.underline : null,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (onTap != null)
              CustomIconWidget(
                iconName: 'arrow_forward_ios',
                color: AppTheme.textSecondaryLight,
                size: 16,
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    }
  }

  Future<void> _sendEmail(String email) async {
    final Uri emailUri = Uri(scheme: 'mailto', path: email);
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    }
  }

  void _showPhoneOptions(BuildContext context, String phoneNumber) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12,
              height: 0.5,
              decoration: BoxDecoration(
                color: AppTheme.borderLight,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 2),
            Text(
              phoneNumber,
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 3),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'phone',
                color: AppTheme.primaryLight,
                size: 24,
              ),
              title: Text(
                'Call',
                style: AppTheme.lightTheme.textTheme.bodyLarge,
              ),
              onTap: () {
                Navigator.pop(context);
                _makePhoneCall(phoneNumber);
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'message',
                color: AppTheme.primaryLight,
                size: 24,
              ),
              title: Text(
                'Send SMS',
                style: AppTheme.lightTheme.textTheme.bodyLarge,
              ),
              onTap: () {
                Navigator.pop(context);
                _sendSMS(phoneNumber);
              },
            ),
            SizedBox(height: 2),
          ],
        ),
      ),
    );
  }

  Future<void> _sendSMS(String phoneNumber) async {
    final Uri smsUri = Uri(scheme: 'sms', path: phoneNumber);
    if (await canLaunchUrl(smsUri)) {
      await launchUrl(smsUri);
    }
  }
}
