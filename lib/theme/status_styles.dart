import 'package:flutter/material.dart';

class AuctionStatusTheme {
  static Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.blue.shade700;
      case 'auction_ready':
        return Colors.teal.shade600;
      case 'sold':
        return Colors.green.shade700;
      case 'not_sold':
        return Colors.orange.shade800;
      case 'rejected':
        return Colors.red.shade700;
      case 'offer_declined':
        return Colors.red.shade700;
      case 'live':
        return Colors.green.shade600;
      case 'offer_accepted':
        return Colors.green.shade700;
      case 'ended':
        return Colors.grey.shade600;
      default:
        return Colors.blueGrey;
    }
  }

  static String getStatusLabel(String status) {
    return status.toUpperCase().replaceAll('_', ' ');
  }
}
