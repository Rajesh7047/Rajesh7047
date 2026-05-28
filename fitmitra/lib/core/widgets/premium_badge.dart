import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class PremiumBadge extends StatelessWidget {
  final double size;
  final bool showLabel;

  const PremiumBadge({super.key, this.size = 20, this.showLabel = false});

  @override
  Widget build(BuildContext context) {
    if (showLabel) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          gradient: AppColors.premiumGradient,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.workspace_premium_rounded, color: Colors.white, size: size * 0.8),
            const SizedBox(width: 4),
            const Text(
              'PREMIUM',
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      );
    }
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        gradient: AppColors.premiumGradient,
        shape: BoxShape.circle,
      ),
      child: Icon(Icons.workspace_premium_rounded, color: Colors.white, size: size * 0.7),
    );
  }
}

class PremiumLockOverlay extends StatelessWidget {
  final Widget child;
  final bool isPremium;
  final VoidCallback? onUpgrade;

  const PremiumLockOverlay({
    super.key,
    required this.child,
    required this.isPremium,
    this.onUpgrade,
  });

  @override
  Widget build(BuildContext context) {
    if (!isPremium) return child;
    return Stack(
      children: [
        child,
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onUpgrade,
                borderRadius: BorderRadius.circular(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.lock_rounded, color: Colors.white, size: 32),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        gradient: AppColors.premiumGradient,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'Upgrade to Premium',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
