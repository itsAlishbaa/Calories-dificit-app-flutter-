import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(debugShowCheckedModeBanner: false, home: HubPage()));
}

class HubPage extends StatelessWidget {
  const HubPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A), // Dark Modern Charcoal
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Fitness Hub 🔥",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Quick Access",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            // FIX: AspectRatio and mainAxisExtent to keep cards compact!
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.25, // Makes cards tight & small!
              children: [
                _buildCompactCard(
                  context,
                  title: "Recipes 🍲",
                  subtitle: "Diet & Meals Plan",
                  icon: Icons.restaurant_menu_rounded,
                  color: const Color(0xFFF59E0B),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const RecipesScreen()),
                  ),
                ),
                _buildCompactCard(
                  context,
                  title: "Exercise 🏋️‍♂️",
                  subtitle: "Video Workouts",
                  icon: Icons.fitness_center_rounded,
                  color: const Color(0xFF6366F1),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ExerciseScreen()),
                  ),
                ),
                _buildCompactCard(
                  context,
                  title: "Personal Mentor 👨‍🏫",
                  subtitle: "Direct Guidance",
                  icon: Icons.psychology_rounded,
                  color: const Color(0xFF10B981),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const MentorChatScreen()),
                  ),
                ),
                _buildCompactCard(
                  context,
                  title: "Myths & Facts 💡",
                  subtitle: "Do's & Don'ts",
                  icon: Icons.lightbulb_outline_rounded,
                  color: const Color(0xFFEC4899),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const MythsScreen()),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompactCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, size: 22, color: color),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.white54,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// 🍲 1. FULL RECIPES SCREEN WITH DYNAMIC WORKING MODAL
// -----------------------------------------------------------------------------
class RecipesScreen extends StatelessWidget {
  const RecipesScreen({Key? key}) : super(key: key);

