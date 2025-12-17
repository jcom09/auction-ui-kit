import 'package:flutter/material.dart';

class AuctionLoadingSpinner extends StatelessWidget {
  final String? message;

  const AuctionLoadingSpinner({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(
            // Use the theme's primary color, assuming it's set to purple in the main app theme.
            // If explicit color is needed: color: Colors.purple,
          ),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
          ],
        ],
      ),
    );
  }
}
