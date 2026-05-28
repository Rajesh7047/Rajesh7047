import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';

class _Recipe {
  final String title;
  final String emoji;
  final int cookTimeMin;
  final int calories;
  final String category;
  final List<String> tags;
  final String description;
  final List<String> ingredients;
  final Color color;
  final bool isPremium;

  const _Recipe({
    required this.title,
    required this.emoji,
    required this.cookTimeMin,
    required this.calories,
    required this.category,
    required this.tags,
    required this.description,
    required this.ingredients,
    required this.color,
    this.isPremium = false,
  });
}

final _recipes = [
  _Recipe(
    title: 'High Protein Greek Salad',
    emoji: '🥗',
    cookTimeMin: 10,
    calories: 220,
    category: 'Salad',
    tags: ['Weight Loss', 'Quick', 'Vegetarian'],
    description: 'Fresh and nutritious salad packed with protein and fiber.',
    ingredients: ['Cucumber', 'Tomato', 'Feta', 'Olives', 'Lettuce'],
    color: AppColors.primary,
  ),
  _Recipe(
    title: 'Dal Khichdi (Detox)',
    emoji: '🍲',
    cookTimeMin: 25,
    calories: 310,
    category: 'Main Course',
    tags: ['Detox', 'PCOD', 'Vegan'],
    description: 'Comforting and nutritious one-pot meal, easy to digest.',
    ingredients: ['Moong Dal', 'Rice', 'Ghee', 'Turmeric', 'Cumin'],
    color: const Color(0xFFFF9800),
    isPremium: true,
  ),
  _Recipe(
    title: 'Spinach Smoothie',
    emoji: '🥤',
    cookTimeMin: 5,
    calories: 165,
    category: 'Smoothie',
    tags: ['Weight Loss', 'Thyroid', 'Quick'],
    description: 'Power-packed green smoothie to kickstart your metabolism.',
    ingredients: ['Spinach', 'Banana', 'Almond Milk', 'Chia Seeds'],
    color: AppColors.success,
  ),
  _Recipe(
    title: 'Oats Upma',
    emoji: '🥣',
    cookTimeMin: 15,
    calories: 270,
    category: 'Breakfast',
    tags: ['Weight Loss', 'Fiber Rich', 'Vegetarian'],
    description: 'Healthy twist on classic upma using rolled oats.',
    ingredients: ['Rolled Oats', 'Veggies', 'Mustard Seeds', 'Curry Leaves'],
    color: AppColors.accent,
  ),
  _Recipe(
    title: 'Grilled Paneer Bowl',
    emoji: '🫕',
    cookTimeMin: 20,
    calories: 380,
    category: 'Main Course',
    tags: ['Weight Gain', 'High Protein', 'Vegetarian'],
    description: 'High protein grilled paneer with quinoa and veggies.',
    ingredients: ['Paneer', 'Quinoa', 'Bell Pepper', 'Spices', 'Olive Oil'],
    color: AppColors.secondary,
    isPremium: true,
  ),
  _Recipe(
    title: 'Ragi Ladoo',
    emoji: '🍡',
    cookTimeMin: 30,
    calories: 140,
    category: 'Snack',
    tags: ['PCOD', 'Calcium Rich', 'Vegan'],
    description: 'Traditional calcium-rich snack perfect for bone health.',
    ingredients: ['Ragi Flour', 'Jaggery', 'Cardamom', 'Ghee', 'Nuts'],
    color: const Color(0xFF8D6E63),
  ),
];

final _recipeCategories = ['All', 'Breakfast', 'Main Course', 'Salad', 'Smoothie', 'Snack'];

class RecipesScreen extends ConsumerStatefulWidget {
  const RecipesScreen({super.key});

  @override
  ConsumerState<RecipesScreen> createState() => _RecipesScreenState();
}

class _RecipesScreenState extends ConsumerState<RecipesScreen> {
  String _selectedCategory = 'All';
  final _searchController = TextEditingController();
  String _searchQuery = '';

