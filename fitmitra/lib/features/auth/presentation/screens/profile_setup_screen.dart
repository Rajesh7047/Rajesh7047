import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/utils/validators.dart';
import '../../data/models/user_model.dart';
import '../providers/auth_provider.dart';

class ProfileSetupScreen extends ConsumerStatefulWidget {
  final String uid;
  final String phone;

  const ProfileSetupScreen({super.key, required this.uid, required this.phone});

  @override
  ConsumerState<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends ConsumerState<ProfileSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  final _emailController = TextEditingController();
  String _gender = 'Male';
  String _goal = AppConstants.healthGoals[0];
  bool _isLoading = false;
  int _currentStep = 0;

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final user = UserModel(
      uid: widget.uid,
      name: _nameController.text.trim(),
      phone: widget.phone,
      email: _emailController.text.trim().isEmpty ? null : _emailController.text.trim(),
      age: int.tryParse(_ageController.text),
      weight: double.tryParse(_weightController.text),
      height: double.tryParse(_heightController.text),
      gender: _gender,
      goal: _goal,
    );

    await ref.read(userProvider.notifier).createUser(user);

    if (mounted) {
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(title: const Text('Complete Profile')),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Stepper(
            currentStep: _currentStep,
            onStepContinue: () {
              if (_currentStep < 2) {
                setState(() => _currentStep++);
              } else {
                _saveProfile();
              }
            },
            onStepCancel: () {
              if (_currentStep > 0) setState(() => _currentStep--);
            },
            controlsBuilder: (context, details) {
              return Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        text: _currentStep == 2 ? 'Get Started' : 'Next',
                        onPressed: details.onStepContinue,
                        isLoading: _isLoading && _currentStep == 2,
                        useGradient: true,
                        height: 46,
                      ),
                    ),
                    if (_currentStep > 0) ...[
                      const SizedBox(width: 12),
                      Expanded(
                        child: CustomButton(
                          text: 'Back',
                          onPressed: details.onStepCancel,
                          isOutlined: true,
                          height: 46,
                        ),
                      ),
                    ],
                  ],
                ),
              );
            },
            steps: [
              Step(
                title: const Text('Basic Info'),
                isActive: _currentStep >= 0,
                state: _currentStep > 0 ? StepState.complete : StepState.indexed,
                content: Column(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      validator: Validators.name,
                      decoration: const InputDecoration(
                        labelText: 'Full Name',
                        prefixIcon: Icon(Icons.person_outline_rounded),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _emailController,
                      validator: Validators.email,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Email (optional)',
                        prefixIcon: Icon(Icons.email_outlined),
                      ),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _gender,
                      decoration: const InputDecoration(
                        labelText: 'Gender',
                        prefixIcon: Icon(Icons.wc_rounded),
                      ),
                      items: ['Male', 'Female', 'Other']
                          .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                          .toList(),
                      onChanged: (v) => setState(() => _gender = v!),
                    ),
                  ],
                ).animate().fadeIn(duration: 400.ms),
              ),
              Step(
                title: const Text('Body Details'),
                isActive: _currentStep >= 1,
                state: _currentStep > 1 ? StepState.complete : StepState.indexed,
                content: Column(
                  children: [
                    TextFormField(
                      controller: _ageController,
                      validator: Validators.age,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Age',
                        prefixIcon: Icon(Icons.cake_outlined),
                        suffixText: 'years',
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _weightController,
                      validator: Validators.weight,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        labelText: 'Weight',
                        prefixIcon: Icon(Icons.monitor_weight_outlined),
                        suffixText: 'kg',
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _heightController,
                      validator: Validators.height,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        labelText: 'Height',
                        prefixIcon: Icon(Icons.height_rounded),
                        suffixText: 'cm',
                      ),
                    ),
                  ],
                ).animate().fadeIn(duration: 400.ms),
              ),
              Step(
                title: const Text('Your Goal'),
                isActive: _currentStep >= 2,
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'What\'s your primary health goal?',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                          ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: AppConstants.healthGoals.map((goal) {
                        final isSelected = _goal == goal;
                        return ChoiceChip(
                          label: Text(goal),
                          selected: isSelected,
                          onSelected: (selected) {
                            if (selected) setState(() => _goal = goal);
                          },
                          selectedColor: AppColors.primary.withOpacity(0.2),
                          labelStyle: TextStyle(
                            color: isSelected ? AppColors.primary : null,
                            fontWeight: isSelected ? FontWeight.w600 : null,
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ).animate().fadeIn(duration: 400.ms),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
