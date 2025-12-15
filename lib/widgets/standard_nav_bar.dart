import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/colors.dart';

class StandardNavBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onLogin;
  final VoidCallback? onSignUp; // Kept for backward compatibility but unused
  final VoidCallback? onHome;   // Kept for backward compatibility but unused
  final bool showAuthButtons;   // Kept for backward compatibility but unused

  const StandardNavBar({
    super.key,
    this.onLogin,
    this.onSignUp,
    this.onHome,
    this.showAuthButtons = true,
  });

  @override
  Size get preferredSize => const Size.fromHeight(70);

  Future<void> _launch(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.platformDefault)) {
       debugPrint('Could not launch $url');
    }
  }

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
          // Logo -> https://www.domain.com.au
          InkWell(
            onTap: () => _launch('https://www.domain.com.au'),
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
          
          const Spacer(), // Push content to the right

          if (isDesktop) ...[
            _NavLink(label: "Sell My Car", onTap: () => _launch('https://sellmycar.domain.com.au')),
            const SizedBox(width: 24),
            _NavLink(label: "Buy A Car", onTap: () => _launch('https://buyacar.domain.com.au')),
            const SizedBox(width: 24),
            _NavLink(label: "Dealers", onTap: () => _launch('https://dealers.domain.com.au')),
            const SizedBox(width: 24),
            _NavLink(label: "Blog", onTap: () => _launch('https://www.domain.com.au/blog')),
            const SizedBox(width: 24),
            _NavLink(label: "Contact Us", onTap: () => _launch('https://www.domain.com.au/contact')),
          ]
        ],
      ),
      // No actions/auth buttons as requested
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
            color: Colors.grey[800], // Black/Dark Grey
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
