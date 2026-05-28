import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/gradient_container.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class _Meal {
  final String name;
  final String emoji;
  final int calories;
  final double protein;
  final double carbs;
  final double fat;
  final List<String> items;
  final String time;

  const _Meal({
    required this.name,
    required this.emoji,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.items,
    required this.time,
  });
}

class DietScreen extends ConsumerStatefulWidget {
  const DietScreen({super.key});

  @override
  ConsumerState<DietScreen> createState() => _DietScreenState();
}

class _DietScreenState extends ConsumerState<DietScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedDay = 0;
  final _weekDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  final _meals = [
    _Meal(
      name: 'Breakfast',
      emoji: '🌅',
      calories: 380,
      protein: 18,
      carbs: 52,
      fat: 8,
      items: ['2 Besan Chilla', 'Mint Chutney', '1 Glass Milk', '1 Apple'],
      time: '7:00 - 8:30 AM',
    ),
    _Meal(
      name: 'Lunch',
      emoji: '☀️',
      calories: 520,
      protein: 24,
      carbs: 68,
      fat: 12,
      items: ['2 Roti', 'Dal Tadka', 'Mixed Veg Sabzi', 'Cucumber Raita', 'Salad'],
      time: '12:30 - 2:00 PM',
    ),
    _Meal(
      name: 'Snack',
      emoji: '🍎',
      calories: 180,
      protein: 6,
      carbs: 28,
      fat: 4,
      items: ['1 Banana', 'Handful Almonds (10 pcs)', '1 Coconut Water'],
      time: '4:00 - 5:00 PM',
    ),
    _Meal(
      name: 'Dinner',
      emoji: '🌙',
      calories: 420,
      protein: 20,
      carbs: 56,
      fat: 9,
      items: ['Quinoa Pulao', 'Palak Paneer (small)', 'Cucumber Salad', 'Curd'],
      time: '7:30 - 8:30 PM',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _selectedDay = DateTime.now().weekday - 1;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(currentUserProvider);
    final goal = userAsync.valueOrNull?.healthGoal ?? 'Weight Loss';
    final totalCalories = _meals.fold(0, (sum, m) => sum + m.calories);
    final calorieGoal = userAsync.valueOrNull?.dailyCalorieGoal ?? 2000;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Diet Plan'),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune_rounded),
            onPressed: () {},
            tooltip: 'Customize',
          ),
          IconButton(
            icon: const Icon(Icons.share_rounded),
            onPressed: () {},
            tooltip: 'Share',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Today\'s Plan'),
            Tab(text: 'Weekly'),
            Tab(text: 'My Macros'),
          ],
          indicatorColor: AppColors.primary,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textTertiary,
          labelStyle: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600, fontSize: 13),
          unselectedLabelStyle: const TextStyle(fontFamily: 'Poppins', fontSize: 13),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _DailyPlanTab(
            meals: _meals,
            goal: goal,
            totalCalories: totalCalories,
            calorieGoal: calorieGoal,
          ),
          _WeeklyTab(
            weekDays: _weekDays,
            selectedDay: _selectedDay,
            onDaySelected: (i) => setState(() => _selectedDay = i),
            meals: _meals,
          ),
          _MacrosTab(
            meals: _meals,
            calorieGoal: calorieGoal,
            totalCalories: totalCalories,
          ),
        ],
      ),
    );
  }
}

class _DailyPlanTab extends StatelessWidget {
  final List<_Meal> meals;
  final String goal;
  final int totalCalories;
  final int calorieGoal;

  const _DailyPlanTab({
    required this.meals,
    required this.goal,
    required this.totalCalories,
    required this.calorieGoal,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Goal banner
          GradientContainer(
            gradient: AppColors.primaryGradient,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            child: Row(
              children: [
                const Text('🎯', style: TextStyle(fontSize: 32)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Your Goal Plan',
                        style: TextStyle(color: Colors.white70, fontSize: 12, fontFamily: 'Poppins'),
                      ),
                      Text(
                        goal,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '$totalCalories',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const Text(
                      'kcal today',
                      style: TextStyle(color: Colors.white70, fontSize: 12, fontFamily: 'Poppins'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text('Meal Plan', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          ...meals.map((meal) => _MealCard(meal: meal)),
          const SizedBox(height: 16),
          _WaterReminderCard(),
        ],
      ),
    );
  }
}

class _MealCard extends StatefulWidget {
  final _Meal meal;

  const _MealCard({required this.meal});

  @override
  State<_MealCard> createState() => _MealCardState();
}

class _MealCardState extends State<_MealCard> {
  bool _isExpanded = false;
  bool _isLogged = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _isLogged ? AppColors.primary : theme.colorScheme.outlineVariant,
          width: _isLogged ? 1.5 : 1,
        ),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.primaryContainer,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Center(
                      child: Text(widget.meal.emoji, style: const TextStyle(fontSize: 24)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.meal.name, style: theme.textTheme.titleMedium),
                        Text(
                          widget.meal.time,
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        '${widget.meal.calories} kcal',
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      const SizedBox(width: 8),
                      AnimatedRotation(
                        turns: _isExpanded ? 0.5 : 0,
                        duration: const Duration(milliseconds: 200),
                        child: const Icon(Icons.keyboard_arrow_down_rounded, size: 20),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (_isExpanded) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Items', style: theme.textTheme.labelMedium),
                  const SizedBox(height: 8),
                  ...widget.meal.items.map((item) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3),
                        child: Row(
                          children: [
                            const Icon(Icons.check_circle_outline_rounded,
                                size: 16, color: AppColors.primary),
                            const SizedBox(width: 8),
                            Text(item, style: theme.textTheme.bodyMedium),
                          ],
                        ),
                      )),
                  const SizedBox(height: 12),
                  // Macros row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _MacroChip('P', '${widget.meal.protein}g', Colors.blue),
                      _MacroChip('C', '${widget.meal.carbs}g', Colors.orange),
                      _MacroChip('F', '${widget.meal.fat}g', Colors.red),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => setState(() => _isLogged = true),
                      icon: Icon(_isLogged ? Icons.check_circle_rounded : Icons.add_circle_outline_rounded),
                      label: Text(_isLogged ? 'Logged ✓' : 'Log this Meal'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: _isLogged ? AppColors.success : AppColors.primary,
                        side: BorderSide(color: _isLogged ? AppColors.success : AppColors.primary),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _MacroChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _MacroChip(this.label, this.value, this.color);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(color: color, fontWeight: FontWeight.w700, fontSize: 14),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 12, fontFamily: 'Poppins', fontWeight: FontWeight.w500)),
      ],
    );
  }
}

class _WeeklyTab extends StatelessWidget {
  final List<String> weekDays;
  final int selectedDay;
  final ValueChanged<int> onDaySelected;
  final List<_Meal> meals;