  List<_Recipe> get _filtered => _recipes.where((r) {
        final catMatch = _selectedCategory == 'All' || r.category == _selectedCategory;
        final searchMatch = _searchQuery.isEmpty ||
            r.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            r.tags.any((t) => t.toLowerCase().contains(_searchQuery.toLowerCase()));
        return catMatch && searchMatch;
      }).toList();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Healthy Recipes')),
      body: CustomScrollView(
        slivers: [
          // Search bar
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: TextField(
                controller: _searchController,
                onChanged: (v) => setState(() => _searchQuery = v),
                decoration: InputDecoration(
                  hintText: 'Search recipes...',
                  prefixIcon: const Icon(Icons.search_rounded),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear_rounded),
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _searchQuery = '');
                          },
                        )
                      : null,
                ),
              ),
            ),
          ),

          // Category chips
          SliverToBoxAdapter(
            child: SizedBox(
              height: 40,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _recipeCategories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, i) {
                  final cat = _recipeCategories[i];
                  final isSelected = _selectedCategory == cat;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedCategory = cat),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primary : theme.colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected ? AppColors.primary : theme.colorScheme.outlineVariant,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          cat,
                          style: TextStyle(
                            color: isSelected ? Colors.white : AppColors.textSecondary,
                            fontSize: 13,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 16)),

          // Results count
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              child: Text(
                '${_filtered.length} recipes found',
                style: theme.textTheme.bodySmall,
              ),
            ),
          ),

          // Recipes grid
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, i) => _RecipeCard(recipe: _filtered[i]),
                childCount: _filtered.length,
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),
    );
  }
}

class _RecipeCard extends StatelessWidget {
  final _Recipe recipe;

  const _RecipeCard({required this.recipe});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () => _showRecipeDetails(context),
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: theme.colorScheme.outlineVariant),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: 110,
                  decoration: BoxDecoration(
                    color: recipe.color.withValues(alpha: 0.12),
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                  child: Center(
                    child: Text(recipe.emoji, style: const TextStyle(fontSize: 52)),
                  ),
                ),
                if (recipe.isPremium)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        gradient: AppColors.premiumGradient,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.workspace_premium_rounded, color: Colors.white, size: 10),
                          SizedBox(width: 2),
                          Text('PRO', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w700, fontFamily: 'Poppins')),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe.title,
                    style: theme.textTheme.titleSmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.timer_outlined, size: 12, color: AppColors.textTertiary),
                      const SizedBox(width: 3),
                      Text('${recipe.cookTimeMin}m', style: theme.textTheme.labelSmall),
                      const SizedBox(width: 10),
                      const Icon(Icons.local_fire_department_outlined, size: 12, color: AppColors.accent),
                      const SizedBox(width: 3),
                      Text('${recipe.calories} kcal', style: theme.textTheme.labelSmall?.copyWith(color: AppColors.accent)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 4,
                    runSpacing: 4,
                    children: recipe.tags.take(2).map((tag) => Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: recipe.color.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            tag,
                            style: TextStyle(fontSize: 9, color: recipe.color, fontWeight: FontWeight.w500, fontFamily: 'Poppins'),
                          ),
                        )).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showRecipeDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.95,
        minChildSize: 0.4,
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(recipe.emoji, style: const TextStyle(fontSize: 56)),
              const SizedBox(height: 12),
              Text(recipe.title, style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 8),
              Text(recipe.description, style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: 16),
              Row(
                children: [
                  _InfoChip(Icons.timer_outlined, '${recipe.cookTimeMin} min', recipe.color),
                  const SizedBox(width: 12),
                  _InfoChip(Icons.local_fire_department_outlined, '${recipe.calories} kcal', AppColors.accent),
                ],
              ),
              const SizedBox(height: 20),
              Text('Ingredients', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              ...recipe.ingredients.map((ing) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        Icon(Icons.fiber_manual_record_rounded, size: 8, color: recipe.color),
                        const SizedBox(width: 10),
                        Text(ing, style: Theme.of(context).textTheme.bodyMedium),
                      ],
                    ),
                  )),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.bookmark_outline_rounded),
                label: const Text('Save Recipe'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _InfoChip(this.icon, this.label, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w500, fontFamily: 'Poppins')),
        ],
      ),
    );
  }
}
