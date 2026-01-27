import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
  Size get preferredSize => const Size.fromHeight(80); // Base height
}

class _StandardNavBarState extends State<StandardNavBar> {
  int _hoveringIndex = -1; // -1 means nothing is hovered
  bool _isMenuOpen = false;

  final List<Map<String, String>> _navItems = [
    {"label": "Sell My Car", "url": "https://sellmycar.domain.com.au"},
    {"label": "Buy A Car", "url": "https://buyacar.domain.com.au"},
    {"label": "Dealers", "url": "https://dealers.domain.com.au"},
    {"label": "Blog", "url": "https://www.domain.com.au/blog"},
    {"label": "Contact Us", "url": "https://www.domain.com.au/contact"},
  ];

  Future<void> _launch(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.platformDefault)) {
      debugPrint('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 800;

    // Close menu if switching to desktop
    if (isDesktop && _isMenuOpen) {
      // Schedule microtask to avoid setState during build if this happens repeatedly
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _isMenuOpen = false;
          });
        }
      });
    }

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFE0E0E0),
            width: 1,
            style: BorderStyle.none,
          ),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 1. HEADER ROW (Logo + Burger/Nav)
            Container(
              height: 80, // Maintain 80px height for the bar itself
              padding: const EdgeInsets.symmetric(horizontal: 24),
              alignment: Alignment.center,
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  // Base Line Animation (Desktop)
                  if (isDesktop)
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        height: 2,
                        color: _hoveringIndex == -1
                            ? AppColors.deepGreen
                            : Colors.transparent,
                      ),
                    ),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Logo
                      InkWell(
                        onTap: () => _launch('https://www.domain.com.au'),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.local_taxi,
                                color: AppColors.primary, size: 32),
                            const SizedBox(width: 8),
                            const Text(
                              "CarPear",
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

                      const Spacer(),

                      // DESKTOP NAV
                      if (isDesktop)
                        Row(
                          children: List.generate(_navItems.length, (index) {
                            final isHovering = _hoveringIndex == index;
                            return MouseRegion(
                              onEnter: (_) =>
                                  setState(() => _hoveringIndex = index),
                              onExit: (_) {
                                if (_hoveringIndex == index) {
                                  setState(() => _hoveringIndex = -1);
                                }
                              },
                              child: InkWell(
                                onTap: () => _launch(_navItems[index]['url']!),
                                hoverColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                child: Container(
                                  height: 80, // Full height for hit area/border
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: isHovering
                                            ? AppColors.deepGreen
                                            : Colors.transparent,
                                        width: 3,
                                      ),
                                    ),
                                  ),
                                  child: AnimatedDefaultTextStyle(
                                    duration: const Duration(milliseconds: 200),
                                    style: GoogleFonts.poppins(
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
                      // MOBILE BURGER
                      else
                        CustomBurgerIcon(
                          isOpen: _isMenuOpen,
                          onTap: () {
                            setState(() {
                              _isMenuOpen = !_isMenuOpen;
                            });
                          },
                        ),
                    ],
                  ),
                ],
              ),
            ),

            // 2. MOBILE MENU DROPDOWN
            // AnimatedSize handles the smooth slide down/up
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              alignment: Alignment.topCenter,
              child: Container(
                width: double.infinity,
                // Only show content height if open.
                // However AnimatedSize needs the child to change size.
                // We use constraints or visibility logic.
                constraints: BoxConstraints(
                  maxHeight: (_isMenuOpen && !isDesktop) ? 1000 : 0,
                ),
                color: AppColors.cream, // Background for the menu
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(_navItems.length, (index) {
                      // ALTERNATING COLORS:
                      final bgColor = index.isEven
                          ? AppColors.pearGreen.withValues(alpha: 0.15)
                          : AppColors.deepGreen.withValues(alpha: 0.05);

                      return MobileMenuItem(
                        title: _navItems[index]['label']!,
                        backgroundColor: bgColor,
                        onTap: () {
                          _launch(_navItems[index]['url']!);
                          setState(() {
                            _isMenuOpen = false;
                          });
                        },
                      );
                    }),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MobileMenuItem extends StatefulWidget {
  final String title;
  final Color backgroundColor;
  final VoidCallback onTap;

  const MobileMenuItem({
    super.key,
    required this.title,
    required this.backgroundColor,
    required this.onTap,
  });

  @override
  State<MobileMenuItem> createState() => _MobileMenuItemState();
}

class _MobileMenuItemState extends State<MobileMenuItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
          decoration: BoxDecoration(
            color: widget
                .backgroundColor, // Optional: Darken background slightly on hover
            border: _isHovered
                ? const Border(
                    left: BorderSide(color: AppColors.deepGreen, width: 4))
                : Border.all(color: Colors.transparent),
          ),
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOutBack,
            style: GoogleFonts.poppins(
              // SCALE EFFECT: 18 -> 22
              fontSize: _isHovered ? 22 : 18,
              fontWeight: _isHovered ? FontWeight.w600 : FontWeight.w500,
              color: AppColors.deepGreen,
            ),
            child: Text(widget.title),
          ),
        ),
      ),
    );
  }
}
