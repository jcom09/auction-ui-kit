import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/colors.dart';
import 'custom_burger_icon.dart'; // Import created in Step 1

class StandardNavBar extends StatefulWidget implements PreferredSizeWidget {
  final VoidCallback? onLogin;
  final VoidCallback? onSignUp; // Kept for backward compatibility but unused
  final VoidCallback? onHome; // Kept for backward compatibility but unused
  final bool showAuthButtons; // Kept for backward compatibility but unused

  const StandardNavBar({
    super.key,
    this.onLogin,
    this.onSignUp,
    this.onHome,
    this.showAuthButtons = true,
  });

  @override
  State<StandardNavBar> createState() => _StandardNavBarState();

  @override
  Size get preferredSize => const Size.fromHeight(80); // Was 81 // Base height
}

class _StandardNavBarState extends State<StandardNavBar> {
  int _hoveringIndex = -1; // -1 means nothing is hovered

  static const List<Map<String, String>> _navItems = [
    {"label": "Home", "url": "https://carpear.com.au"},
    {"label": "Sell My Car", "url": "https://sellmycar.carpear.com.au"},
    {"label": "Dealers", "url": "https://dealers.carpear.com.au"},
    {"label": "Blog", "url": "https://carpear.com.au/blog/"},
    {"label": "Contact Us", "url": "https://carpear.com.au/contact-us/"},
  ];

  static Future<void> _launchURL(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      debugPrint('Could not launch $urlString');
    }
  }

  void _showMobileMenu(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false, // Transparent so it overlays current screen
        pageBuilder: (context, animation, secondaryAnimation) {
          return _MobileMenuOverlay(
            navItems: _navItems,
            onClose: () => Navigator.of(context).pop(),
            onLaunchUrl: _launchURL,
          );
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 800;

    return Container(
      height: 64, // Fixed height for navbar, no more dynamic expansion
      alignment: Alignment.topCenter,
      decoration: BoxDecoration(
        color: AppColors.offWhite,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Container(
          height: 64, // Inner content height matches previous requirement
          padding: const EdgeInsets.symmetric(horizontal: 24),
          alignment: Alignment.center,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Logo
              InkWell(
                onTap: () => _launchURL('https://carpear.com.au'),
                child: Image.asset(
                  'assets/images/CarPear.png',
                  package: 'auction_ui_kit',
                  height: 35,
                  fit: BoxFit.contain,
                ),
              ),

              const Spacer(),

              // DESKTOP NAV
              if (isDesktop)
                Row(
                  children: List.generate(_navItems.length, (index) {
                    final isHovering = _hoveringIndex == index;
                    return MouseRegion(
                      onEnter: (_) => setState(() => _hoveringIndex = index),
                      onExit: (_) {
                        if (_hoveringIndex == index) {
                          setState(() => _hoveringIndex = -1);
                        }
                      },
                      child: InkWell(
                        onTap: () => _launchURL(_navItems[index]['url']!),
                        hoverColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        child: Container(
                          height: 80, // Full height hit area
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 50),
                            style: TextStyle(
                              color: AppColors.deepGreen,
                              fontWeight: isHovering
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                              fontSize: isHovering ? 18 : 16,
                            ),
                            child: Text(_navItems[index]['label']!),
                          ),
                        ),
                      ),
                    );
                  }),
                )
              // MOBILE BURGER TRIGGER
              else
                CustomBurgerIcon(
                  isOpen:
                      false, // Standard navbar icon is always the menu (closed) state
                  onTap: () => _showMobileMenu(context),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MobileMenuOverlay extends StatefulWidget {
  final List<Map<String, String>> navItems;
  final VoidCallback onClose;
  final Future<void> Function(String) onLaunchUrl;

  const _MobileMenuOverlay({
    required this.navItems,
    required this.onClose,
    required this.onLaunchUrl,
  });

  @override
  State<_MobileMenuOverlay> createState() => _MobileMenuOverlayState();
}

class _MobileMenuOverlayState extends State<_MobileMenuOverlay> {
  // Start the icon as true (X state) when overlay mounts
  bool _isOpenState = true;

  void _handleClose() {
    setState(() => _isOpenState = false);
    // Add small delay to let the burger icon animate back before route pops
    Future.delayed(const Duration(milliseconds: 150), () {
      widget.onClose();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.offWhite, // Solid background covers screen
      body: SafeArea(
        child: Column(
          children: [
            // Header row to match the visual layout of the standard nav bar
            Container(
              height: 64, // Same height as standard nav inner content
              padding: const EdgeInsets.symmetric(horizontal: 24),
              alignment: Alignment.center,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Logo
                  InkWell(
                    onTap: () {
                      _handleClose();
                      widget.onLaunchUrl('https://carpear.com.au');
                    },
                    child: Image.asset(
                      'assets/images/CarPear.png',
                      package: 'auction_ui_kit',
                      height: 35,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const Spacer(),
                  // X Close Icon
                  CustomBurgerIcon(
                    isOpen: _isOpenState,
                    onTap: _handleClose,
                  ),
                ],
              ),
            ),

            // Menu Items List pushing downwards
            Expanded(
              child: ListView.builder(
                padding:
                    const EdgeInsets.only(top: 20), // Spacing below fake header
                itemCount: widget.navItems.length,
                itemBuilder: (context, index) {
                  final item = widget.navItems[index];
                  return Material(
                    color: Colors.transparent, // Supports Ripple Effect
                    child: InkWell(
                      onTap: () {
                        _handleClose();
                        widget.onLaunchUrl(item['url']!);
                      },
                      child: Container(
                        width: double.infinity, // Massive tap width
                        padding: const EdgeInsets.symmetric(
                            vertical: 24), // Generous tap height
                        alignment: Alignment
                            .center, // Center text container horizontally
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.grey.withValues(alpha: 0.1),
                            ),
                          ),
                        ),
                        child: Text(
                          item['label']!,
                          textAlign: TextAlign.center, // Perfect text centering
                          style: TextStyle(
                            fontSize:
                                22, // Slightly larger for full screen overlay
                            fontWeight: FontWeight.w600,
                            color: AppColors.deepGreen,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
