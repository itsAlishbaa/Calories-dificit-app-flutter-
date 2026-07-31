import 'dart:ui';
import 'package:flutter/material.dart';

import 'calorie_deficit_explanation_screen.dart';

class OnboardingQuizFlow extends StatefulWidget {
  const OnboardingQuizFlow({Key? key}) : super(key: key);

  @override
  State<OnboardingQuizFlow> createState() => _OnboardingQuizFlowState();
}

class _OnboardingQuizFlowState extends State<OnboardingQuizFlow> {
  late final PageController _pageController;
  int _currentStep = 0;
  final int _totalSteps = 6;

  // Stores User Answers
  final Map<String, dynamic> _userAnswers = {};

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // --- NAVIGATION HELPERS ---
  void _goToPage(int targetPage) {
    if (targetPage >= 0 && targetPage < _totalSteps) {
      setState(() {
        _currentStep = targetPage;
      });
      _pageController.animateToPage(
        targetPage,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    }
  }

  void _nextPage() {
    _goToPage(_currentStep + 1);
  }

  void _previousPage() {
    _goToPage(_currentStep - 1);
  }

  // --- POPUP DIALOGS ---
  // Dialog 1: Sleep Info
  Future<void> _showSleepInfoDialog() async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return _buildGlassPopup(
          emoji: "😴",
          title: "Why Sleep Matters for Weight Loss!",
          description:
              "Lack of sleep disrupts appetite-regulating hormones: Ghrelin (hunger hormone) increases by up to 28%, while Leptin (fullness hormone) drops by 18%. Good sleep accelerates fat burn by 55%!",
          buttonText: "Got it! Continue",
          onPressed: () {
            Navigator.of(dialogContext).pop();
          },
        );
      },
    );

    if (mounted) {
      _nextPage();
    }
  }

  // Dialog 2: Calorie Deficit (NAVIGATES TO CalorieDeficitExplanationScreen)
  Future<void> _showCalorieDeficitDialog() async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return _buildGlassPopup(
          emoji: "🔥",
          title: "The Power of Calorie Deficit",
          description:
              "A calorie deficit is the #1 scientifically proven rule for sustainable weight loss. Consuming ~500 kcal less than your TDEE safely sheds around 0.5kg (1lb) of pure fat per week without sacrificing muscle mass!",
          buttonText: "Let's Build My Plan!",
          onPressed: () {
            // 1. Close Dialog
            Navigator.of(dialogContext).pop();

            // 2. Safe Navigation after dialog pop
            if (mounted) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const OnboardingGraphWizard(),
                ),
              );
            }
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 12),
              _buildHeader(),
              const SizedBox(height: 16),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  onPageChanged: (index) {
                    setState(() {
                      _currentStep = index;
                    });
                  },
                  children: [
                    // Q1: Daily Activity Level (Index 0)
                    _buildOptionQuestionScreen(
                      questionKey: "activity",
                      emojiTitle: "🏃‍♂️ Daily Routine",
                      question: "How do you usually spend your day?",
                      options: const [
                        {
                          "emoji": "🪑",
                          "title": "Mostly Sitting",
                          "subtitle": "Desk job, watching TV, sitting around",
                        },
                        {
                          "emoji": "🚶‍♂️",
                          "title": "On My Feet",
                          "subtitle": "Teacher, retail, standing frequently",
                        },
                        {
                          "emoji": "🏋️‍♂️",
                          "title": "Very Active",
                          "subtitle": "Physical labor, heavy workout routine",
                        },
                        {
                          "emoji": "🛋️",
                          "title": "Mostly Resting / Lying",
                          "subtitle": "Recovering, bed rest, minimal movement",
                        },
                      ],
                      onSelect: (val) {
                        setState(() {
                          _userAnswers["activity"] = val;
                        });
                        _nextPage();
                      },
                    ),

                    // Q2: Sleep Hours (Index 1)
                    _buildOptionQuestionScreen(
                      questionKey: "sleep",
                      emojiTitle: "🌙 Sleep Patterns",
                      question: "How many hours do you sleep per night?",
                      options: const [
                        {
                          "emoji": "😫",
                          "title": "Less than 5 hours",
                          "subtitle": "Severe sleep debt",
                        },
                        {
                          "emoji": "🥱",
                          "title": "5 to 6 hours",
                          "subtitle": "Sub-optimal rest",
                        },
                        {
                          "emoji": "😴",
                          "title": "7 to 8 hours",
                          "subtitle": "Optimal recovery window",
                        },
                        {
                          "emoji": "🛌",
                          "title": "More than 9 hours",
                          "subtitle": "Extended rest",
                        },
                      ],
                      onSelect: (val) {
                        setState(() {
                          _userAnswers["sleep"] = val;
                        });
                        _showSleepInfoDialog();
                      },
                    ),

                    // Q3: Meals Count (Index 2)
                    _buildOptionQuestionScreen(
                      questionKey: "meals_frequency",
                      emojiTitle: "🍽️ Meal Frequency",
                      question: "How many times a day do you eat food?",
                      options: const [
                        {
                          "emoji": "⚡",
                          "title": "1 - 2 Big Meals",
                          "subtitle": "Intermittent style or busy schedule",
                        },
                        {
                          "emoji": "🥗",
                          "title": "3 Standard Meals",
                          "subtitle": "Traditional breakfast, lunch & dinner",
                        },
                        {
                          "emoji": "🍿",
                          "title": "3 Meals + Snacking",
                          "subtitle": "Frequent grazing throughout the day",
                        },
                        {
                          "emoji": "🍲",
                          "title": "5+ Small Meals",
                          "subtitle": "Bodybuilding or fitness protocol",
                        },
                      ],
                      onSelect: (val) {
                        setState(() {
                          _userAnswers["meals_frequency"] = val;
                        });
                        _nextPage();
                      },
                    ),

                    // Q4: Diet Style Preference (Index 3)
                    _buildOptionQuestionScreen(
                      questionKey: "diet_type",
                      emojiTitle: "🥦 Diet Preference",
                      question: "What type of diet do you prefer or follow?",
                      options: const [
                        {
                          "emoji": "🥑",
                          "title": "Keto Diet",
                          "subtitle": "High fat, very low carb",
                        },
                        {
                          "emoji": "🥩",
                          "title": "High Protein",
                          "subtitle": "Lean muscle focus, moderate carbs",
                        },
                        {
                          "emoji": "🍱",
                          "title": "Balanced Diet",
                          "subtitle": "Flexible mix of all macronutrients",
                        },
                        {
                          "emoji": "🌱",
                          "title": "Vegan / Plant-Based",
                          "subtitle": "100% plant foods, no dairy/meat",
                        },
                      ],
                      onSelect: (val) {
                        setState(() {
                          _userAnswers["diet_type"] = val;
                        });
                        _nextPage();
                      },
                    ),

                    // Diet Benefits Deep-Dive (Index 4)
                    _buildDietBenefitsScreen(),

                    // Q6: Calorie Deficit Experience (Index 5 - FINAL PAGE)
                    _buildOptionQuestionScreen(
                      questionKey: "tried_deficit",
                      emojiTitle: "⚖️ Weight Loss History",
                      question: "Have you ever tried a Calorie Deficit before?",
                      options: const [
                        {
                          "emoji": "✅",
                          "title": "Yes, I have tried it!",
                          "subtitle": "Know how tracking calories works",
                        },
                        {
                          "emoji": "❌",
                          "title": "No, this is my first time",
                          "subtitle": "New to energy balance tracking",
                        },
                        {
                          "emoji": "🤔",
                          "title": "I'm not sure what it is",
                          "subtitle": "Need guidance & automatic plan",
                        },
                      ],
                      onSelect: (val) {
                        setState(() {
                          _userAnswers["tried_deficit"] = val;
                        });
                        _showCalorieDeficitDialog();
                      },
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

  // --- HEADER WITH BACK BUTTON & PROGRESS BAR ---
  Widget _buildHeader() {
    double progress = (_currentStep + 1) / _totalSteps;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_rounded,
              color: Colors.white,
              size: 20,
            ),
            onPressed: _previousPage,
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 8,
                backgroundColor: Colors.white.withOpacity(0.12),
                valueColor: const AlwaysStoppedAnimation<Color>(
                  Color(0xFF00F2FE),
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Text(
            "${_currentStep + 1}/$_totalSteps",
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  // --- GENERIC QUESTION SCREEN TEMPLATE ---
  Widget _buildOptionQuestionScreen({
    required String questionKey,
    required String emojiTitle,
    required String question,
    required List<Map<String, String>> options,
    required Function(String) onSelect,
  }) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            emojiTitle.toUpperCase(),
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Color(0xFF00F2FE),
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            question,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 28),
          ...options.map((opt) {
            bool isSelected = _userAnswers[questionKey] == opt["title"];

            return Padding(
              padding: const EdgeInsets.only(bottom: 14.0),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => onSelect(opt["title"]!),
                  borderRadius: BorderRadius.circular(20),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFF00F2FE).withOpacity(0.2)
                              : Colors.white.withOpacity(0.06),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xFF00F2FE)
                                : Colors.white.withOpacity(0.12),
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.black.withOpacity(0.25),
                              ),
                              child: Text(
                                opt["emoji"]!,
                                style: const TextStyle(fontSize: 24),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    opt["title"]!,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    opt["subtitle"]!,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white.withOpacity(0.5),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.chevron_right_rounded,
                              color: Colors.white.withOpacity(0.4),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  // --- DIET BENEFITS SCREEN (INDEX 4) ---
  Widget _buildDietBenefitsScreen() {
    final List<Map<String, String>> dietBenefits = const [
      {
        "emoji": "🥑",
        "name": "Keto Diet",
        "benefit": "Accelerates Fat Burning",
        "desc":
            "Puts your body into Ketosis, turning stored fat into your primary fuel source instead of carbs.",
      },
      {
        "emoji": "🍱",
        "name": "Balanced Diet",
        "benefit": "Sustainable & Flexible",
        "desc":
            "Provides all micro & macro nutrients. Prevents cravings and keeps energy levels steady all day.",
      },
      {
        "emoji": "🥩",
        "name": "High Protein",
        "benefit": "Preserves Muscle Mass",
        "desc":
            "Boosts metabolism through the thermic effect of food and keeps you full for much longer.",
      },
      {
        "emoji": "⏳",
        "name": "Intermittent Fasting",
        "benefit": "Autophagy & Hormone Reset",
        "desc":
            "Lowers insulin levels, promotes cellular repair, and effortlessly manages overall calorie intake.",
      },
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "SCIENCE-BACKED NUTRITION",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Color(0xFF00F2FE),
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "How Each Diet Benefits You",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          ...dietBenefits.map((diet) {
            return Container(
              margin: const EdgeInsets.only(bottom: 14),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.25),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withOpacity(0.12)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(diet["emoji"]!, style: const TextStyle(fontSize: 32)),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              diet["name"]!,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              diet["benefit"]!,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF00F2FE),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          diet["desc"]!,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withOpacity(0.6),
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00F2FE),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: () {
                _goToPage(5);
              },
              child: const Text(
                "Understood! Continue",
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  // --- GLASS DIALOG POPUP BUILDER ---
  Widget _buildGlassPopup({
    required String emoji,
    required String title,
    required String description,
    required String buttonText,
    required VoidCallback onPressed,
  }) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF203A43).withOpacity(0.85),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 30,
                  offset: const Offset(0, 15),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF00F2FE).withOpacity(0.15),
                  ),
                  child: Text(emoji, style: const TextStyle(fontSize: 40)),
                ),
                const SizedBox(height: 16),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  description,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white.withOpacity(0.7),
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00F2FE),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: onPressed,
                    child: Text(
                      buttonText,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
