import 'package:fitmitra/src/core/providers/core_providers.dart';
import 'package:fitmitra/src/core/utils/responsive.dart';
import 'package:fitmitra/src/core/widgets/app_card.dart';
import 'package:fitmitra/src/core/widgets/primary_button.dart';
import 'package:fitmitra/src/features/auth/presentation/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController(text: '+91 ');

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _sendOtp() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    await ref
        .read(authControllerProvider.notifier)
        .requestOtp(_phoneController.text.trim());

    final authState = ref.read(authControllerProvider);
    if (!mounted) {
      return;
    }

    if (authState.pendingOtp != null) {
      context.go('/otp');
      return;
    }

    if (authState.errorMessage != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(authState.errorMessage!)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final firebaseState = ref.watch(firebaseBootstrapProvider);
    final isMobile = Responsive.isMobile(context);
    final theme = Theme.of(context);

    final form = AppCard(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'OTP login for modern wellness coaching',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Secure Firebase Auth with mobile OTP. Demo mode is available until your FlutterFire configuration is connected.',
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Mobile number',
                hintText: '+91 98765 43210',
                prefixIcon: Icon(Icons.phone_android_rounded),
              ),
              validator: (value) {
                final sanitized =
                    value?.replaceAll(RegExp(r'[^0-9+]'), '') ?? '';
                if (sanitized.length < 10) {
                  return 'Enter a valid phone number with country code.';
                }
                return null;
              },
            ),
            const SizedBox(height: 14),
            DecoratedBox(
              decoration: BoxDecoration(
                color: firebaseState.isConfigured
                    ? theme.colorScheme.primaryContainer.withValues(alpha: 0.55)
                    : theme.colorScheme.tertiaryContainer.withValues(
                        alpha: 0.55,
                      ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    Icon(
                      firebaseState.isConfigured
                          ? Icons.cloud_done_rounded
                          : Icons.science_rounded,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        firebaseState.message ??
                            'Preparing FitMitra services...',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (authState.errorMessage != null) ...[
              const SizedBox(height: 14),
              Text(
                authState.errorMessage!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
            ],
            const SizedBox(height: 22),
            PrimaryButton(
              label: 'Send OTP',
              icon: Icons.lock_open_rounded,
              isLoading: authState.isLoading,
              onPressed: authState.isLoading ? null : _sendOtp,
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () => context.push('/membership'),
              icon: const Icon(Icons.workspace_premium_rounded),
              label: const Text('View premium plans'),
            ),
          ],
        ),
      ),
    );

    final highlights = AppCard(
      gradient: LinearGradient(
        colors: [theme.colorScheme.primary, theme.colorScheme.secondary],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'FitMitra',
            style: theme.textTheme.displaySmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Premium AI wellness for modern lifestyles',
            style: theme.textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: const [
              _FeaturePill(label: 'AI health chat'),
              _FeaturePill(label: 'Diet plans'),
              _FeaturePill(label: 'Yoga & meditation'),
              _FeaturePill(label: 'Zoom mentor sessions'),
              _FeaturePill(label: 'Calorie & water tracker'),
              _FeaturePill(label: 'Razorpay premium checkout'),
            ],
          ),
        ],
      ),
    );

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: Responsive.contentWidth(context),
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: isMobile
                  ? Column(
                      children: [
                        highlights
                            .animate()
                            .fadeIn(duration: 400.ms)
                            .slideY(begin: 0.08),
                        const SizedBox(height: 20),
                        form.animate().fadeIn(delay: 120.ms),
                      ],
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: highlights
                              .animate()
                              .fadeIn(duration: 400.ms)
                              .slideX(begin: -0.06),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          child: form
                              .animate()
                              .fadeIn(delay: 120.ms)
                              .slideX(begin: 0.06),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FeaturePill extends StatelessWidget {
  const _FeaturePill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
