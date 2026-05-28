import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/custom_card.dart';
import '../../../../core/widgets/custom_button.dart';

class PaymentService {
  static void openRazorpay({
    required int amount,
    required String description,
    required String name,
    required String phone,
    required String email,
    required Function(String paymentId) onSuccess,
    required Function(String error) onError,
  }) {
    // Razorpay integration placeholder
    // In production, use:
    // final razorpay = Razorpay();
    // razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, (response) => onSuccess(response.paymentId));
    // razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, (response) => onError(response.message));
    // razorpay.open({
    //   'key': AppConstants.razorpayKeyId,
    //   'amount': amount * 100,
    //   'name': 'FitMitra',
    //   'description': description,
    //   'prefill': {'contact': phone, 'email': email},
    //   'theme': {'color': '#6C63FF'},
    // });
  }
}

class PaymentHistoryScreen extends StatelessWidget {
  const PaymentHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Payment History'),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: samplePayments.length,
        itemBuilder: (context, index) {
          final payment = samplePayments[index];
          return CustomCard(
            animationIndex: index,
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: (payment['status'] == 'Success' ? AppColors.success : AppColors.error).withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    payment['status'] == 'Success' ? Icons.check_circle_rounded : Icons.error_rounded,
                    color: payment['status'] == 'Success' ? AppColors.success : AppColors.error,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(payment['desc'] as String, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                      Text(payment['date'] as String, style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('₹${payment['amount']}', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                    Text(payment['status'] as String, style: TextStyle(
                      color: payment['status'] == 'Success' ? AppColors.success : AppColors.error,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    )),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  static final List<Map<String, dynamic>> samplePayments = [
    {'desc': 'Premium Monthly', 'amount': 299, 'date': '25 May 2026', 'status': 'Success'},
    {'desc': 'Premium Monthly', 'amount': 299, 'date': '25 Apr 2026', 'status': 'Success'},
    {'desc': 'Mentor Session', 'amount': 499, 'date': '15 Apr 2026', 'status': 'Success'},
    {'desc': 'Premium Monthly', 'amount': 299, 'date': '25 Mar 2026', 'status': 'Failed'},
  ];
}
