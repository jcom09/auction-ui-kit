import 'package:flutter/material.dart';

class StandardFooter extends StatelessWidget {
  final VoidCallback? onPrivacyPolicy;
  final VoidCallback? onTermsOfUse;
  final VoidCallback? onContactSupport;

  const StandardFooter({
    super.key,
    this.onPrivacyPolicy,
    this.onTermsOfUse,
    this.onContactSupport,
  });

  @override
  Widget build(BuildContext context) {
    // Breakpoint for desktop/mobile
    final isDesktop = MediaQuery.of(context).size.width > 800;

    return Container(
      width: double.infinity,
      color: Colors.grey[100],
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
      child: isDesktop ? _buildDesktopLayout() : _buildMobileLayout(),
    );
  }

  Widget _buildDesktopLayout() {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 1200),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left: Logo
          _FooterLogo(),
          const SizedBox(width: 32),

          // Middle: Copyright (Expanded to fill space if needed, or just centered?)
          // User asked for: Left: Logo, Middle: Copyright, Right: Links.
          // To achieve this cleanly:
          const Spacer(),
          const Text(
            "© 2025 CarMatch. All rights reserved.",
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
          const Spacer(),

          // Right: Links
          _FooterLinks(
              onPrivacy: onPrivacyPolicy,
              onTerms: onTermsOfUse,
              onContact: onContactSupport),
        ],
      ),
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _FooterLogo(),
        const SizedBox(height: 24),
        const Text(
          "© 2025 CarMatch. All rights reserved.",
          style: TextStyle(color: Colors.grey, fontSize: 14),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        _FooterLinks(
          onPrivacy: onPrivacyPolicy,
          onTerms: onTermsOfUse,
          onContact: onContactSupport,
          isVertical: true,
        ),
      ],
    );
  }
}

class _FooterLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.local_taxi, size: 24, color: Colors.grey),
        const SizedBox(width: 8),
        Text(
          "CarMatch",
          style: TextStyle(
            color: Colors.grey[800],
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ],
    );
  }
}

class _FooterLinks extends StatelessWidget {
  final VoidCallback? onPrivacy;
  final VoidCallback? onTerms;
  final VoidCallback? onContact;
  final bool isVertical;

  const _FooterLinks({
    this.onPrivacy,
    this.onTerms,
    this.onContact,
    this.isVertical = false,
  });

  @override
  Widget build(BuildContext context) {
    // Links list
    final links = [
      _LinkItem("Privacy Policy", onPrivacy),
      _LinkItem("Terms of Use", onTerms),
      _LinkItem("Contact Support", onContact),
    ];

    if (isVertical) {
      return Column(
        children: links
            .map((l) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: l,
                ))
            .toList(),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        links[0],
        const SizedBox(width: 24),
        links[1],
        const SizedBox(width: 24),
        links[2],
      ],
    );
  }
}

class _LinkItem extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;

  const _LinkItem(this.label, this.onTap);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Text(
        label,
        style: TextStyle(
          color: Colors.grey[700],
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
