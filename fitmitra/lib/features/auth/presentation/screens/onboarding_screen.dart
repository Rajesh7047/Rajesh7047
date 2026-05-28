import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';

class OnboardingPage {
  final String emoji;
  final String title;
  final String subtitle;
  final Color backgroundColor;
  final Color accentColor;

  const OnboardingPage({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.backgroundColor,
    required this.accentColor,
  });
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  final _pageController = PageController();
  int _currentPage = 0;
  late AnimationController _animController;

  final _pages = const [
    OnboardingPage(
      emoji: '🥗',
      title: 'Personalized\nDiet Plans',
      subtitle: 'Get AI-curated meal plans tailored to your health goals — Weight Loss, Gain, PCOD & more.',
      backgroundColor: Color(0xFFE8FAF4),
      accentColor: AppColors.primary,
    ),
    OnboardingPage(
      emoji: '🧘‍♀️',
      title: 'Yoga &\nMeditation',
      subtitle: 'Expert-guided yoga sessions and meditation practices for a balanced mind and body.',
      backgroundColor: Color(0xFFEDE7FF),
      accentColor: AppColors.secondary,
    ),
    OnboardingPage(
      emoji: '💬',
      title: 'AI Health\nAssistant',
      subtitle: 'Chat with FitMitra AI anytime — your 24/7 health & nutrition expert, always ready.',
      backgroundColor: Color(0xFFFFE5DA),
      accentColor: AppColors.accent,
    ),
    OnboardingPage(
      emoji: '📊',
      title: 'Track Your\nProgress',
      subtitle: 'Monitor calories, water intake, and fitness streaks with beautiful visual dashboards.',
      backgroundColor: Color(0xFFE3F2FD),
      accentColor: Color(0xFF2196F3),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animController.dispose();
    super.dispose();
  }

  void _next() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: AppConstants.mediumDuration,
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.keyOnboardingDone, true);
    if (mounted) context.go(AppRoutes.phoneLogin);
  }

  @override
  Widget build(BuildContext context) {
    final page = _pages[_currentPage];

    return Scaffold(
      body: AnimatedContainer(
        duration: AppConstants.mediumDuration,
        color: page.backgroundColor,
        child: SafeArea(
          child: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextButton(
                    onPressed: _completeOnboarding,
                    child: Text(
                      'Skip',
                      style: TextStyle(
                        color: page.accentColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (i) {
                    setState(() => _currentPage = i);
                    _animController.forward(from: 0);
                  },
                  itemCount: _pages.length,
                  itemBuilder: (context, index) {
                    return _OnboardingPageView(page: _pages[index]);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: Column(
                  children: [
                    AnimatedSmoothIndicator(
                      activeIndex: _currentPage,
                      count: _pages.length,
                      effect: WormEffect(
                        dotHeight: 8,
                        dotWidth: 8,
                        activeDotColor: page.accentColor,
                        dotColor: page.accentColor.withValues(alpha: 0.2),
                        spacing: 6,
                      ),
                    ),
                    const SizedBox(height: 32),
                    AnimatedContainer(
                      duration: AppConstants.shortDuration,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [page.accentColor, page.accentColor.withValues(alpha: 0.8)],
                        ),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: page.accentColor.withValues(alpha: 0.35),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      height: 52,
                      child: ElevatedButton(
                        onPressed: _next,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          minimumSize: const Size(double.infinity, 52),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _currentPage == _pages.length - 1
                                  ? AppStrings.getStarted
                                  : AppStrings.next,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            if (_currentPage < _pages.length - 1) ...[
                              const SizedBox(width: 8),
                              const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 18),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OnboardingPageView extends StatelessWidget {
  final OnboardingPage page;

  const _OnboardingPageView({required this.page});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: page.accentColor.withValues(alpha: 0.2),
                  blurRadius: 32,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Center(
              child: Text(
                page.emoji,
                style: const TextStyle(fontSize: 80),
              ),
            ),
          ),
          const SizedBox(height: 40),
          Text(
            page.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A1C1B),
              fontFamily: 'Poppins',
              height: 1.2,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            page.subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Color(0xFF3D4A47),
              fontFamily: 'Poppins',
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
