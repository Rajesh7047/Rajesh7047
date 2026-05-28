import 'package:equatable/equatable.dart';

class MembershipPlan extends Equatable {
  const MembershipPlan({
    required this.id,
    required this.name,
    required this.priceInPaise,
    required this.durationDays,
    required this.features,
    required this.isPremium,
  });

  final String id;
  final String name;
  final int priceInPaise;
  final int durationDays;
  final List<String> features;
  final bool isPremium;

  String get priceDisplay {
    if (priceInPaise == 0) return 'Free';
    return '₹${(priceInPaise / 100).toStringAsFixed(0)}';
  }

  @override
  List<Object?> get props => [id, name, priceInPaise];
}
