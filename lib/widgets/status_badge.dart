import 'package:flutter/material.dart';
import '../theme/status_styles.dart';

class AuctionStatusBadge extends StatelessWidget {
  final String status;
  const AuctionStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final color = AuctionStatusTheme.getStatusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Text(
        AuctionStatusTheme.getStatusLabel(status),
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
