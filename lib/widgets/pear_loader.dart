import 'dart:math' as math;
import 'package:flutter/material.dart';
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
                          'assets/images/carpear_logo_light.png',
                          package: 'auction_ui_kit',
                          height: pearHeight,
                          fit: BoxFit.contain,
                          color: Colors.grey.withValues(alpha: 0.3),
                          colorBlendMode: BlendMode.srcIn,
                        ),

                        // LAYER 2: The Liquid Fill (Animated Wave Mask)
                        ClipPath(
                          clipper: LiquidClipper(
                            fillLevel:
                                _controller.value, // Fills from 0.0 to 1.0
                            wavePhase: _controller.value *
                                2 *
                                math.pi *
                                2, // 2 full waves per animation cycle
                          ),
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Image.asset(
                              'assets/images/carpear_logo_light.png',
                              package: 'auction_ui_kit',
                              height: pearHeight,
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

class LiquidClipper extends CustomClipper<Path> {
  final double fillLevel;
  final double wavePhase;

  LiquidClipper({required this.fillLevel, required this.wavePhase});

  @override
  Path getClip(Size size) {
    final path = Path();
    final double amplitude = 20.0; // Height of the wave
    // Y coordinate of the liquid surface (0.0 is top, size.height is bottom)
    final double baseHeight = size.height * (1.0 - fillLevel);

    path.moveTo(0.0, size.height); // Bottom-left corner
    path.lineTo(0.0, baseHeight); // Up to the liquid level

    // Draw the sine wave across the width of the image
    for (double x = 0.0; x <= size.width; x += 1) {
      double y = baseHeight +
          math.sin((x / size.width * 2 * math.pi) + wavePhase) * amplitude;
      path.lineTo(x, y);
    }

    path.lineTo(size.width, size.height); // Down to bottom-right corner
    path.close();
    return path;
  }

  @override
  bool shouldReclip(LiquidClipper oldClipper) {
    return oldClipper.fillLevel != fillLevel ||
        oldClipper.wavePhase != wavePhase;
  }
}
