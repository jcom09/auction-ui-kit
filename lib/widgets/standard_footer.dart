import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../theme/colors.dart';
import 'standard_nav_bar.dart';

class StandardFooter extends StatelessWidget {
  const StandardFooter({super.key});

  /// [windowName] defaults to '_self' (same tab). Pass '_blank' for social links
  /// that should open externally without disrupting in-app navigation.
  Future<void> _launchURL(String urlString, {String windowName = '_self'}) async {
    final uri = Uri.parse(urlString);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, webOnlyWindowName: windowName);
    } else {
      debugPrint('Could not launch $urlString');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.offWhite,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      padding: const EdgeInsets.only(top: 60, bottom: 32, left: 24, right: 24),
      child: Builder(
        builder: (context) {
          final isDesktop = MediaQuery.of(context).size.width > 800;

          return Column(
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: isDesktop
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildBrandColumn(context, isDesktop),
                          _buildQuickLinksColumn(context),
                          _buildLegalColumn(context),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildBrandColumn(context, isDesktop),
                          const SizedBox(height: 40),
                          _buildQuickLinksColumn(context),
                          const SizedBox(height: 40),
                          _buildLegalColumn(context),
                        ],
                      ),
              ),
              const SizedBox(height: 60),
              Divider(
                color: AppColors.deepGreen.withValues(alpha: 0.1),
                height: 1,
              ),
              const SizedBox(height: 24),
              Text(
                "© ${DateTime.now().year} CarPear. All rights reserved. • ABN: 75 900 374 146",
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.deepGreen.withValues(alpha: 0.4),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBrandColumn(BuildContext context, bool isDesktop) {
    final landing = getDynamicLandingUrl();
    return Column(
      crossAxisAlignment:
          isDesktop ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        InkWell(
          onTap: () => _launchURL(landing),
          child: Image.asset(
            'assets/images/CarPear_Logo_Primary.png',
            package: 'auction_ui_kit',
            height: 100,
            fit: BoxFit.contain,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          constraints: const BoxConstraints(maxWidth: 300),
          child: Text(
            "Sell your car the modern way. Verified dealers compete — you win.",
            textAlign: isDesktop ? TextAlign.left : TextAlign.center,
            style: TextStyle(
              color: AppColors.deepGreen.withValues(alpha: 0.8),
              fontSize: 16,
              height: 1.5,
            ),
          ),
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildSocialIcon(
                FontAwesomeIcons.instagram,
                'https://www.instagram.com/carpear?igsh=NWd5bXB4aTNnN3k%3D'),
            const SizedBox(width: 8),
            _buildSocialIcon(
                FontAwesomeIcons.facebook,
                'https://www.facebook.com/profile.php?id=61589870814581'),
            const SizedBox(width: 8),
            _buildSocialIcon(
                FontAwesomeIcons.tiktok,
                'https://www.tiktok.com/@carpear_'),
          ],
        ),
      ],
    );
  }

  Widget _buildSocialIcon(FaIconData icon, String url) {
    return IconButton(
      icon: FaIcon(icon, color: AppColors.deepGreen),
      // Social links always open in a new tab
      onPressed: () => _launchURL(url, windowName: '_blank'),
    );
  }

  Widget _buildQuickLinksColumn(BuildContext context) {
    final landing = getDynamicLandingUrl();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Quick Links",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.deepGreen,
          ),
        ),
        const SizedBox(height: 16),
        _buildFooterLink("Home", landing),
        _buildFooterLink("Sell My Car", "$landing/sellmycar/"),
        _buildFooterLink("Dealers", "$landing/dealers/"),
        _buildFooterLink("Blog", "$landing/blog/"),
        _buildFooterLink("Contact Us", "$landing/contact-us/"),
      ],
    );
  }

  Widget _buildLegalColumn(BuildContext context) {
    final landing = getDynamicLandingUrl();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Legal",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.deepGreen,
          ),
        ),
        const SizedBox(height: 16),
        _buildFooterLink("Terms & Conditions", "$landing/terms/"),
        _buildFooterLink("Privacy Policy", "$landing/privacy/"),
        _buildFooterLink("Cookie Policy", "$landing/cookie-policy/"),
      ],
    );
  }

  Widget _buildFooterLink(String title, String url) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _launchURL(url),
        hoverColor: Colors.transparent,
        child: Text(
          title,
          style: TextStyle(
            color: AppColors.deepGreen.withValues(alpha: 0.8),
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
