import 'package:fitmitra/src/core/config/app_config.dart';
import 'package:fitmitra/src/core/models/membership_tier.dart';
import 'package:fitmitra/src/core/models/wellness_goal.dart';
import 'package:fitmitra/src/features/diet/domain/models/diet_plan.dart';
import 'package:fitmitra/src/features/media/domain/models/media_content.dart';
import 'package:fitmitra/src/features/membership/domain/models/subscription_plan.dart';
import 'package:fitmitra/src/features/mentors/domain/models/mentor_session.dart';
import 'package:fitmitra/src/features/shop/domain/models/product_recommendation.dart';

class SeedData {
  const SeedData._();

  static List<SubscriptionPlan> get membershipPlans => const [
    SubscriptionPlan(
      id: 'free',
      title: 'Free',
      subtitle: 'Habit tracking and daily wellness essentials.',
      priceLabel: 'INR 0',
      amountInPaise: 0,
      billingLabel: 'Forever',
      tier: MembershipTier.free,
      features: [
        'OTP login and profile setup',
        'Calorie and water tracking',
        'Daily goal based suggestions',
        'Basic yoga and recipe library',
      ],
    ),
    SubscriptionPlan(
      id: 'premium-monthly',
      title: 'Premium Monthly',
      subtitle: 'Best for ongoing coaching and accountability.',
      priceLabel: 'INR 999',
      amountInPaise: 99900,
      billingLabel: 'Per month',
      tier: MembershipTier.premium,
      isPopular: true,
      features: [
        'Unlimited FitMitra AI conversations',
        'Premium meal plan variations',
        'Weekly Zoom mentor sessions',
        'Goal-based product recommendations',
      ],
    ),
    SubscriptionPlan(
      id: 'premium-quarterly',
      title: 'Premium Quarterly',
      subtitle: 'Longer commitment with better pricing.',
      priceLabel: 'INR 2499',
      amountInPaise: 249900,
      billingLabel: 'Every 3 months',
      tier: MembershipTier.premium,
      features: [
        'Everything in monthly premium',
        'Priority mentor booking windows',
        'Personalized recipe bundles',
        'Extra transformation analytics',
      ],
    ),
  ];

