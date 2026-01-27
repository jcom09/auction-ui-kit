import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/colors.dart';

class PearLoadingOverlay extends StatefulWidget {
  const PearLoadingOverlay({super.key});

  @override
  State<PearLoadingOverlay> createState() => _PearLoadingOverlayState();
}

class _PearLoadingOverlayState extends State<PearLoadingOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: AppColors.cream.withValues(alpha: 0.9), // Full screen blocking
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Stack for Liquid Fill Animation
          Builder(
            builder: (context) {
              final double pearHeight =
                  MediaQuery.of(context).size.height * 0.3;
              return SizedBox(
                height: pearHeight,
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        // LAYER 1: The "Empty" Shadow (Static Background)
                        Image.asset(
                          'assets/images/pear_logo.png',
                          package: 'auction_ui_kit',
                          height: pearHeight,
                          fit: BoxFit.contain,
                          color: Colors.grey.withValues(alpha: 0.3),
                          colorBlendMode: BlendMode.srcIn,
                        ),

                        // LAYER 2: The Liquid Fill (Static Image, Animated Mask)
                        ClipRect(
                          child: Align(
                            alignment: Alignment
                                .bottomCenter, // Anchor the mask to the bottom
                            heightFactor:
                                _controller.value, // 0.0 = Empty, 1.0 = Full
                            child: Image.asset(
                              'assets/images/pear_logo.png',
                              package: 'auction_ui_kit',
                              height:
                                  pearHeight, // MUST be same height as Layer 1 to align pixels
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
