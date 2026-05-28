import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/helpers.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool _isEditing = false;
  late TextEditingController _nameController;
  late TextEditingController _ageController;
  late TextEditingController _heightController;
  late TextEditingController _weightController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _ageController = TextEditingController();
    _heightController = TextEditingController();
    _weightController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  void _initControllers(user) {
    if (_nameController.text.isEmpty) {
      _nameController.text = user?.name ?? '';
      _ageController.text = user?.age?.toString() ?? '';
      _heightController.text = user?.heightCm?.toString() ?? '';
      _weightController.text = user?.weightKg?.toString() ?? '';
    }
  }

  Future<void> _saveProfile(String uid) async {
    final success = await ref.read(profileUpdateProvider.notifier).updateProfile(
          uid: uid,
          name: _nameController.text,
          age: int.tryParse(_ageController.text) ?? 25,
          height: double.tryParse(_heightController.text) ?? 165,
          weight: double.tryParse(_weightController.text) ?? 60,
          gender: 'Female',
          healthGoal: 'Weight Loss',
          activityLevel: 'Moderately Active',
          dietPreference: 'Vegetarian',
        );

    if (success) {
      setState(() => _isEditing = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully! ✅'),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(currentUserProvider);
    final theme = Theme.of(context);

    return userAsync.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(body: Center(child: Text(e.toString()))),
      data: (user) {
        _initControllers(user);
        final bmi = user?.bmi;
        final bmiCategory = bmi != null ? AppHelpers.getBmiCategory(bmi) : 'N/A';
        final authUser = ref.read(authStateProvider).valueOrNull;

        return Scaffold(
          appBar: AppBar(
            title: const Text('My Profile'),
            actions: [
              if (!_isEditing)
                TextButton.icon(
                  onPressed: () => setState(() => _isEditing = true),
                  icon: const Icon(Icons.edit_outlined, size: 16),
                  label: const Text('Edit'),
                )
              else
                TextButton(
                  onPressed: () => setState(() => _isEditing = false),
                  child: const Text('Cancel'),
                ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile header
                Center(
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              gradient: AppColors.primaryGradient,
                              borderRadius: BorderRadius.circular(28),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withValues(alpha: 0.3),
                                  blurRadius: 20,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                user?.initials ?? 'FM',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 36,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ),
                          ),
                          if (_isEditing)
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: Container(
                                width: 28,
                                height: 28,
                                decoration: const BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 16),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(user?.name ?? 'FitMitra User', style: theme.textTheme.headlineSmall),
                      Text(user?.phoneNumber ?? '', style: theme.textTheme.bodySmall),
                      if (user?.isPremium == true) ...[
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                          decoration: BoxDecoration(
                            gradient: AppColors.premiumGradient,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.workspace_premium_rounded, color: Colors.white, size: 14),
                              SizedBox(width: 6),
                              Text('Premium Member', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600, fontFamily: 'Poppins')),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Stats row
                if (!_isEditing) ...[
                  Row(
                    children: [
                      Expanded(child: _StatBox('⚖️', user?.weightKg?.toStringAsFixed(1) ?? '--', 'kg', 'Weight')),
                      const SizedBox(width: 12),
                      Expanded(child: _StatBox('📏', user?.heightCm?.toStringAsFixed(0) ?? '--', 'cm', 'Height')),
                      const SizedBox(width: 12),
                      Expanded(child: _StatBox('🎂', user?.age?.toString() ?? '--', 'yrs', 'Age')),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _StatBox(
                          AppHelpers.getBmiEmoji(bmi ?? 22),
                          bmi?.toStringAsFixed(1) ?? '--',
                          bmiCategory,
                          'BMI',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                ],

                // Goals info
                if (!_isEditing) ...[
                  Text('Health Details', style: theme.textTheme.titleLarge),
                  const SizedBox(height: 12),
                  _InfoCard(
                    items: [
                      ('🎯', 'Health Goal', user?.healthGoal ?? 'Not set'),
                      ('🏃', 'Activity Level', user?.activityLevel ?? 'Not set'),
                      ('🥗', 'Diet Type', user?.dietPreference ?? 'Not set'),
                      ('⚡', 'Calorie Goal', '${user?.dailyCalorieGoal ?? 2000} kcal/day'),
                      ('💧', 'Water Goal', '${user?.dailyWaterGoalLiters?.toStringAsFixed(1) ?? "2.5"} L/day'),
                      ('🚻', 'Gender', user?.gender ?? 'Not set'),
                    ],
                  ),
                ] else ...[
                  Text('Edit Profile', style: theme.textTheme.titleLarge),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Full Name', prefixIcon: Icon(Icons.person_outline)),
                    textCapitalization: TextCapitalization.words,
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _ageController,
                    decoration: const InputDecoration(labelText: 'Age', prefixIcon: Icon(Icons.cake_outlined)),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _heightController,
                    decoration: const InputDecoration(labelText: 'Height (cm)', prefixIcon: Icon(Icons.height_rounded), suffixText: 'cm'),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _weightController,
                    decoration: const InputDecoration(labelText: 'Weight (kg)', prefixIcon: Icon(Icons.monitor_weight_outlined), suffixText: 'kg'),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  ),
                  const SizedBox(height: 24),
                  AppButton(
                    text: 'Save Changes',
                    onPressed: authUser != null ? () => _saveProfile(authUser.uid) : null,
                    gradient: AppColors.primaryGradient,
                  ),
                ],

                const SizedBox(height: 80),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _StatBox extends StatelessWidget {
  final String emoji;
  final String value;
  final String unit;
  final String label;

  const _StatBox(this.emoji, this.value, this.unit, this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, fontFamily: 'Poppins'),
          ),
          Text(unit, style: const TextStyle(fontSize: 10, color: AppColors.textTertiary, fontFamily: 'Poppins')),
          Text(label, style: const TextStyle(fontSize: 10, color: AppColors.textTertiary, fontFamily: 'Poppins')),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final List<(String, String, String)> items;

  const _InfoCard({required this.items});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Column(
        children: items.asMap().entries.map((entry) {
          final item = entry.value;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    Text(item.$1, style: const TextStyle(fontSize: 18)),
                    const SizedBox(width: 12),
                    Text(item.$2, style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.textTertiary)),
                    const Spacer(),
                    Text(item.$3, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              if (entry.key < items.length - 1)
                Divider(height: 1, indent: 16, endIndent: 16, color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5)),
            ],
          );
        }).toList(),
      ),
    );
  }
}