  const _WeeklyTab({
    required this.weekDays,
    required this.selectedDay,
    required this.onDaySelected,
    required this.meals,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Week selector
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(
              7,
              (i) => GestureDetector(
                onTap: () => onDaySelected(i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 40,
                  height: 56,
                  decoration: BoxDecoration(
                    color: selectedDay == i ? AppColors.primary : Theme.of(context).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: selectedDay == i ? AppColors.primary : Theme.of(context).colorScheme.outlineVariant,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        weekDays[i],
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: selectedDay == i ? Colors.white : AppColors.textTertiary,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      Text(
                        '${i + 1}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: selectedDay == i ? Colors.white : AppColors.textPrimary,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: meals.length,
            itemBuilder: (context, i) => ListTile(
              leading: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(child: Text(meals[i].emoji, style: const TextStyle(fontSize: 22))),
              ),
              title: Text(meals[i].name, style: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600)),
              subtitle: Text('${meals[i].items.length} items · ${meals[i].calories} kcal'),
              trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
            ),
          ),
        ),
      ],
    );
  }
}

class _MacrosTab extends StatelessWidget {
  final List<_Meal> meals;
  final int calorieGoal;
  final int totalCalories;

  const _MacrosTab({required this.meals, required this.calorieGoal, required this.totalCalories});

  @override
  Widget build(BuildContext context) {
    final totalProtein = meals.fold(0.0, (s, m) => s + m.protein);
    final totalCarbs = meals.fold(0.0, (s, m) => s + m.carbs);
    final totalFat = meals.fold(0.0, (s, m) => s + m.fat);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CalorieCircle(consumed: totalCalories, goal: calorieGoal),
          const SizedBox(height: 24),
          Text('Macro Breakdown', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          _MacroBar(label: 'Protein', emoji: '🥩', value: totalProtein, goal: 80, color: Colors.blue),
          const SizedBox(height: 12),
          _MacroBar(label: 'Carbohydrates', emoji: '🌾', value: totalCarbs, goal: 250, color: Colors.orange),
          const SizedBox(height: 12),
          _MacroBar(label: 'Fat', emoji: '🥑', value: totalFat, goal: 65, color: Colors.red),
          const SizedBox(height: 12),
          _MacroBar(label: 'Fiber', emoji: '🥦', value: 18, goal: 25, color: Colors.green),
        ],
      ),
    );
  }
}

class _CalorieCircle extends StatelessWidget {
  final int consumed;
  final int goal;

  const _CalorieCircle({required this.consumed, required this.goal});

  @override
  Widget build(BuildContext context) {
    final progress = (consumed / goal).clamp(0.0, 1.0);
    final remaining = goal - consumed;

    return Center(
      child: SizedBox(
        width: 200,
        height: 200,
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox.expand(
              child: CircularProgressIndicator(
                value: progress,
                strokeWidth: 14,
                backgroundColor: AppColors.primaryContainer,
                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                strokeCap: StrokeCap.round,
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '$consumed',
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text('kcal consumed', style: Theme.of(context).textTheme.bodySmall),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: remaining > 0 ? AppColors.primaryContainer : AppColors.error.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${remaining.abs()} kcal ${remaining > 0 ? "left" : "over"}',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: remaining > 0 ? AppColors.primary : AppColors.error,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MacroBar extends StatelessWidget {
  final String label;
  final String emoji;
  final double value;
  final double goal;
  final Color color;

  const _MacroBar({
    required this.label,
    required this.emoji,
    required this.value,
    required this.goal,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final progress = (value / goal).clamp(0.0, 1.0);
    return Column(
      children: [
        Row(
          children: [
            Text(emoji),
            const SizedBox(width: 8),
            Expanded(child: Text(label, style: Theme.of(context).textTheme.titleSmall)),
            Text(
              '${value.toStringAsFixed(0)}g / ${goal.toStringAsFixed(0)}g',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: color, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 8,
            backgroundColor: color.withValues(alpha: 0.15),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}

class _WaterReminderCard extends StatelessWidget {
  const _WaterReminderCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE3F2FD),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Text('💧', style: TextStyle(fontSize: 32)),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Hydration Reminder', style: TextStyle(fontWeight: FontWeight.w600, fontFamily: 'Poppins')),
                Text('Drink water before each meal for better digestion!', style: TextStyle(fontSize: 12, color: AppColors.textSecondary, fontFamily: 'Poppins')),
              ],
            ),
          ),
          TextButton(
            onPressed: () {},
            child: const Text('Track'),
          ),
        ],
      ),
    );
  }
}
