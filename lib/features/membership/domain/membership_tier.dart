enum MembershipTier { free, premium }

extension MembershipTierLabel on MembershipTier {
  String get label => this == MembershipTier.premium ? 'Premium' : 'Free';
}
