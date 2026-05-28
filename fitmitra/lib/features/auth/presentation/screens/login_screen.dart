import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/utils/validators.dart';
import '../providers/auth_provider.dart';
import 'otp_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _sendOTP() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final authService = ref.read(authServiceProvider);
    await authService.sendOTP(
      phoneNumber: _phoneController.text.trim(),
      onCodeSent: (verificationId) {
        setState(() => _isLoading = false);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => OTPScreen(
              phoneNumber: _phoneController.text.trim(),
              verificationId: verificationId,
            ),
          ),
        );
      },
      onError: (error) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error), backgroundColor: AppColors.error),
        );
      },
      onAutoVerify: (credential) async {
        setState(() => _isLoading = false);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 60),
              Center(
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.favorite_rounded, color: Colors.white, size: 48),
                ),
              ).animate().fadeIn(duration: 600.ms).scale(begin: const Offset(0.5, 0.5), end: const Offset(1, 1)),
              const SizedBox(height: 32),
              Center(
                child: Text(
                  'FitMitra',
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        foreground: Paint()
                          ..shader = AppColors.primaryGradient.createShader(
                            const Rect.fromLTWH(0, 0, 200, 40),
                          ),
                      ),
                ),
              ).animate().fadeIn(delay: 200.ms, duration: 600.ms),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  'Your AI Health & Wellness Companion',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                      ),
                ),
              ).animate().fadeIn(delay: 400.ms, duration: 600.ms),
              const SizedBox(height: 60),
              Text(
                'Login with Phone',
                style: Theme.of(context).textTheme.headlineMedium,
              ).animate().fadeIn(delay: 500.ms).slideX(begin: -0.1),
              const SizedBox(height: 8),
              Text(
                'We\'ll send you a verification code',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    ),
              ).animate().fadeIn(delay: 600.ms),
              const SizedBox(height: 24),
              Form(
                key: _formKey,
                child: TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: Validators.phone,
                  style: Theme.of(context).textTheme.bodyLarge,
                  decoration: InputDecoration(
                    hintText: 'Enter 10-digit mobile number',
                    prefixIcon: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('\u{1F1EE}\u{1F1F3}', style: TextStyle(fontSize: 20)),
                          const SizedBox(width: 6),
                          Text(
                            '+91',
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            width: 1,
                            height: 24,
                            color: isDark ? AppColors.dividerDark : AppColors.dividerLight,
                          ),
                        ],
                      ),
                    ),
                    counterText: '',
                  ),
                ),
              ).animate().fadeIn(delay: 700.ms).slideY(begin: 0.1),
              const SizedBox(height: 32),
              CustomButton(
                text: 'Send OTP',
                onPressed: _sendOTP,
                isLoading: _isLoading,
                useGradient: true,
              ).animate().fadeIn(delay: 800.ms),
              const SizedBox(height: 24),
              Center(
                child: Text(
                  'By continuing, you agree to our Terms of Service\nand Privacy Policy',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ).animate().fadeIn(delay: 900.ms),
            ],
          ),
        ),
      ),
    );
  }
}
