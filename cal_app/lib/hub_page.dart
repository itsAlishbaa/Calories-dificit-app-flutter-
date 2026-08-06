import 'package:flutter/material.dart';

void main() {
  runApp(const HealthAndFitnessApp());
}

// =============================================================================
// 🎨 APP COLOR PALETTE
// =============================================================================
class AppColors {
  // Brand / Theme Colors
  static const Color primary = Color(0xFF0D9488); // Deep Teal
  static const Color primaryLight = Color(0xFFCCFBF1); // Soft Mint/Teal Accent
  static const Color accent = Color(0xFF10B981); // Emerald Green

  // Background & Surfaces
  static const Color background = Color(0xFFF8FAFC); // Cool Slate Neutral
  static const Color surface = Colors.white;

  // Text Colors
  static const Color textPrimary = Color(0xFF0F172A); // Dark Slate
  static const Color textSecondary = Color(0xFF64748B); // Slate Grey
  static const Color textMuted = Color(0xFF94A3B8);

  // Status & Tag Colors
  static const Color successBg = Color(0xFFD1FAE5);
  static const Color successText = Color(0xFF059669);
  static const Color errorBg = Color(0xFFFEE2E2);
  static const Color errorText = Color(0xFFDC2626);
  static const Color border = Color(0xFFE2E8F0);
}

class HealthAndFitnessApp extends StatelessWidget {
  const HealthAndFitnessApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fitness & Health Companion',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.background,
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
          surface: AppColors.surface,
        ),
      ),
      home: const MainHomeScreen(),
    );
  }
}

// =============================================================================
// 📱 MAIN CONTAINER WITH BOTTOM NAVIGATION
// =============================================================================
class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({Key? key}) : super(key: key);

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    RecipesHubSection(),
    MentorHubSection(),
    MythsHubSection(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Health & Fitness Hub",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
        centerTitle: true,
      ),
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textMuted,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_menu),
            label: 'Recipes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.smart_toy),
            label: 'AI Mentor',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.lightbulb_outline),
            label: 'Myths & Do\'s',
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// 🥗 RECIPES SECTION
// =============================================================================
class RecipesHubSection extends StatelessWidget {
  const RecipesHubSection({Key? key}) : super(key: key);