  static DietPlan dietPlanFor(WellnessGoal goal, {required bool isPremium}) {
    switch (goal) {
      case WellnessGoal.weightLoss:
        return DietPlan(
          goal: goal,
          title: 'Lean Balance Plate',
          description:
              'A satiety-forward plan that uses protein, fiber, and structured meal timing to keep hunger stable.',
          dailyCalories: isPremium ? 1750 : 1650,
          hydrationGoalMl: 3000,
          proteinGrams: 120,
          carbsGrams: 150,
          fatsGrams: 58,
          meals: const [
            DietMeal(
              time: '7:30 AM',
              title: 'Protein smoothie bowl',
              description:
                  'Greek yogurt, berries, chia seeds, and soaked almonds.',
              calories: 360,
            ),
            DietMeal(
              time: '1:00 PM',
              title: 'High-volume lunch',
              description:
                  'Paneer quinoa bowl with greens, chickpeas, and mint dressing.',
              calories: 520,
            ),
            DietMeal(
              time: '5:00 PM',
              title: 'Smart snack',
              description:
                  'Buttermilk with roasted makhana and cucumber slices.',
              calories: 180,
            ),
            DietMeal(
              time: '8:00 PM',
              title: 'Recovery dinner',
              description: 'Lentil soup, sauteed vegetables, and millet roti.',
              calories: 520,
            ),
          ],
          coachNotes: const [
            'Aim for a 10-minute walk after your two largest meals.',
            'Keep dinner light but protein-rich for better recovery.',
            'Use the AI chat to swap ingredients without losing macros.',
          ],
          premiumAddOns: isPremium
              ? const [
                  'Restaurant meal swap suggestions.',
                  'Weekend reset meal guide.',
                  'Mentor-reviewed grocery list.',
                ]
              : const [
                  'Upgrade to unlock meal swaps and mentor-reviewed grocery lists.',
                ],
        );
      case WellnessGoal.weightGain:
        return DietPlan(
          goal: goal,
          title: 'Strength Fuel Blueprint',
          description:
              'A clean-bulking structure focused on progressive calories, recovery, and nutrient-dense meals.',
          dailyCalories: isPremium ? 2650 : 2450,
          hydrationGoalMl: 3200,
          proteinGrams: 135,
          carbsGrams: 290,
          fatsGrams: 82,
          meals: const [
            DietMeal(
              time: '8:00 AM',
              title: 'Mass breakfast',
              description:
                  'Oats, banana, peanut butter, whey, and milk smoothie.',
              calories: 620,
            ),
            DietMeal(
              time: '12:30 PM',
              title: 'Power lunch',
              description: 'Rice, dal, paneer bhurji, curd, and salad.',
              calories: 710,
            ),
            DietMeal(
              time: '4:30 PM',
              title: 'Pre-workout stack',
              description: 'Dates, trail mix, and a fruit yogurt.',
              calories: 360,
            ),
            DietMeal(
              time: '8:30 PM',
              title: 'Post-training dinner',
              description:
                  'Whole wheat pasta, tofu, pesto vegetables, and soup.',
              calories: 760,
            ),
          ],
          coachNotes: const [
            'Eat again within 60 minutes of training.',
            'Stack calories into smoothies if appetite drops.',
            'Sleep 7.5+ hours to protect recovery and lean gain.',
          ],
          premiumAddOns: isPremium
              ? const [
                  'Weekly calorie progression plan.',
                  'Gym-day and rest-day meal splits.',
                  'Premium recipe smoothie pack.',
                ]
              : const [
                  'Upgrade to unlock training-day calorie progression and premium smoothies.',
                ],
        );
      case WellnessGoal.pcodThyroid:
        return DietPlan(
          goal: goal,
          title: 'Hormone Support Plan',
          description:
              'A stable-energy, anti-inflammatory structure designed for blood sugar support and sustainable nourishment.',
          dailyCalories: isPremium ? 1850 : 1750,
          hydrationGoalMl: 3100,
          proteinGrams: 110,
          carbsGrams: 180,
          fatsGrams: 65,
          meals: const [
            DietMeal(
              time: '7:00 AM',
              title: 'Balanced breakfast',
              description: 'Besan chilla, avocado dip, and herbal tea.',
              calories: 390,
            ),
            DietMeal(
              time: '12:30 PM',
              title: 'Glucose-friendly lunch',
              description:
                  'Brown rice, rajma, stir-fried greens, and probiotic curd.',
              calories: 540,
            ),
            DietMeal(
              time: '4:30 PM',
              title: 'Anti-inflammatory snack',
              description: 'Pumpkin seeds, apple slices, and cinnamon tea.',
              calories: 190,
            ),
            DietMeal(
              time: '8:00 PM',
              title: 'Calm evening meal',
              description: 'Khichdi with vegetables and tofu tikka.',
              calories: 510,
            ),
          ],
          coachNotes: const [
            'Pair carbohydrates with protein or fiber every time.',
            'Finish caffeine earlier in the day if cortisol feels elevated.',
            'Yoga, mobility, and breathwork are especially valuable here.',
          ],
          premiumAddOns: isPremium
              ? const [
                  'Symptom-trigger food journal prompts.',
                  'Hormone-friendly snack matrix.',
                  'Mentor review for irregular routine days.',
                ]
              : const [
                  'Upgrade to unlock symptom journaling prompts and mentor review support.',
                ],
        );
    }
  }

