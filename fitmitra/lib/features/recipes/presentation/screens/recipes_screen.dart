import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/custom_card.dart';

class RecipesScreen extends StatefulWidget {
  const RecipesScreen({super.key});

  @override
  State<RecipesScreen> createState() => _RecipesScreenState();
}

class _RecipesScreenState extends State<RecipesScreen> {
  String _selectedCategory = 'All';

  @override
  Widget build(BuildContext context) {
    final filtered = _selectedCategory == 'All'
        ? recipes
        : recipes.where((r) => r['category'] == _selectedCategory).toList();

    return Scaffold(
      appBar: const CustomAppBar(title: 'Healthy Recipes'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ['All', 'Breakfast', 'Lunch', 'Dinner', 'Snacks', 'Drinks'].map((cat) {
                  final isSelected = _selectedCategory == cat;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(cat),
                      selected: isSelected,
                      onSelected: (_) => setState(() => _selectedCategory = cat),
                      selectedColor: AppColors.primary.withOpacity(0.2),
                      labelStyle: TextStyle(color: isSelected ? AppColors.primary : null, fontWeight: isSelected ? FontWeight.w600 : null),
                    ),
                  );
                }).toList(),
              ),
            ).animate().fadeIn(),
            const SizedBox(height: 16),

            ...filtered.asMap().entries.map((entry) {
              final recipe = entry.value;
              return CustomCard(
                animationIndex: entry.key,
                onTap: () => _showRecipeDetail(context, recipe),
                child: Row(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: (recipe['color'] as Color).withOpacity(0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(recipe['icon'] as IconData, color: recipe['color'] as Color, size: 36),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(recipe['title'] as String, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                              ),
                              if (recipe['isVeg'] == true)
                                Container(
                                  padding: const EdgeInsets.all(2),
                                  decoration: BoxDecoration(border: Border.all(color: Colors.green), borderRadius: BorderRadius.circular(4)),
                                  child: const Icon(Icons.circle, color: Colors.green, size: 8),
                                ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(recipe['desc'] as String, style: Theme.of(context).textTheme.bodySmall, maxLines: 2, overflow: TextOverflow.ellipsis),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              _buildRecipeInfo(Icons.timer_outlined, recipe['time'] as String),
                              const SizedBox(width: 12),
                              _buildRecipeInfo(Icons.local_fire_department, '${recipe['calories']} kcal'),
                              const SizedBox(width: 12),
                              _buildRecipeInfo(Icons.restaurant, recipe['category'] as String),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildRecipeInfo(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: AppColors.textSecondaryLight),
        const SizedBox(width: 3),
        Text(text, style: const TextStyle(fontSize: 11, color: AppColors.textSecondaryLight)),
      ],
    );
  }

  void _showRecipeDetail(BuildContext context, Map<String, dynamic> recipe) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)))),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                height: 160,
                decoration: BoxDecoration(
                  color: (recipe['color'] as Color).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(recipe['icon'] as IconData, color: recipe['color'] as Color, size: 64),
              ),
              const SizedBox(height: 16),
              Text(recipe['title'] as String, style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 8),
              Text(recipe['desc'] as String, style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildDetailStat(Icons.timer_outlined, recipe['time'] as String, 'Duration'),
                  _buildDetailStat(Icons.local_fire_department, '${recipe['calories']}', 'Calories'),
                  _buildDetailStat(Icons.restaurant, recipe['servings'] as String, 'Servings'),
                ],
              ),
              const SizedBox(height: 20),
              Text('Ingredients', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 8),
              ...(recipe['ingredients'] as List<String>).map((i) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle_rounded, size: 16, color: AppColors.success),
                        const SizedBox(width: 8),
                        Text(i),
                      ],
                    ),
                  )),
              const SizedBox(height: 16),
              Text('Instructions', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 8),
              ...(recipe['steps'] as List<String>).asMap().entries.map((e) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(radius: 12, backgroundColor: AppColors.primary, child: Text('${e.key + 1}', style: const TextStyle(color: Colors.white, fontSize: 12))),
                        const SizedBox(width: 10),
                        Expanded(child: Text(e.value)),
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailStat(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primary, size: 24),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
        Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textSecondaryLight)),
      ],
    );
  }

  static final List<Map<String, dynamic>> recipes = [
    {'title': 'Masala Oats Upma', 'desc': 'Protein-rich breakfast with vegetables and spices', 'category': 'Breakfast', 'time': '15 min', 'calories': 220, 'servings': '2', 'isVeg': true, 'color': const Color(0xFFFF9800), 'icon': Icons.rice_bowl_rounded,
      'ingredients': ['1 cup oats', '1 onion chopped', '1 tomato chopped', 'Mixed vegetables', 'Mustard seeds, curry leaves', 'Turmeric, salt to taste'],
      'steps': ['Dry roast oats for 2 minutes', 'Heat oil, add mustard seeds and curry leaves', 'Add onion and sauté till golden', 'Add vegetables, tomato and spices', 'Add 2 cups water, bring to boil', 'Add oats, cook for 3-4 minutes', 'Garnish with coriander and serve']},
    {'title': 'Quinoa Salad Bowl', 'desc': 'Nutrient-dense lunch with mixed greens and quinoa', 'category': 'Lunch', 'time': '20 min', 'calories': 380, 'servings': '2', 'isVeg': true, 'color': const Color(0xFF4CAF50), 'icon': Icons.eco_rounded,
      'ingredients': ['1 cup quinoa cooked', 'Mixed greens (spinach, lettuce)', 'Cucumber, cherry tomatoes', 'Avocado', 'Lemon dressing', 'Roasted pumpkin seeds'],
      'steps': ['Cook quinoa as per instructions', 'Chop all vegetables', 'Mix greens with quinoa', 'Top with avocado slices', 'Drizzle lemon dressing', 'Sprinkle pumpkin seeds and serve']},
    {'title': 'Grilled Paneer Tikka', 'desc': 'High-protein dinner with aromatic spices', 'category': 'Dinner', 'time': '30 min', 'calories': 320, 'servings': '3', 'isVeg': true, 'color': const Color(0xFFF44336), 'icon': Icons.outdoor_grill_rounded,
      'ingredients': ['200g paneer cubed', 'Thick curd - 1/2 cup', 'Bell peppers, onions', 'Tikka masala, red chilli powder', 'Ginger-garlic paste', 'Lemon juice'],
      'steps': ['Marinate paneer with curd and spices', 'Let it rest for 30 minutes', 'Thread onto skewers with vegetables', 'Grill on high heat for 8-10 minutes', 'Turn occasionally for even cooking', 'Serve hot with green chutney']},
    {'title': 'Roasted Makhana', 'desc': 'Crunchy, guilt-free low-calorie snack', 'category': 'Snacks', 'time': '10 min', 'calories': 120, 'servings': '2', 'isVeg': true, 'color': const Color(0xFF9C27B0), 'icon': Icons.cookie_rounded,
      'ingredients': ['2 cups makhana (fox nuts)', '1 tsp ghee', 'Salt, black pepper', 'Chaat masala', 'Turmeric (optional)'],
      'steps': ['Heat ghee in a pan', 'Add makhana and roast on low heat', 'Stir continuously for 5-7 minutes', 'Add salt, pepper and chaat masala', 'Let cool and store in airtight container']},
    {'title': 'Turmeric Golden Milk', 'desc': 'Anti-inflammatory bedtime drink for recovery', 'category': 'Drinks', 'time': '5 min', 'calories': 90, 'servings': '1', 'isVeg': true, 'color': const Color(0xFFFF9800), 'icon': Icons.local_cafe_rounded,
      'ingredients': ['1 cup warm milk', '1/2 tsp turmeric', '1/4 tsp cinnamon', 'Pinch of black pepper', '1 tsp honey (optional)'],
      'steps': ['Heat milk in a saucepan', 'Add turmeric and cinnamon', 'Add a pinch of black pepper', 'Stir well and bring to gentle boil', 'Pour in cup and add honey if desired']},
  ];
}
