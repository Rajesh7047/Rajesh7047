class Validators {
  Validators._();

  static String? phone(String? value) {
    if (value == null || value.isEmpty) return 'Phone number is required';
    if (value.length != 10) return 'Enter a valid 10-digit phone number';
    if (!RegExp(r'^[6-9]\d{9}$').hasMatch(value)) return 'Enter a valid Indian phone number';
    return null;
  }

  static String? otp(String? value) {
    if (value == null || value.isEmpty) return 'OTP is required';
    if (value.length != 6) return 'Enter the 6-digit OTP';
    return null;
  }

  static String? name(String? value) {
    if (value == null || value.trim().isEmpty) return 'Name is required';
    if (value.trim().length < 2) return 'Name must be at least 2 characters';
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.isEmpty) return null;
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  static String? age(String? value) {
    if (value == null || value.isEmpty) return 'Age is required';
    final age = int.tryParse(value);
    if (age == null || age < 10 || age > 120) return 'Enter a valid age (10-120)';
    return null;
  }

  static String? weight(String? value) {
    if (value == null || value.isEmpty) return 'Weight is required';
    final w = double.tryParse(value);
    if (w == null || w < 20 || w > 300) return 'Enter valid weight (20-300 kg)';
    return null;
  }

  static String? height(String? value) {
    if (value == null || value.isEmpty) return 'Height is required';
    final h = double.tryParse(value);
    if (h == null || h < 50 || h > 300) return 'Enter valid height (50-300 cm)';
    return null;
  }
}
