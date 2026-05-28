import 'package:equatable/equatable.dart';

class HealthGoal extends Equatable {
  const HealthGoal({
    required this.id,
    required this.title,
    required this.description,
    required this.iconName,
  });

  final String id;
  final String title;
  final String description;
  final String iconName;

  @override
  List<Object?> get props => [id, title];
}
