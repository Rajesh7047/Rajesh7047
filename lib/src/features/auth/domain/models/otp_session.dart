class OtpSession {
  const OtpSession({
    required this.sessionId,
    required this.phoneNumber,
    required this.isMock,
    this.debugCode,
  });

  final String sessionId;
  final String phoneNumber;
  final bool isMock;
  final String? debugCode;
}
