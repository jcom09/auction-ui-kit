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
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 40,
        height: 30,
        child: Stack(
          children: [
            // Bar 1 (Top)
            AnimatedPositioned(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              top: widget.isOpen ? 13 : 0,
              left: 0,
              right: 0,
              child: AnimatedRotation(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                turns: widget.isOpen ? 0.125 : 0, // 0.125 * 360 = 45 degrees
                child: Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.deepGreen,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),

            // Bar 2 (Middle)
            AnimatedPositioned(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              top: 13,
              left: 0,
              right:
                  0, // If width 0 check relies on constraint or manual width?
              // Using opacity for fade out as requested,
              // and maybe width change if needed, but opacity is safer for "fade out".
              // Request says: If Open: opacity: 0, width: 0.
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 250),
                opacity: widget.isOpen ? 0 : 1,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                  height: 4,
                  width: widget.isOpen ? 0 : double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.deepGreen,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),

            // Bar 3 (Bottom)
            AnimatedPositioned(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              top: widget.isOpen ? 13 : 26,
              left: 0,
              right: 0,
              child: AnimatedRotation(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                turns: widget.isOpen ? -0.125 : 0, // -45 degrees
                child: Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.deepGreen,
                    borderRadius: BorderRadius.circular(2),
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
