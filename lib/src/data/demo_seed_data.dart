import '../domain/models.dart';

class DemoSeedData {
  const DemoSeedData._();

  static DietPlan dietPlan(HealthGoal goal) => switch (goal) {
        HealthGoal.weightLoss => const DietPlan(
            goal: HealthGoal.weightLoss,
            name: 'Lean Energy Plan',
            summary: 'High-fiber Indian meals with steady protein and low-glycemic carbs.',
            waterTargetMl: 2800,
            calorieTarget: 1650,
            meals: <DietMeal>[
              DietMeal(
                title: 'Morning detox bowl',
                description: 'Greek yogurt, chia, berries, flax, and cinnamon.',
                calories: 320,
                proteinGrams: 22,
              ),
              DietMeal(
                title: 'Balanced lunch thali',
                description: 'Millet roti, dal, paneer bhurji, cucumber salad.',
                calories: 520,
                proteinGrams: 34,
              ),
              DietMeal(
                title: 'Light dinner soup',
                description: 'Moong soup, sauteed greens, tofu tikka.',
                calories: 430,
                proteinGrams: 31,
              ),
            ],
          ),
        HealthGoal.weightGain => const DietPlan(
            goal: HealthGoal.weightGain,
            name: 'Strength Gain Plan',
            summary: 'Calorie surplus with nutrient-dense snacks and strength recovery support.',
            waterTargetMl: 3200,
            calorieTarget: 2450,
            meals: <DietMeal>[
              DietMeal(
                title: 'Power breakfast',
                description: 'Oats, banana, peanut butter, milk, and seeds.',
                calories: 640,
                proteinGrams: 30,
              ),
              DietMeal(
                title: 'Muscle lunch bowl',
                description: 'Rice, rajma, paneer, avocado, and curd.',
                calories: 790,
                proteinGrams: 42,
              ),
              DietMeal(
                title: 'Recovery dinner',
                description: 'Quinoa khichdi, egg bhurji or tofu, beet salad.',
                calories: 610,
                proteinGrams: 38,
              ),
            ],
          ),
        HealthGoal.pcodThyroid => const DietPlan(
            goal: HealthGoal.pcodThyroid,
            name: 'Hormone Balance Plan',
            summary: 'Anti-inflammatory meals built around fiber, protein, iron, and stable glucose.',
            waterTargetMl: 3000,
            calorieTarget: 1850,
            meals: <DietMeal>[
              DietMeal(
                title: 'Seed cycling breakfast',
                description: 'Besan chilla, curd, pumpkin seeds, and mint chutney.',
                calories: 390,
                proteinGrams: 27,
              ),
              DietMeal(
                title: 'Low-GI lunch plate',
                description: 'Brown rice, chana, spinach, carrots, and raita.',
                calories: 560,
                proteinGrams: 30,
              ),
              DietMeal(
                title: 'Thyroid-support dinner',
                description: 'Lentil stew, sauteed vegetables, paneer or tofu.',
                calories: 500,
                proteinGrams: 35,
              ),
            ],
          ),
      };

  static List<WellnessContent> content = <WellnessContent>[
    const WellnessContent(
      id: 'yoga-sunrise-flow',
      title: 'Sunrise Fat-Burn Yoga Flow',
      type: ContentType.yoga,
      durationMinutes: 24,
      imageUrl: 'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=1200',
      videoUrl: 'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
      isPremium: false,
      goals: <HealthGoal>[HealthGoal.weightLoss, HealthGoal.pcodThyroid],
      description: 'A joint-friendly flow for metabolism, mobility, and stress relief.',
    ),
    const WellnessContent(
      id: 'yoga-strength-gain',
      title: 'Strength Mobility for Healthy Gain',
      type: ContentType.yoga,
      durationMinutes: 32,
      imageUrl: 'https://images.unsplash.com/photo-1599901860904-17e6ed7083a0?w=1200',
      videoUrl: 'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
      isPremium: true,
      goals: <HealthGoal>[HealthGoal.weightGain],
      description: 'Mobility and breathing drills to support progressive strength training.',
    ),
    const WellnessContent(
      id: 'meditation-sleep-reset',
      title: 'Deep Sleep Reset Meditation',
      type: ContentType.meditation,
      durationMinutes: 15,
      imageUrl: 'https://images.unsplash.com/photo-1506126613408-eca07ce68773?w=1200',
      videoUrl: 'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
      isPremium: false,
      goals: <HealthGoal>[HealthGoal.weightLoss, HealthGoal.weightGain, HealthGoal.pcodThyroid],
      description: 'Breath-led meditation for better recovery and evening cravings.',
    ),
    const WellnessContent(
      id: 'recipe-protein-poha',
      title: 'Protein Poha Recipe',
      type: ContentType.recipe,
      durationMinutes: 9,
      imageUrl: 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=1200',
      videoUrl: 'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
      isPremium: true,
      goals: <HealthGoal>[HealthGoal.weightLoss, HealthGoal.pcodThyroid],
      description: 'A quick high-protein Indian breakfast recipe with macro swaps.',
    ),
  ];

  static List<MentorSession> sessions = <MentorSession>[
    MentorSession(
      id: 'mentor-ask-dietitian',
      title: 'Ask a Dietitian: Indian Meal Planning',
      mentorName: 'Dr. Meera Kapoor',
      startsAt: DateTime.now().add(const Duration(days: 1, hours: 2)),
      zoomUrl: 'https://zoom.us/j/0000000000',
      isPremium: false,
    ),
    MentorSession(
      id: 'mentor-pcod-circle',
      title: 'PCOD and Thyroid Support Circle',
      mentorName: 'Coach Ananya Rao',
      startsAt: DateTime.now().add(const Duration(days: 3, hours: 5)),
      zoomUrl: 'https://zoom.us/j/1111111111',
      isPremium: true,
    ),
  ];

  static List<ProductRecommendation> products(HealthGoal goal) {
    final all = <ProductRecommendation>[
      const ProductRecommendation(
        id: 'plant-protein-clean',
        name: 'Clean Plant Protein',
        goal: HealthGoal.weightLoss,
        reason: 'Keeps meals protein-rich without adding excess calories.',
        imageUrl: 'https://images.unsplash.com/photo-1593095948071-474c5cc2989d?w=1200',
        priceInr: 1499,
        productUrl: 'https://example.com/products/plant-protein',
      ),
      const ProductRecommendation(
        id: 'mass-gain-smoothie-kit',
        name: 'Healthy Gain Smoothie Kit',
        goal: HealthGoal.weightGain,
        reason: 'Nuts, seeds, and measured scoops for calorie-dense smoothies.',
        imageUrl: 'https://images.unsplash.com/photo-1553530666-ba11a7da3888?w=1200',
        priceInr: 1799,
        productUrl: 'https://example.com/products/gain-kit',
      ),
      const ProductRecommendation(
        id: 'hormone-balance-tea',
        name: 'Spearmint Balance Tea',
        goal: HealthGoal.pcodThyroid,
        reason: 'Caffeine-light hydration ritual for cravings and stress support.',
        imageUrl: 'https://images.unsplash.com/photo-1544787219-7f47ccb76574?w=1200',
        priceInr: 599,
        productUrl: 'https://example.com/products/balance-tea',
      ),
    ];
    return all.where((item) => item.goal == goal).toList();
  }
}
