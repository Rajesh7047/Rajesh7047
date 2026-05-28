import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../state/app_providers.dart';
import '../widgets/fitmitra_widgets.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _phoneController = TextEditingController(text: '+91');
  final _otpController = TextEditingController();
  String? _verificationId;
  bool _loading = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('FitMitra login')),
      body: ResponsiveContent(
        maxWidth: 720,
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            GradientCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Mobile OTP for secure wellness access',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                        ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Sign in with Firebase Phone Auth to sync trackers, memberships, plans, and mentor bookings.',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Mobile number',
                prefixIcon: Icon(Icons.phone_android_rounded),
                helperText: 'Use E.164 format, e.g. +919876543210',
              ),
            ),
            const SizedBox(height: 14),
            if (_verificationId != null)
              TextField(
                controller: _otpController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'OTP code',
                  prefixIcon: Icon(Icons.password_rounded),
                ),
              ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _loading ? null : (_verificationId == null ? _sendOtp : _verifyOtp),
              icon: _loading
                  ? const SizedBox.square(dimension: 18, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.verified_user_rounded),
              label: Text(_verificationId == null ? 'Send OTP' : 'Verify OTP'),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () => context.go('/home'),
              icon: const Icon(Icons.explore_rounded),
              label: const Text('Continue in demo mode'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _sendOtp() async {
    setState(() => _loading = true);
    await ref.read(authRepositoryProvider).sendOtp(
          phoneNumber: _phoneController.text.trim(),
          onCodeSent: (verificationId) {
            if (!mounted) return;
            setState(() {
              _verificationId = verificationId;
              _loading = false;
            });
            _snack('OTP sent.');
          },
          onError: (message) {
            if (!mounted) return;
            setState(() => _loading = false);
            _snack(message);
          },
        );
    if (mounted && _loading && _verificationId == null) {
      setState(() => _loading = false);
    }
  }

  Future<void> _verifyOtp() async {
    final verificationId = _verificationId;
    if (verificationId == null) return;
    setState(() => _loading = true);
    try {
      await ref.read(authRepositoryProvider).verifyOtp(
            verificationId: verificationId,
            smsCode: _otpController.text.trim(),
          );
      if (mounted) context.go('/home');
    } catch (error) {
      _snack('Could not verify OTP: $error');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _snack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}