  static List<MediaContent> get mediaLibrary => const [
    MediaContent(
      id: 'yoga-1',
      title: 'Morning Fat Burn Flow',
      category: MediaCategory.yoga,
      description:
          'A gentle yoga sequence to wake up the body and improve mobility.',
      durationLabel: '18 min',
      level: 'Beginner',
      youtubeVideoId: 'v7AYKMP6rOE',
      imageUrl:
          'https://images.unsplash.com/photo-1518611012118-696072aa579a?auto=format&fit=crop&w=900&q=80',
      storageThumbnailPath: 'media/yoga/morning-fat-burn.jpg',
    ),
    MediaContent(
      id: 'yoga-2',
      title: 'Strength & Posture Yoga',
      category: MediaCategory.yoga,
      description: 'Build core stability and posture-friendly strength.',
      durationLabel: '24 min',
      level: 'Intermediate',
      youtubeVideoId: '4pKly2JojMw',
      imageUrl:
          'https://images.unsplash.com/photo-1506126613408-eca07ce68773?auto=format&fit=crop&w=900&q=80',
      storageThumbnailPath: 'media/yoga/strength-posture.jpg',
      isPremium: true,
    ),
    MediaContent(
      id: 'meditation-1',
      title: '5-Minute Stress Reset',
      category: MediaCategory.meditation,
      description:
          'Short guided meditation for busy mornings or anxious evenings.',
      durationLabel: '5 min',
      level: 'All levels',
      youtubeVideoId: 'inpok4MKVLM',
      imageUrl:
          'https://images.unsplash.com/photo-1508672019048-805c876b67e2?auto=format&fit=crop&w=900&q=80',
      storageThumbnailPath: 'media/meditation/stress-reset.jpg',
    ),
    MediaContent(
      id: 'meditation-2',
      title: 'Hormone Balance Breathwork',
      category: MediaCategory.meditation,
      description: 'Slow breath pacing to support calm energy and recovery.',
      durationLabel: '12 min',
      level: 'All levels',
      youtubeVideoId: 'aXItOY0sLRY',
      imageUrl:
          'https://images.unsplash.com/photo-1498837167922-ddd27525d352?auto=format&fit=crop&w=900&q=80',
      storageThumbnailPath: 'media/meditation/hormone-balance.jpg',
      isPremium: true,
    ),
    MediaContent(
      id: 'recipe-1',
      title: 'High Protein Veg Meal Prep',
      category: MediaCategory.recipes,
      description:
          'Easy weekly prep for calorie awareness and protein support.',
      durationLabel: '10 min',
      level: 'Easy',
      youtubeVideoId: '1N6hbRbyAeQ',
      imageUrl:
          'https://images.unsplash.com/photo-1490645935967-10de6ba17061?auto=format&fit=crop&w=900&q=80',
      storageThumbnailPath: 'media/recipes/protein-meal-prep.jpg',
    ),
    MediaContent(
      id: 'recipe-2',
      title: 'Premium Smoothie Booster Pack',
      category: MediaCategory.recipes,
      description:
          'Three recovery smoothies for goal-based performance and recovery.',
      durationLabel: '9 min',
      level: 'Easy',
      youtubeVideoId: 'M3b1QwY9mTs',
      imageUrl:
          'https://images.unsplash.com/photo-1547592180-85f173990554?auto=format&fit=crop&w=900&q=80',
      storageThumbnailPath: 'media/recipes/smoothie-booster.jpg',
      isPremium: true,
    ),
  ];

  static List<MentorSession> get mentorSessions => const [
    MentorSession(
      id: 'mentor-1',
      title: 'Metabolic Reset Q&A',
      coachName: 'Dr. Rhea Kulkarni',
      timeLabel: 'Sat, 8:00 AM',
      focus: 'Weight loss, cravings, and lifestyle adherence',
      zoomUrl: AppConfig.defaultMentorJoinUrl,
    ),
    MentorSession(
      id: 'mentor-2',
      title: 'Lean Gain Group Coaching',
      coachName: 'Coach Arjun Patel',
      timeLabel: 'Sun, 7:30 PM',
      focus: 'Strength nutrition and recovery habits',
      zoomUrl: AppConfig.defaultMentorJoinUrl,
    ),
    MentorSession(
      id: 'mentor-3',
      title: 'Hormone Harmony Workshop',
      coachName: 'Coach Simran Bedi',
      timeLabel: 'Wed, 6:00 PM',
      focus: 'PCOD, thyroid, stress, and sustainable routines',
      zoomUrl: AppConfig.defaultMentorJoinUrl,
    ),
  ];

