import 'package:fitmitra/domain/entities/diet_plan.dart';
import 'package:fitmitra/domain/entities/mentor_session.dart';
import 'package:fitmitra/domain/entities/product.dart';
import 'package:fitmitra/domain/entities/wellness_video.dart';

/// Seed content used when Firestore is empty or in demo mode.
class DemoContentData {
  DemoContentData._();

  static List<DietPlan> dietPlans(String? goalId) {
    final goal = goalId ?? 'general_wellness';
    return [
      DietPlan(
        id: 'diet_$goal',
        title: 'Personalized Plan — ${goal.replaceAll('_', ' ')}',
        goalId: goal,
        summary: 'AI-curated macros aligned with your wellness goal.',
        meals: const [
          DietMeal(
            name: 'Breakfast',
            calories: 420,
            time: '8:00 AM',
            items: ['Oats with berries', 'Green tea', 'Soaked almonds'],
          ),
          DietMeal(
            name: 'Lunch',
            calories: 550,
            time: '1:00 PM',
            items: ['Grilled protein bowl', 'Quinoa', 'Seasonal salad'],
          ),
          DietMeal(
            name: 'Snack',
            calories: 180,
            time: '5:00 PM',
            items: ['Greek yogurt', 'Walnuts'],
          ),
          DietMeal(
            name: 'Dinner',
            calories: 480,
            time: '8:00 PM',
            items: ['Light dal & veggies', 'Multigrain roti'],
          ),
        ],
      ),
    ];
  }

  static List<WellnessVideo> videos(VideoCategory category) {
    final base = 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample';
    return switch (category) {
      VideoCategory.yoga => [
        WellnessVideo(
          id: 'yoga_1',
          title: 'Morning Sun Salutation',
          category: category,
          thumbnailUrl:
              'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=400',
          videoUrl: '$base/BigBuckBunny.mp4',
          durationMinutes: 20,
          instructor: 'Ananya Sharma',
        ),
        WellnessVideo(
          id: 'yoga_2',
          title: 'PCOD Gentle Flow',
          category: category,
          thumbnailUrl:
              'https://images.unsplash.com/photo-1506126613408-eca07ce68773?w=400',
          videoUrl: '$base/ElephantsDream.mp4',
          durationMinutes: 25,
          isPremiumOnly: true,
          instructor: 'Dr. Meera Patel',
        ),
      ],
      VideoCategory.meditation => [
        WellnessVideo(
          id: 'med_1',
          title: '10-Min Stress Relief',
          category: category,
          thumbnailUrl:
              'https://images.unsplash.com/photo-1508672019048-805c864b0a0a?w=400',
          videoUrl: '$base/ForBiggerBlazes.mp4',
          durationMinutes: 10,
        ),
        WellnessVideo(
          id: 'med_2',
          title: 'Deep Sleep Meditation',
          category: category,
          thumbnailUrl:
              'https://images.unsplash.com/photo-1499203537060-32ddad112fb4?w=400',
          videoUrl: '$base/ForBiggerEscapes.mp4',
          durationMinutes: 15,
          isPremiumOnly: true,
        ),
      ],
      VideoCategory.recipe => [
        WellnessVideo(
          id: 'recipe_1',
          title: 'High-Protein Smoothie Bowl',
          category: category,
          thumbnailUrl:
              'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=400',
          videoUrl: '$base/ForBiggerFun.mp4',
          durationMinutes: 8,
        ),
        WellnessVideo(
          id: 'recipe_2',
          title: 'Thyroid-Friendly Khichdi',
          category: category,
          thumbnailUrl:
              'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=400',
          videoUrl: '$base/ForBiggerJoyrides.mp4',
          durationMinutes: 12,
          isPremiumOnly: true,
        ),
      ],
    };
  }

  static List<WellnessProduct> products(String? goalId) {
    final all = [
      const WellnessProduct(
        id: 'p1',
        name: 'Lean Burn Protein',
        description: 'Plant protein for weight loss goals',
        priceInPaise: 149900,
        imageUrl:
            'https://images.unsplash.com/photo-1593095948071-474c5cc2989d?w=400',
        goalIds: ['weight_loss'],
        tag: 'Bestseller',
      ),
      const WellnessProduct(
        id: 'p2',
        name: 'Mass Gain Gainer',
        description: 'Clean carbs + protein for healthy weight gain',
        priceInPaise: 199900,
        imageUrl:
            'https://images.unsplash.com/photo-1571019614242-c5c5dee9f50e?w=400',
        goalIds: ['weight_gain'],
      ),
      const WellnessProduct(
        id: 'p3',
        name: 'PCOD Balance Tea',
        description: 'Spearmint & cinnamon blend for hormonal balance',
        priceInPaise: 49900,
        imageUrl:
            'https://images.unsplash.com/photo-1556679343-c7306c1976bc?w=400',
        goalIds: ['pcod_thyroid'],
      ),
      const WellnessProduct(
        id: 'p4',
        name: 'Thyroid Support Multivitamin',
        description: 'Selenium, zinc & iodine support',
        priceInPaise: 89900,
        imageUrl:
            'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=400',
        goalIds: ['pcod_thyroid'],
      ),
    ];
    if (goalId == null) return all;
    return all.where((p) => p.goalIds.contains(goalId)).toList();
  }

  static List<MentorSession> sessions() => [
        MentorSession(
          id: 'session_1',
          title: 'Weekly Nutrition Q&A',
          mentorName: 'Dr. Priya Nair',
          scheduledAt: DateTime.now().add(const Duration(days: 2, hours: 10)),
          zoomJoinUrl: 'https://zoom.us/j/00000000000',
        ),
        MentorSession(
          id: 'session_2',
          title: 'Yoga for PCOD — Live Class',
          mentorName: 'Ananya Sharma',
          scheduledAt: DateTime.now().add(const Duration(days: 5, hours: 7)),
          zoomJoinUrl: 'https://zoom.us/j/00000000001',
        ),
      ];
}
