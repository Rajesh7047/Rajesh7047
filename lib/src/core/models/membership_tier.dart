enum MembershipTier { free, premium }

extension MembershipTierX on MembershipTier {
  String get label => switch (this) {
    MembershipTier.free => 'Free',
    MembershipTier.premium => 'Premium',
  };

  String get headline => switch (this) {
    MembershipTier.free => 'Build healthy habits daily',
    MembershipTier.premium => 'Unlock mentor-led transformation',
  };
}

MembershipTier membershipTierFromKey(String value) {
  return MembershipTier.values.firstWhere(
    (tier) => tier.name == value,
    orElse: () => MembershipTier.free,
  );
}
