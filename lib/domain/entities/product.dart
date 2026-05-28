import 'package:equatable/equatable.dart';

class WellnessProduct extends Equatable {
  const WellnessProduct({
    required this.id,
    required this.name,
    required this.description,
    required this.priceInPaise,
    required this.imageUrl,
    required this.goalIds,
    this.rating = 4.5,
    this.tag,
  });

  final String id;
  final String name;
  final String description;
  final int priceInPaise;
  final String imageUrl;
  final List<String> goalIds;
  final double rating;
  final String? tag;

  String get priceDisplay => '₹${(priceInPaise / 100).toStringAsFixed(0)}';

  @override
  List<Object?> get props => [id, name];
}
