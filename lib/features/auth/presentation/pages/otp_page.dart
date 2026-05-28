import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';
import 'package:fitmitra/core/providers/repository_providers.dart';
import 'package:fitmitra/core/utils/result.dart';

class OtpPage extends ConsumerStatefulWidget {
  const OtpPage({
    super.key,
    required this.phoneNumber,
    required this.verificationId,
  });

  final String phoneNumber;
  final String verificationId;

  @override
  ConsumerState<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends ConsumerState<OtpPage> {
  final _otpController = TextEditingController();
  bool _loading = false;

  Future<void> _verify() async {
    final code = _otpController.text.trim();
    if (code.length < 6) return;

    setState(() => _loading = true);
    final result = await ref.read(authRepositoryProvider).verifyOtp(
          verificationId: widget.verificationId,
          smsCode: code,
        );
    if (!mounted) return;
    setState(() => _loading = false);

    result.when(
      success: (_) => context.go('/onboarding'),
      error: (f) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(f.message)),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final defaultPinTheme = PinTheme(
      width: 48,
      height: 56,
      textStyle: theme.textTheme.titleLarge,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Verify OTP')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Enter the 6-digit code sent to +91 ${widget.phoneNumber}',
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 32),
            Pinput(
              controller: _otpController,
              length: 6,
              defaultPinTheme: defaultPinTheme,
              onCompleted: (_) => _verify(),
            ),
            const SizedBox(height: 32),
            FilledButton(
              onPressed: _loading ? null : _verify,
              child: _loading
                  ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Verify & Continue'),
            ),
          ],
        ),
      ),
    );
  }
}
