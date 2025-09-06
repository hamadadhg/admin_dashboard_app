import 'package:flutter/material.dart';
import 'package:flutter_admin_dashboard/features/reservations/presentation/views/widgets/custom_reservations_view_body.dart';

class ReservationsView extends StatelessWidget {
  const ReservationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: CustomReservationsViewBody(),
    );
  }
}