  final List<Map<String, dynamic>> recipes = const [
    {
      "name": "Avocado & Egg Toast 🥑",
      "calories": "320 kcal",
      "tag": "Keto",
      "time": "10 min",
      "image":
          "https://images.unsplash.com/photo-1525351484163-7529414344d8?w=400",
      "ingredients": [
        "2 Slices Whole Wheat Bread",
        "1 Avocado",
        "2 Boiled Eggs",
        "Chili Flakes",
      ],
      "instructions":
          "Toast bread. Mash avocado with lemon. Top with sliced boiled eggs and chili flakes.",
    },
    {
      "name": "Grilled Chicken Salad 🥗",
      "calories": "410 kcal",
      "tag": "High Protein",
      "time": "20 min",
      "image":
          "https://images.unsplash.com/photo-1540420773420-3366772f4999?w=400",
      "ingredients": [
        "200g Chicken Breast",
        "Cherry Tomatoes",
        "Lettuce & Spinach",
        "Olive Oil",
      ],
      "instructions":
          "Grill chicken breast for 12 minutes. Chop greens and combine with olive oil dressing.",
    },
    {
      "name": "Oatmeal Berry Bowl 🥣",
      "calories": "280 kcal",
      "tag": "Low Fat",
      "time": "5 min",
      "image":
          "https://images.unsplash.com/photo-1590301157890-4810ed352733?w=400",
      "ingredients": [
        "1 cup Rolled Oats",
        "Almond Milk",
        "Fresh Strawberries",
        "Chia Seeds",
      ],
      "instructions":
          "Cook oats in warm almond milk. Serve in a bowl topped with strawberries and chia.",
    },
    {
      "name": "Quinoa Veggie Power Bowl 🥑",
      "calories": "350 kcal",
      "tag": "Vegan",
      "time": "15 min",
      "image":
          "https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=400",
      "ingredients": [
        "1 cup Quinoa",
        "Roasted Chickpeas",
        "Cucumbers",
        "Tahini Sauce",
      ],
      "instructions":
          "Mix cooked quinoa with veggies. Drizzle tahini sauce on top for extra flavor.",
    },
    {
      "name": "Seared Salmon & Asparagus 🐟",
      "calories": "460 kcal",
      "tag": "Keto",
      "time": "20 min",
      "image":
          "https://images.unsplash.com/photo-1467003909585-2f8a72700288?w=400",
      "ingredients": [
        "1 Salmon Fillet",
        "Fresh Asparagus",
        "Garlic Butter",
        "Lemon Slice",
      ],
      "instructions":
          "Pan-sear salmon skin-side down for 5 mins each side. Sauté asparagus in garlic butter.",
    },
    {
      "name": "Greek Yogurt Parfait 🍨",
      "calories": "220 kcal",
      "tag": "Snack",
      "time": "5 min",
      "image":
          "https://images.unsplash.com/photo-1488477181946-6428a0291777?w=400",
      "ingredients": ["1 cup Greek Yogurt", "Honey", "Granola", "Blueberries"],
      "instructions":
          "Layer yogurt, honey, granola, and blueberries in a tall glass.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text("Healthy Recipes 🍲"),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: recipes.length,
        itemBuilder: (context, index) {
          final item = recipes[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(14),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(10),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  item['image'],
                  width: 65,
                  height: 65,
                  fit: BoxFit.cover,
                  errorBuilder: (c, e, s) => Container(
                    width: 65,
                    height: 65,
                    color: Colors.grey.shade800,
                    child: const Icon(Icons.fastfood, color: Colors.white),
                  ),
                ),
              ),
              title: Text(
                item['name'],
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              subtitle: Text(
                "${item['calories']} • ${item['time']}",
                style: const TextStyle(color: Colors.white54, fontSize: 12),
              ),
              trailing: const Icon(
                Icons.chevron_right_rounded,
                color: Colors.white38,
              ),
              onTap: () => _openRecipeDetails(context, item),
            ),
          );
        },
      ),
    );
  }

  void _openRecipeDetails(BuildContext context, Map<String, dynamic> recipe) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E293B),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              recipe['name'],
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "Prep Time: ${recipe['time']} | Calories: ${recipe['calories']}",
              style: const TextStyle(color: Color(0xFFF59E0B)),
            ),
            const Divider(color: Colors.white24, height: 24),
            const Text(
              "Ingredients:",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            ...(recipe['ingredients'] as List<String>).map(
              (i) =>
                  Text("• $i", style: const TextStyle(color: Colors.white70)),
            ),
            const SizedBox(height: 14),
            const Text(
              "Instructions:",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              recipe['instructions'],
              style: const TextStyle(color: Colors.white70, height: 1.3),
            ),
          ],
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// 🏋️ 2. EXERCISE SCREEN WITH WORKING VIDEO PLAYER SIMULATION
// -----------------------------------------------------------------------------
class ExerciseScreen extends StatelessWidget {
  const ExerciseScreen({super.key});

