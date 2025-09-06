import 'package:flutter/material.dart';
import 'package:flutter_admin_dashboard/features/reservations/presentation/reservation_details/reservation_details.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String reservationDetails = '/reservation-details';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const ReservationDetails(),
    reservationDetails: (context) => const ReservationDetails(),
    // TODO: Add your other routes here
  };
}
