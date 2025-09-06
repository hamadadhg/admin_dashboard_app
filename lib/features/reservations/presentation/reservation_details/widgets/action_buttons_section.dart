import 'package:flutter/material.dart';
import 'package:flutter_admin_dashboard/core/app_theme.dart';
import 'package:flutter_admin_dashboard/features/reservations/data/widgets/custom_icon_widget.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ActionButtonsSection extends StatefulWidget {
  final Map<String, dynamic> reservation;
  final Function(String) onStatusChanged;

  const ActionButtonsSection({
    Key? key,
    required this.reservation,
    required this.onStatusChanged,
  }) : super(key: key);

  @override
  State<ActionButtonsSection> createState() => _ActionButtonsSectionState();
}

class _ActionButtonsSectionState extends State<ActionButtonsSection> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final String currentStatus =
        (widget.reservation['status'] as String?) ?? 'pending';

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      child: Column(
        children: [
          if (currentStatus == 'pending') ...[
            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    label: 'Confirm',
                    icon: 'check_circle',
                    color: AppTheme.successLight,
                    onPressed: _isLoading
                        ? null
                        : () => _showConfirmationDialog('confirmed'),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: _buildActionButton(
                    label: 'Reject',
                    icon: 'cancel',
                    color: AppTheme.errorLight,
                    onPressed: _isLoading
                        ? null
                        : () => _showConfirmationDialog('rejected'),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
          ],
          if (currentStatus == 'confirmed') ...[
            _buildActionButton(
              label: 'Cancel Reservation',
              icon: 'close',
              color: AppTheme.errorLight,
              onPressed:
                  _isLoading ? null : () => _showConfirmationDialog('canceled'),
              isFullWidth: true,
            ),
            SizedBox(height: 10),
          ],
          _buildActionButton(
            label: 'Show Details',
            icon: 'share',
            color: AppTheme.primaryLight,
            onPressed: _isLoading ? null : _shareReservationDetails,
            isFullWidth: true,
            isOutlined: true,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required String icon,
    required Color color,
    required VoidCallback? onPressed,
    bool isFullWidth = false,
    bool isOutlined = false,
  }) {
    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      height: 50,
      child: isOutlined
          ? OutlinedButton.icon(
              onPressed: onPressed,
              icon: _isLoading
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(color),
                      ),
                    )
                  : CustomIconWidget(
                      iconName: icon,
                      color: color,
                      size: 20,
                    ),
              label: Text(
                label,
                style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: color, width: 2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            )
          : ElevatedButton.icon(
              onPressed: onPressed,
              icon: _isLoading
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: const CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : CustomIconWidget(
                      iconName: icon,
                      color: Colors.white,
                      size: 20,
                    ),
              label: Text(
                label,
                style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
    );
  }

  void _showConfirmationDialog(String newStatus) {
    String title;
    String message;
    Color actionColor;

    switch (newStatus) {
      case 'confirmed':
        title = 'Confirm Reservation';
        message = 'Are you sure you want to confirm this reservation?';
        actionColor = AppTheme.successLight;
        break;
      case 'rejected':
        title = 'Reject Reservation';
        message = 'Are you sure you want to reject this reservation?';
        actionColor = AppTheme.errorLight;
        break;
      case 'canceled':
        title = 'Cancel Reservation';
        message = 'Are you sure you want to cancel this reservation?';
        actionColor = AppTheme.errorLight;
        break;
      default:
        return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            title,
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Text(
            message,
            style: AppTheme.lightTheme.textTheme.bodyLarge,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                  color: AppTheme.textSecondaryLight,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _updateReservationStatus(newStatus);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: actionColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Confirm',
                style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _updateReservationStatus(String newStatus) async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      widget.onStatusChanged(newStatus);

      String successMessage;
      switch (newStatus) {
        case 'confirmed':
          successMessage = 'Reservation confirmed successfully';
          break;
        case 'rejected':
          successMessage = 'Reservation rejected';
          break;
        case 'canceled':
          successMessage = 'Reservation canceled';
          break;
        default:
          successMessage = 'Status updated';
      }

      Fluttertoast.showToast(
        msg: successMessage,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: AppTheme.successLight,
        textColor: Colors.white,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Failed to update reservation status',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: AppTheme.errorLight,
        textColor: Colors.white,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _shareReservationDetails() {
    final reservation = widget.reservation;
    final String shareText = '''
Reservation Details:
Guest: ${reservation['guestName'] ?? 'Unknown'}
Date: ${reservation['date'] ?? 'N/A'}
Time: ${reservation['time'] ?? 'N/A'}
Party Size: ${reservation['partySize'] ?? 0} guests
Status: ${reservation['status'] ?? 'Unknown'}
Phone: ${reservation['phone'] ?? 'N/A'}
Email: ${reservation['email'] ?? 'N/A'}
''';

    // For demo purposes, show the share text in a dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Share Reservation',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        content: SingleChildScrollView(
          child: Text(
            shareText,
            style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Close',
              style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                color: AppTheme.primaryLight,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