  final List<Map<String, String>> workouts = const [
    {
      "title": "Full Body HIIT Blast ⚡",
      "duration": "15 mins",
      "level": "Beginner",
      "image":
          "https://images.unsplash.com/photo-1517838277536-f5f99be501cd?w=400",
    },
    {
      "title": "Fat Burning Cardio 🏃",
      "duration": "20 mins",
      "level": "Intermediate",
      "image":
          "https://images.unsplash.com/photo-1538805060514-97d9cc17730c?w=400",
    },
    {
      "title": "Core & Six-Pack Abs 🔥",
      "duration": "10 mins",
      "level": "All Levels",
      "image":
          "https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=400",
    },
    {
      "title": "Legs & Lower Body 🦵",
      "duration": "25 mins",
      "level": "Advanced",
      "image":
          "https://images.unsplash.com/photo-1434682881908-b43d0467b798?w=400",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text("Workout Videos 🏋️‍♂️"),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: workouts.length,
        itemBuilder: (context, index) {
          final w = workouts[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 14),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(16),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PlayVideoScreen(title: w['title']!),
                ),
              ),
              child: Row(
                children: [
                  Text("helo", style: TextStyle(color: Colors.white)),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.horizontal(
                          left: Radius.circular(16),
                        ),
                        child: Image.network(
                          w['image']!,
                          width: 100,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.black54,
                        child: Icon(
                          Icons.play_arrow,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "krrr",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "${w['duration']} • ${w['level']}",
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class PlayVideoScreen extends StatefulWidget {
  final String title;
  const PlayVideoScreen({Key? key, required this.title}) : super(key: key);

  @override
  State<PlayVideoScreen> createState() => _PlayVideoScreenState();
}

class _PlayVideoScreenState extends State<PlayVideoScreen> {
  bool isPlaying = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 220,
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    isPlaying
                        ? Icons.motion_photos_on
                        : Icons.pause_circle_filled,
                    size: 60,
                    color: const Color(0xFF6366F1),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    isPlaying ? "▶ Workout Playing..." : "⏸ Paused",
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6366F1),
            ),
            onPressed: () => setState(() => isPlaying = !isPlaying),
            icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
            label: Text(isPlaying ? "Pause Video" : "Play Video"),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// 👨‍🏫 3. PERSONAL MENTOR SCREEN
// -----------------------------------------------------------------------------
class MentorChatScreen extends StatefulWidget {
  const MentorChatScreen({Key? key}) : super(key: key);

  @override
  State<MentorChatScreen> createState() => _MentorChatScreenState();
}

class _MentorChatScreenState extends State<MentorChatScreen> {
  final List<Map<String, String>> messages = [
    {
      "sender": "ai",
      "text":
          "Hello! I am your Personal Fitness Mentor. What goal are we working on today?",
    },
  ];
  final TextEditingController _controller = TextEditingController();

  void _send() {
    if (_controller.text.isEmpty) return;
    setState(() {
      messages.add({"sender": "user", "text": _controller.text});
      _controller.clear();
    });
    Future.delayed(const Duration(milliseconds: 600), () {
      setState(() {
        messages.add({
          "sender": "ai",
          "text":
              "That's great! Maintain a slight calorie deficit and drink 3 Liters of water daily.",
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text("Personal Mentor 👨‍🏫"),
      ),
      body: Column(
        children: [
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
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isUser
                          ? const Color(0xFF10B981)
                          : const Color(0xFF1E293B),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      messages[i]['text']!,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            color: const Color(0xFF1E293B),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: "Type message...",
                      hintStyle: TextStyle(color: Colors.white38),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Color(0xFF10B981)),
                  onPressed: _send,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// 💡 4. MYTHS & FACTS SCREEN
// -----------------------------------------------------------------------------
class MythsScreen extends StatelessWidget {
  const MythsScreen({Key? key}) : super(key: key);

  final List<Map<String, String>> items = const [
    {
      "type": "Myth ❌",
      "title": "Skipping breakfast helps in weight loss.",
      "desc":
          "Fact: It slows metabolism and causes overeating later in the day.",
    },
    {
      "type": "Do ✅",
      "title": "Drink 500ml water 30 mins before meal.",
      "desc": "Increases metabolic rate and helps in portion control.",
    },
    {
      "type": "Don't ❌",
      "title": "Don't avoid carbohydrates completely.",
      "desc": "Carbs give essential energy. Stick to complex carbs like oats.",
    },
    {
      "type": "Myth ❌",
      "title": "Sweating means you burn fat.",
      "desc":
          "Fact: Sweating only cools your body down, it doesn't represent fat loss.",
    },
    {
      "type": "Do ✅",
      "title": "Get 7-8 hours of sound sleep.",
      "desc": "Lack of sleep increases cortisol levels which stores body fat.",
    },
    {
      "type": "Don't ❌",
      "title": "Don't rely only on cardio.",
      "desc":
          "Include weight training to preserve muscle tissue while burning fat.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text("Myths & Facts 💡"),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['type']!,
                  style: const TextStyle(
                    color: Color(0xFFEC4899),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item['title']!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item['desc']!,
                  style: const TextStyle(color: Colors.white60, fontSize: 12),
                ),
                Text(
                  "Helo",
                  style: const TextStyle(color: Colors.white60, fontSize: 12),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