  static List<ProductRecommendation> get products => const [
    ProductRecommendation(
      id: 'wl-1',
      goal: WellnessGoal.weightLoss,
      name: 'Lean Protein Starter',
      description: 'Helps support fullness and post-workout recovery.',
      priceLabel: 'INR 1,499',
      rating: 4.8,
      imageUrl:
          'https://images.unsplash.com/photo-1593095948071-474c5cc2989d?auto=format&fit=crop&w=900&q=80',
      benefits: ['High protein', 'Low sugar', 'Easy breakfast add-on'],
      purchaseUrl: 'https://example.com/lean-protein',
    ),
    ProductRecommendation(
      id: 'wg-1',
      goal: WellnessGoal.weightGain,
      name: 'Performance Trail Mix Kit',
      description: 'Dense calories for quick snack additions between meals.',
      priceLabel: 'INR 899',
      rating: 4.6,
      imageUrl:
          'https://images.unsplash.com/photo-1505576399279-565b52d4ac71?auto=format&fit=crop&w=900&q=80',
      benefits: ['Healthy fats', 'Portable calories', 'Training-friendly'],
      purchaseUrl: 'https://example.com/performance-trail-mix',
      isPremiumPick: true,
    ),
    ProductRecommendation(
      id: 'pcod-1',
      goal: WellnessGoal.pcodThyroid,
      name: 'Hormone Support Grocery Box',
      description: 'Curated pantry staples for anti-inflammatory meal prep.',
      priceLabel: 'INR 1,999',
      rating: 4.9,
      imageUrl:
          'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?auto=format&fit=crop&w=900&q=80',
      benefits: [
        'Fiber-rich staples',
        'Low prep effort',
        'Mentor-approved bundle',
      ],
      purchaseUrl: 'https://example.com/hormone-support-box',
      isPremiumPick: true,
    ),
  ];

  static List<String> promptsFor(WellnessGoal goal) {
    switch (goal) {
      case WellnessGoal.weightLoss:
        return const [
          'How can I stop evening cravings?',
          'Suggest a 20-minute home workout.',
          'What should I eat after office hours?',
        ];
      case WellnessGoal.weightGain:
        return const [
          'How do I eat more without feeling too full?',
          'Give me a post-workout recovery meal.',
          'What should I track besides calories?',
        ];
      case WellnessGoal.pcodThyroid:
        return const [
          'How do I balance meals for stable energy?',
          'Plan a low-stress evening routine.',
          'What yoga works best for hormonal health?',
        ];
    }
  }

  static String introFor(WellnessGoal goal) {
    return switch (goal) {
      WellnessGoal.weightLoss =>
        'Hi, I am FitMitra AI. I can help you with fat-loss-friendly meals, cravings, steps, workouts, and sustainable habit coaching.',
      WellnessGoal.weightGain =>
        'Hi, I am FitMitra AI. Ask me about lean gain nutrition, strength recovery, calorie boosting tactics, and training-friendly routines.',
      WellnessGoal.pcodThyroid =>
        'Hi, I am FitMitra AI. I can support hormone-aware meals, stress reduction, yoga routines, and energy-stable planning.',
    };
  }

  static String aiResponseFor(
    String input,
    WellnessGoal goal, {
    required bool isPremium,
  }) {
    final lower = input.toLowerCase();
    final premiumLine = isPremium
        ? 'Because you are premium, I would also surface mentor questions and personalized swaps in the next step.'
        : 'Upgrade to premium if you want mentor-reviewed swaps and deeper personalization.';

    if (lower.contains('water') || lower.contains('hydration')) {
      return 'Aim to spread hydration across the day instead of catching up at night. Pair each meal with 300 to 400 ml of water and add one extra glass after activity. $premiumLine';
    }
    if (lower.contains('crav') || lower.contains('snack')) {
      return 'Cravings usually improve when breakfast contains protein, lunch has enough fiber, and dinner is not skipped. Build your next snack around protein plus crunch, such as roasted chana with fruit or yogurt with seeds. $premiumLine';
    }
    if (lower.contains('stress') || lower.contains('sleep')) {
      return 'For recovery, reduce stimulating screens before bed, keep your final meal lighter than lunch, and spend 5 minutes on slow exhale breathing. This often helps consistency more than chasing perfect macros. $premiumLine';
    }

    return '${goal.coachPrompt} Start with one easy action today: build one balanced plate, move for 15 to 20 minutes, and log your water. If symptoms are severe or medical, consult a licensed clinician. $premiumLine';
  }
}