  final List<Map<String, dynamic>> recipes = const [
    {
      'name': 'Grilled Chicken & Avocado Salad',
      'calories': '420 kcal',
      'time': '20 mins',
      'thumb':
          'https://images.unsplash.com/photo-1540420773420-3366772f4999?w=400',
      'ingredients': [
        '200g Grilled Chicken Breast',
        '1 Fresh Avocado (sliced)',
        '2 cups Mixed Greens',
        '1 tbsp Olive Oil & Lemon Dressing',
      ],
      'instructions': [
        'Season and grill the chicken breast until cooked through.',
        'Toss mixed greens with olive oil and lemon juice.',
        'Slice chicken and avocado, place over salad bed and serve.',
      ],
    },
    {
      'name': 'Berry Protein Oatmeal Bowl',
      'calories': '350 kcal',
      'time': '10 mins',
      'thumb':
          'https://images.unsplash.com/photo-1517673400267-0251440c45dc?w=400',
      'ingredients': [
        '1/2 cup Rolled Oats',
        '1 scoop Vanilla Whey Protein',
        '1/2 cup Fresh Berries (Blueberries/Strawberries)',
        '1 tbsp Chia Seeds',
      ],
      'instructions': [
        'Cook oats in water or almond milk over medium heat.',
        'Stir in protein powder once cooked and removed from heat.',
        'Top with fresh berries and chia seeds before serving.',
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          height: 130,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            image: const DecorationImage(
              image: NetworkImage(
                "https://images.unsplash.com/photo-1498837167922-ddd27525d352?w=800",
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                colors: [Colors.black.withOpacity(0.75), Colors.transparent],
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
              ),
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Healthy Diet Recipes 🥗",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Tap any recipe card to drop down full instructions",
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        ...recipes.map((r) {
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.06),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Theme(
              data: ThemeData().copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                tilePadding: const EdgeInsets.all(12),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    r['thumb'],
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
                title: Text(
                  r['name'],
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Row(
                    children: [
                      Text(
                        "🔥 ${r['calories']}",
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.accent,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "⏱️ ${r['time']}",
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Divider(color: AppColors.border),
                        const Text(
                          "🛒 Ingredients:",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 6),
                        ...(r['ingredients'] as List<String>).map(
                          (ing) => Padding(
                            padding: const EdgeInsets.only(bottom: 4.0),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.circle,
                                  size: 6,
                                  color: AppColors.primary,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    ing,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          "👩‍🍳 Instructions:",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 6),
                        ...(r['instructions'] as List<String>).map(
                          (step) => Padding(
                            padding: const EdgeInsets.only(bottom: 6.0),
                            child: Text(
                              "• $step",
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.textSecondary,
                                height: 1.3,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ],
    );
  }
}

// =============================================================================
// 🤖 AI MENTOR SECTION
// =============================================================================
class MentorHubSection extends StatefulWidget {
  const MentorHubSection({Key? key}) : super(key: key);

  @override
  State<MentorHubSection> createState() => _MentorHubSectionState();
}

class _MentorHubSectionState extends State<MentorHubSection> {
  final List<Map<String, String>> messages = [
    {
      "sender": "ai",
      "text":
          "Hi! I'm your Fitness Mentor. Ask me anything about workouts, diet, or weight loss goals!",
    },
  ];

  final TextEditingController _controller = TextEditingController();

  void _send(String query) {
    if (query.trim().isEmpty) return;
    setState(() {
      messages.add({"sender": "user", "text": query});
      _controller.clear();
    });

    Future.delayed(const Duration(milliseconds: 700), () {
      if (!mounted) return;
      setState(() {
        messages.add({
          "sender": "ai",
          "text":
              "Regarding '$query': Focus on consistency, stay in a moderate caloric deficit, and get 8 hours of sleep for optimum recovery!",
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 110,
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                "https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=800",
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            padding: const EdgeInsets.all(16),
            color: Colors.black.withOpacity(0.65),
            child: const Row(
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundImage: NetworkImage(
                    "https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200",
                  ),
                ),
                SizedBox(width: 12),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Personal Fitness Mentor 🤖",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Online • Ready to answer your questions",
                      style: TextStyle(color: AppColors.accent, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Container(
          height: 45,
          color: AppColors.surface,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            children: [
              _buildChip("How to lose belly fat?"),
              _buildChip("Best post-workout meal?"),
              _buildChip("How much water to drink?"),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: messages.length,
            itemBuilder: (context, i) {
              bool isUser = messages[i]['sender'] == 'user';
              return Align(
                alignment: isUser
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.78,
                  ),
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isUser ? AppColors.primary : AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Text(
                    messages[i]['text']!,
                    style: TextStyle(
                      color: isUser ? Colors.white : AppColors.textPrimary,
                      fontSize: 14,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: const BoxDecoration(
            color: AppColors.surface,
            border: Border(top: BorderSide(color: AppColors.border)),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    hintText: "Ask mentor anything...",
                    hintStyle: TextStyle(color: AppColors.textMuted),
                    border: InputBorder.none,
                  ),
                  onSubmitted: (val) => _send(val),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send_rounded, color: AppColors.primary),
                onPressed: () => _send(_controller.text),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildChip(String label) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: ActionChip(
        backgroundColor: AppColors.primaryLight,
        side: BorderSide.none,
        label: Text(
          label,
          style: const TextStyle(fontSize: 11, color: AppColors.primary),
        ),
        onPressed: () => _send(label),
      ),
    );
  }
}

// =============================================================================
// 💡 MYTHS & DO'S SECTION
// =============================================================================
class MythsHubSection extends StatelessWidget {
  const MythsHubSection({Key? key}) : super(key: key);

  final List<Map<String, String>> items = const [
    {
      "tag": "Myth ❌",
      "title": "Skipping meals helps you lose weight faster.",
      "desc":
          "Fact: Skipping meals causes metabolic slumps and leads to overeating high-calorie snacks later.",
    },
    {
      "tag": "Do ✅",
      "title": "Drink 500ml water 30 mins before meals.",
      "desc":
          "Promotes satiety, aids digestion, and prevents overeating during lunch/dinner.",
    },
    {
      "tag": "Don't ❌",
      "title": "Don't completely cut out carbohydrates.",
      "desc":
          "Carbs supply vital fuel for your brain and muscles. Focus on complex options like oats & brown rice.",
    },
    {
      "tag": "Myth ❌",
      "title": "Sweating directly equals burning body fat.",
      "desc":
          "Fact: Sweating is just temperature regulation. Fat loss occurs through a consistent caloric deficit.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          height: 140,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            image: const DecorationImage(
              image: NetworkImage(
                "https://images.unsplash.com/photo-1518611012118-696072aa579a?w=800",
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                colors: [Colors.black.withOpacity(0.7), Colors.transparent],
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
              ),
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Do's, Don'ts & Myths 💡",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Evidence-based guidance for healthy living",
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        ...items.map((item) {
          final isMythOrDont = item['tag']!.contains('❌');
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 6),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: isMythOrDont
                        ? AppColors.errorBg
                        : AppColors.successBg,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    item['tag']!,
                    style: TextStyle(
                      color: isMythOrDont
                          ? AppColors.errorText
                          : AppColors.successText,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  item['title']!,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  item['desc']!,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }
}
