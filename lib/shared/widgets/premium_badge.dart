import 'package:flutter/material.dart';
import 'package:fitmitra/core/theme/app_colors.dart';

class PremiumBadge extends StatelessWidget {
  const PremiumBadge({super.key, this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 8 : 10,
        vertical: compact ? 2 : 4,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.premiumGold, Color(0xFFFFE082)],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.workspace_premium,
            size: compact ? 14 : 16,
            color: Colors.brown.shade800,
          ),
          if (!compact) ...[
            const SizedBox(width: 4),
            Text(
              'PREMIUM',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                color: Colors.brown.shade800,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
