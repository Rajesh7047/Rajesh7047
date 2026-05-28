import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../providers/auth_provider.dart';

class ProfileSetupScreen extends ConsumerStatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  ConsumerState<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends ConsumerState<ProfileSetupScreen> {
  final _pageController = PageController();
  int _currentStep = 0;
  final _totalSteps = 3;

  // Form data
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  String _gender = 'Female';
  String _selectedGoal = 'Weight Loss';
  String _selectedActivity = 'Moderately Active';
  String _selectedDiet = 'Vegetarian';

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  void _next() {
    if (_currentStep < _totalSteps - 1) {
      _pageController.nextPage(
        duration: AppConstants.mediumDuration,
        curve: Curves.easeInOut,
      );
      setState(() => _currentStep++);
    } else {
      _saveProfile();
    }
  }

  void _back() {
    if (_currentStep > 0) {
      _pageController.previousPage(
        duration: AppConstants.mediumDuration,
        curve: Curves.easeInOut,
      );
      setState(() => _currentStep--);
    }
  }

  Future<void> _saveProfile() async {
    final user = ref.read(authStateProvider).valueOrNull;
    if (user == null) return;

    final success = await ref.read(profileUpdateProvider.notifier).updateProfile(
          uid: user.uid,
          name: _nameController.text.trim(),
          age: int.parse(_ageController.text.trim()),
          height: double.parse(_heightController.text.trim()),
          weight: double.parse(_weightController.text.trim()),
          gender: _gender,
          healthGoal: _selectedGoal,
          activityLevel: _selectedActivity,
          dietPreference: _selectedDiet,
        );

    if (success && mounted) {
      context.go(AppRoutes.main);
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileUpdateProvider);
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                children: [
                  Row(
                    children: [
                      if (_currentStep > 0)
                        IconButton(
                          onPressed: _back,
                          icon: const Icon(Icons.arrow_back_ios_new_rounded),
                          padding: EdgeInsets.zero,
                        )
                      else
                        const SizedBox(width: 40),
                      Expanded(
                        child: Text(
                          'Set Up Profile',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.titleLarge,
                        ),
                      ),
                      TextButton(
                        onPressed: () => context.go(AppRoutes.main),
                        child: const Text('Skip'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Progress indicator
                  Row(
                    children: List.generate(
                      _totalSteps,
                      (i) => Expanded(
                        child: AnimatedContainer(
                          duration: AppConstants.shortDuration,
                          margin: EdgeInsets.only(right: i < _totalSteps - 1 ? 6 : 0),
                          height: 4,
                          decoration: BoxDecoration(
                            color: i <= _currentStep
                                ? AppColors.primary
                                : theme.colorScheme.outlineVariant,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'Step ${_currentStep + 1} of $_totalSteps',
                      style: theme.textTheme.labelSmall,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildBasicInfoStep(theme),
                  _buildBodyMetricsStep(theme),
                  _buildGoalPreferencesStep(theme),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: profileState.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : AppButton(
                      text: _currentStep == _totalSteps - 1 ? 'Start My Journey 🚀' : 'Continue',
                      onPressed: _next,
                      gradient: AppColors.primaryGradient,
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBasicInfoStep(ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('What\'s your\nname? 😊', style: theme.textTheme.displayMedium),
          const SizedBox(height: 8),
          Text('Tell us a bit about yourself', style: theme.textTheme.bodyLarge),
          const SizedBox(height: 32),
          AppTextField(
            controller: _nameController,
            label: 'Full Name',
            hint: 'Enter your full name',
            prefixIcon: const Icon(Icons.person_outline_rounded),
            textCapitalization: TextCapitalization.words,
            validator: Validators.name,
          ),
          const SizedBox(height: 20),
          AppTextField(
            controller: _ageController,
            label: 'Age',
            hint: 'Enter your age',
            prefixIcon: const Icon(Icons.cake_outlined),
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(3)],
            validator: Validators.age,
          ),
          const SizedBox(height: 24),
          Text('Gender', style: theme.textTheme.titleSmall),
          const SizedBox(height: 12),
          Row(
            children: [
              _GenderChip(
                label: 'Female',
                emoji: '👩',
                selected: _gender == 'Female',
                onTap: () => setState(() => _gender = 'Female'),
              ),
              const SizedBox(width: 12),
              _GenderChip(
                label: 'Male',
                emoji: '👨',
                selected: _gender == 'Male',
                onTap: () => setState(() => _gender = 'Male'),
              ),
              const SizedBox(width: 12),
              _GenderChip(
                label: 'Other',
                emoji: '🧑',
                selected: _gender == 'Other',
                onTap: () => setState(() => _gender = 'Other'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBodyMetricsStep(ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Body\nMetrics 📏', style: theme.textTheme.displayMedium),
          const SizedBox(height: 8),
          Text('This helps us calculate your ideal plan', style: theme.textTheme.bodyLarge),
          const SizedBox(height: 32),
          AppTextField(
            controller: _heightController,
            label: 'Height',
            hint: '165',
            prefixIcon: const Icon(Icons.height_rounded),
            suffixText: 'cm',
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            validator: Validators.height,
          ),
          const SizedBox(height: 20),
          AppTextField(
            controller: _weightController,
            label: 'Weight',
            hint: '65',
            prefixIcon: const Icon(Icons.monitor_weight_outlined),
            suffixText: 'kg',
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            validator: Validators.weight,
          ),
          const SizedBox(height: 24),
          Text('Activity Level', style: theme.textTheme.titleSmall),
          const SizedBox(height: 12),
          ...AppConstants.activityLevels.map((level) => _ActivityTile(
                label: level,
                subtitle: _activityDescription(level),
                selected: _selectedActivity == level,
                onTap: () => setState(() => _selectedActivity = level),
              )),
        ],
      ),
    );
  }

  Widget _buildGoalPreferencesStep(ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Your Health\nGoal 🎯', style: theme.textTheme.displayMedium),
          const SizedBox(height: 8),
          Text('Pick your primary health objective', style: theme.textTheme.bodyLarge),
          const SizedBox(height: 24),
          ...AppConstants.healthGoals.map((goal) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _GoalCard(
                  goal: goal,
                  emoji: _goalEmoji(goal),
                  selected: _selectedGoal == goal,
                  onTap: () => setState(() => _selectedGoal = goal),
                ),
              )),
          const SizedBox(height: 16),
          Text('Diet Preference', style: theme.textTheme.titleSmall),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: AppConstants.dietTypes.map((diet) => ChoiceChip(
                  label: Text(diet),
                  selected: _selectedDiet == diet,
                  onSelected: (_) => setState(() => _selectedDiet = diet),
                  selectedColor: AppColors.primaryContainer,
                )).toList(),
          ),
        ],
      ),
    );
  }

  String _activityDescription(String level) => switch (level) {
        'Sedentary' => 'Little or no exercise',
        'Lightly Active' => 'Light exercise 1-3 days/week',
        'Moderately Active' => 'Moderate exercise 3-5 days/week',
        'Very Active' => 'Hard exercise 6-7 days/week',
        'Extra Active' => 'Very hard exercise & physical job',
        _ => '',
      };

  String _goalEmoji(String goal) => switch (goal) {
        'Weight Loss' => '⬇️',
        'Weight Gain' => '⬆️',
        'PCOD/PCOS' => '💗',
        'Thyroid Management' => '🦋',
        'Maintenance' => '⚖️',
        'Muscle Gain' => '💪',
        'Stress Relief' => '🧘',
        _ => '🎯',
      };
}

class _GenderChip extends StatelessWidget {
  final String label;
  final String emoji;
  final bool selected;
  final VoidCallback onTap;

  const _GenderChip({
    required this.label,
    required this.emoji,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: AppConstants.shortDuration,
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: selected ? AppColors.primaryContainer : Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selected ? AppColors.primary : Theme.of(context).colorScheme.outlineVariant,
              width: selected ? 2 : 1,
            ),
          ),
          child: Column(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 24)),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                  color: selected ? AppColors.primary : null,
                  fontFamily: 'Poppins',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActivityTile extends StatelessWidget {
  final String label;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  const _ActivityTile({
    required this.label,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppConstants.shortDuration,
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryContainer : Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? AppColors.primary : Theme.of(context).colorScheme.outlineVariant,
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                      color: selected ? AppColors.primary : null,
                      fontFamily: 'Poppins',
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            if (selected)
              const Icon(Icons.check_circle_rounded, color: AppColors.primary, size: 20),
          ],
        ),
      ),
    );
  }
}

class _GoalCard extends StatelessWidget {
  final String goal;
  final String emoji;
  final bool selected;
  final VoidCallback onTap;

  const _GoalCard({
    required this.goal,
    required this.emoji,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppConstants.shortDuration,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryContainer : Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? AppColors.primary : Theme.of(context).colorScheme.outlineVariant,
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 24)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                goal,
                style: TextStyle(
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                  color: selected ? AppColors.primary : null,
                  fontFamily: 'Poppins',
                  fontSize: 14,
                ),
              ),
            ),
            if (selected)
              const Icon(Icons.check_circle_rounded, color: AppColors.primary, size: 20),
          ],
        ),
      ),
    );
  }
}
