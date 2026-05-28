import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_button.dart';
import '../providers/auth_provider.dart';
import 'profile_setup_screen.dart';

class OTPScreen extends ConsumerStatefulWidget {
  final String phoneNumber;
  final String verificationId;

  const OTPScreen({
    super.key,
    required this.phoneNumber,
    required this.verificationId,
  });

  @override
  ConsumerState<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends ConsumerState<OTPScreen> {
  String _otp = '';
  bool _isLoading = false;

  Future<void> _verifyOTP() async {
    if (_otp.length != 6) return;
    setState(() => _isLoading = true);

    final authService = ref.read(authServiceProvider);
    final result = await authService.verifyOTP(_otp);

    if (result != null && mounted) {
      final firestoreService = ref.read(firestoreServiceProvider);
      final doc = await firestoreService.getDocument(
        collection: 'users',
        docId: result.user!.uid,
      );

      if (doc.exists) {
        if (mounted) {
          Navigator.of(context).popUntil((route) => route.isFirst);
        }
      } else {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => ProfileSetupScreen(
                uid: result.user!.uid,
                phone: widget.phoneNumber,
              ),
            ),
          );
        }
      }
    } else if (mounted) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid OTP. Please try again.'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text(
                'Verify OTP',
                style: Theme.of(context).textTheme.displaySmall,
              ).animate().fadeIn(duration: 400.ms),
              const SizedBox(height: 8),
              Text(
                'Enter the 6-digit code sent to\n+91 ${widget.phoneNumber}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    ),
              ).animate().fadeIn(delay: 200.ms),
              const SizedBox(height: 40),
              PinCodeTextField(
                appContext: context,
                length: 6,
                onChanged: (value) => _otp = value,
                onCompleted: (_) => _verifyOTP(),
                animationType: AnimationType.scale,
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(12),
                  fieldHeight: 56,
                  fieldWidth: 48,
                  activeFillColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                  inactiveFillColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
                  selectedFillColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                  activeColor: AppColors.primary,
                  inactiveColor: isDark ? AppColors.dividerDark : AppColors.dividerLight,
                  selectedColor: AppColors.primary,
                ),
                enableActiveFill: true,
                keyboardType: TextInputType.number,
                textStyle: Theme.of(context).textTheme.headlineMedium,
              ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.1),
              const SizedBox(height: 32),
              CustomButton(
                text: 'Verify & Continue',
                onPressed: _verifyOTP,
                isLoading: _isLoading,
                useGradient: true,
              ).animate().fadeIn(delay: 600.ms),
              const SizedBox(height: 24),
              Center(
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    'Resend OTP',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
