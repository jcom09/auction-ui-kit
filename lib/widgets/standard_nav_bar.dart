import 'package:flutter/material.dart';
import '../theme/colors.dart';

class StandardNavBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onLogin;
  final VoidCallback? onSignUp;
  final VoidCallback? onHome;
  final bool showAuthButtons;

  const StandardNavBar({
    super.key,
    this.onLogin,
    this.onSignUp,
    this.onHome,
    this.showAuthButtons = true,
  });

  @override
  Size get preferredSize => const Size.fromHeight(70);

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 800;

    return AppBar(
      toolbarHeight: 70,
      backgroundColor: AppColors.surface,
      elevation: 0,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          color: Colors.grey.shade100,
          height: 1,
        ),
      ),
      title: Row(
        children: [
          // Basic Logo
          InkWell(
            onTap: onHome,
            child: Row(
              children: [
                const Icon(Icons.local_taxi, color: AppColors.primary, size: 32),
                const SizedBox(width: 8),
                const Text(
                  "CarMatch",
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w900,
                    fontSize: 24,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
          
          if (isDesktop) ...[
            const SizedBox(width: 48),
            _NavLink(label: "Home", onTap: onHome),
            const SizedBox(width: 24),
            _NavLink(label: "Auctions", onTap: () {}), // Placeholder
            const SizedBox(width: 24),
            _NavLink(label: "Contact Us", onTap: () {}), // Placeholder
          ]
        ],
      ),
      actions: [
        if (showAuthButtons && isDesktop) ...[
          TextButton(
            onPressed: onLogin,
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primary,
              textStyle: const TextStyle(fontWeight: FontWeight.bold),
            ),
            child: const Text("Log In"),
          ),
          const SizedBox(width: 16),
          ElevatedButton(
            onPressed: onSignUp,
            child: const Text("Sign Up"),
          ),
          const SizedBox(width: 24),
        ]
      ],
    );
  }
}

class _NavLink extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;

  const _NavLink({required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Text(
          label,
          style: TextStyle(
            color: Colors.grey[800],
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
