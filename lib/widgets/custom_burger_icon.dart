import 'package:flutter/material.dart';
import '../theme/colors.dart';

class CustomBurgerIcon extends StatefulWidget {
  final bool isOpen;
  final VoidCallback onTap;

  const CustomBurgerIcon({
    super.key,
    required this.isOpen,
    required this.onTap,
  });

  @override
  State<CustomBurgerIcon> createState() => _CustomBurgerIconState();
}

class _CustomBurgerIconState extends State<CustomBurgerIcon> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      behavior: HitTestBehavior
          .opaque, // Ensures the entire 32x32 area is tappable, not just the painted lines
      child: SizedBox(
        width:
            32, // Overall bounding box width matching Lucide React Menu/X icon size
        height:
            32, // Overall bounding box height matching Lucide React Menu/X icon size
        child: Stack(
          children: [
            // Bar 1 (Top / Top-Left to Bottom-Right Line of X)
            AnimatedPositioned(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              top: widget.isOpen
                  ? 15
                  : 6, // If open, shift down to center (15). If closed, sit near the top (6).
              left:
                  4, // Inset slightly to make the line 24px wide within the 32px box (matching Lucide specs)
              right: 4, // Inset slightly to make the line 24px wide
              child: AnimatedRotation(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                turns: widget.isOpen
                    ? 0.125
                    : 0, // 0.125 turns = 45 degrees. Creates the \ part of the X.
                child: Container(
                  height:
                      2.0, // Controls the thickness of the hamburger lines. Lower = thinner (matches Lucide stroke-width 2).
                  decoration: BoxDecoration(
                    color: AppColors.slateTrust, // The stroke color
                    borderRadius: BorderRadius.circular(
                        2.0), // Creates the StrokeCap.round effect matching Lucide
                  ),
                ),
              ),
            ),

            // Bar 2 (Middle Line)
            AnimatedPositioned(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              top: 15, // Fixed in the exact vertical center of the 32x32 box
              left: 4, // Inset matching top and bottom bars
              right: 4, // Inset matching top and bottom bars
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 250),
                opacity: widget.isOpen
                    ? 0
                    : 1, // Completely fade out when the menu is open to hide the middle bar
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                  height:
                      2.0, // Matches the thin 2.0 stroke width of the other bars
                  width: widget.isOpen
                      ? 0
                      : double
                          .infinity, // Retract width to 0 for a smooth exit animation alongside fade
                  decoration: BoxDecoration(
                    color: AppColors.slateTrust,
                    borderRadius: BorderRadius.circular(
                        2.0), // Required for StrokeCap.round effect
                  ),
                ),
              ),
            ),

            // Bar 3 (Bottom / Bottom-Left to Top-Right Line of X)
            AnimatedPositioned(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              top: widget.isOpen
                  ? 15
                  : 24, // If open, shift up to center (15) to intersect. If closed, sit near the bottom (24).
              left: 4, // Inset matching top bar
              right: 4, // Inset matching top bar
              child: AnimatedRotation(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                turns: widget.isOpen
                    ? -0.125
                    : 0, // -0.125 turns = -45 degrees. Creates the / part of the X.
                child: Container(
                  height:
                      2.0, // Matches the thin 2.0 stroke width of the other bars
                  decoration: BoxDecoration(
                    color: AppColors.slateTrust,
                    borderRadius: BorderRadius.circular(
                        2.0), // Required for StrokeCap.round effect
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
