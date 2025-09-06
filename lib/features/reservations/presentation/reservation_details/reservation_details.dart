import 'package:flutter/material.dart';
import 'package:flutter_admin_dashboard/core/app_theme.dart';
import 'package:flutter_admin_dashboard/features/reservations/data/widgets/custom_icon_widget.dart';
import './widgets/action_buttons_section.dart';
import './widgets/guest_contact_section.dart';
import './widgets/modification_history_section.dart';
import './widgets/reservation_header_card.dart';
import './widgets/reservation_info_section.dart';

class ReservationDetails extends StatefulWidget {
  const ReservationDetails({Key? key}) : super(key: key);

  @override
  State<ReservationDetails> createState() => _ReservationDetailsState();
}

class _ReservationDetailsState extends State<ReservationDetails> {
  late Map<String, dynamic> reservation;

  @override
  void initState() {
    super.initState();
    _initializeReservationData();
  }

  void _initializeReservationData() {
    // Mock reservation data - in real app, this would come from navigation arguments or API
    reservation = {
      "id": 12345,
      "guestName": "Sarah Johnson",
      "phone": "+1 (555) 123-4567",
      "email": "sarah.johnson@email.com",
      "date": "January 15, 2025",
      "time": "7:30 PM",
      "partySize": 4,
      "status": "pending",
      "tableNumber": 12,
      "specialRequests": "Vegetarian options needed, celebrating anniversary",
      "notes": "Regular customer, prefers window seating",
      "bookingTimestamp": "January 5, 2025 at 10:30 AM",
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: _buildAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ReservationHeaderCard(reservation: reservation),
              GuestContactSection(reservation: reservation),
              ReservationInfoSection(reservation: reservation),
              ActionButtonsSection(
                reservation: reservation,
                onStatusChanged: _handleStatusChange,
              ),
              ModificationHistorySection(reservation: reservation),
              SizedBox(height: 4), // Bottom padding for better scrolling
            ],
          ),
        ),
      ),
      floatingActionButton: _buildEditFAB(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppTheme.primaryLight,
      elevation: 2,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: CustomIconWidget(
          iconName: 'arrow_back',
          color: Colors.white,
          size: 24,
        ),
      ),
      title: Text(
        'Reservation Details',
        style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: [
        IconButton(
          onPressed: _showMoreOptions,
          icon: CustomIconWidget(
            iconName: 'more_vert',
            color: Colors.white,
            size: 24,
          ),
        ),
      ],
    );
  }

  Widget _buildEditFAB() {
    return FloatingActionButton(
      onPressed: _editReservation,
      backgroundColor: AppTheme.accentLight,
      child: CustomIconWidget(
        iconName: 'edit',
        color: AppTheme.textPrimaryLight,
        size: 24,
      ),
    );
  }

  void _handleStatusChange(String newStatus) {
    setState(() {
      reservation['status'] = newStatus;
    });
  }

  void _editReservation() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        expand: false,
        builder: (context, scrollController) => Container(
          padding: EdgeInsets.all(4),
          child: Column(
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
                'Edit Reservation',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 3),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  children: [
                    _buildEditField(
                        'Guest Name', reservation['guestName'] as String),
                    SizedBox(height: 2),
                    _buildEditField('Phone', reservation['phone'] as String),
                    SizedBox(height: 2),
                    _buildEditField('Email', reservation['email'] as String),
                    SizedBox(height: 2),
                    _buildEditField(
                        'Party Size', reservation['partySize'].toString()),
                    SizedBox(height: 2),
                    _buildEditField('Special Requests',
                        reservation['specialRequests'] as String,
                        maxLines: 3),
                    SizedBox(height: 2),
                    _buildEditField('Notes', reservation['notes'] as String,
                        maxLines: 3),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text('Cancel'),
                          ),
                        ),
                        SizedBox(width: 4),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              _showSaveConfirmation();
                            },
                            child: Text('Save Changes'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEditField(String label, String value, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
            color: AppTheme.textSecondaryLight,
          ),
        ),
        SizedBox(height: 1),
        TextFormField(
          initialValue: value,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: 'Enter $label',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }

  void _showSaveConfirmation() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Reservation updated successfully',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: Colors.white,
          ),
        ),
        backgroundColor: AppTheme.successLight,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  void _showMoreOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
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
              'More Options',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 3),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'print',
                color: AppTheme.primaryLight,
                size: 24,
              ),
              title: Text(
                'Print Details',
                style: AppTheme.lightTheme.textTheme.bodyLarge,
              ),
              onTap: () {
                Navigator.pop(context);
                _printReservation();
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'download',
                color: AppTheme.primaryLight,
                size: 24,
              ),
              title: Text(
                'Export to PDF',
                style: AppTheme.lightTheme.textTheme.bodyLarge,
              ),
              onTap: () {
                Navigator.pop(context);
                _exportToPDF();
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'delete',
                color: AppTheme.errorLight,
                size: 24,
              ),
              title: Text(
                'Delete Reservation',
                style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                  color: AppTheme.errorLight,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                _showDeleteConfirmation();
              },
            ),
            SizedBox(height: 2),
          ],
        ),
      ),
    );
  }

  void _printReservation() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Print functionality would be implemented here'),
        backgroundColor: AppTheme.primaryLight,
      ),
    );
  }

  void _exportToPDF() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('PDF export functionality would be implemented here'),
        backgroundColor: AppTheme.primaryLight,
      ),
    );
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Delete Reservation',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.errorLight,
          ),
        ),
        content: Text(
          'Are you sure you want to delete this reservation? This action cannot be undone.',
          style: AppTheme.lightTheme.textTheme.bodyLarge,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                color: AppTheme.textSecondaryLight,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context); // Return to previous screen
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Reservation deleted'),
                  backgroundColor: AppTheme.errorLight,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorLight,
            ),
            child: Text(
              'Delete',
              style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
