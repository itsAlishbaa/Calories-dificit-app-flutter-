import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'profile.dart';

// =============================================================================
// 🏠 MAIN UI DASHBOARD
// =============================================================================
class MainUI extends StatefulWidget {
  const MainUI({Key? key}) : super(key: key);

  @override
  State<MainUI> createState() => _MainUIState();
}

class _MainUIState extends State<MainUI> {
  // 🍏 Calorie & Macro State Variables
  int currentCalories = 1250;
  int targetCalories = 1850;

  double carbsCurrent = 109;
  double carbsTarget = 198;

  double fatCurrent = 13.5;
  double fatTarget = 52;

  double proteinCurrent = 34.2;
  double proteinTarget = 122;

  // 💧 Water Tracker State Variables
  int glassesDrunk = 0; // 1 Glass = 250ml
  final double glassVolumeMl = 250.0;
  double targetWaterLiters = 2.0;

  // 📷 Camera & Image Picker Logic
  File? _capturedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          _capturedImage = File(pickedFile.path);
          currentCalories += 250;
          proteinCurrent += 15;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Photo analyzed! Added +250 kcal & 15g Protein."),
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error opening camera: $e")));
    }
  }

  // User Dynamic Input Dialog
  void _showAddFoodDialog() {
    TextEditingController calController = TextEditingController(
      text: currentCalories.toString(),
    );
    TextEditingController carbsController = TextEditingController(
      text: carbsCurrent.toStringAsFixed(0),
    );
    TextEditingController fatController = TextEditingController(
      text: fatCurrent.toStringAsFixed(1),
    );
    TextEditingController proteinController = TextEditingController(
      text: proteinCurrent.toStringAsFixed(1),
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Colors.white,
          title: const Text(
            "Update Daily Intake",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDialogField("Calories (kcal)", calController),
                _buildDialogField("Carbs (g)", carbsController),
                _buildDialogField("Fat (g)", fatController),
                _buildDialogField("Protein (g)", proteinController),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFC7F464),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                setState(() {
                  currentCalories =
                      int.tryParse(calController.text) ?? currentCalories;
                  carbsCurrent =
                      double.tryParse(carbsController.text) ?? carbsCurrent;
                  fatCurrent =
                      double.tryParse(fatController.text) ?? fatCurrent;
                  proteinCurrent =
                      double.tryParse(proteinController.text) ?? proteinCurrent;
                });
                Navigator.pop(context);
              },
              child: const Text(
                "Save",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDialogField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: TextField(
        controller: controller,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(fontSize: 13, color: Colors.grey),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
        ),
      ),
    );
  }

  void _showCameraOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
              icon: const Icon(Icons.camera_alt),
              label: const Text("Camera"),
            ),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
              icon: const Icon(Icons.photo_library),
              label: const Text("Gallery"),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double dailyPercent = (currentCalories / targetCalories) * 100;
    double totalWaterMlDrunk = glassesDrunk * glassVolumeMl;
    double targetWaterMl = targetWaterLiters * 1000.0;
    double waterPercent = (totalWaterMlDrunk / targetWaterMl).clamp(0.0, 1.0);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8F5),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        toolbarHeight: 70,
        title: Column(
          children: [
            const Text(
              "CaloriCam",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w900,
                fontSize: 24,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 4),
            RichText(
              text: const TextSpan(
                style: TextStyle(color: Colors.grey, fontSize: 12),
                children: [
                  TextSpan(text: "Last synced with your "),
                  TextSpan(
                    text: "devices",
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: Colors.black54,
                    ),
                  ),
                  TextSpan(text: " at "),
                  TextSpan(
                    text: "19:01",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 10.0,
            ),
            child: Column(
              children: [
                // Top Filter Bar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Row(
                        children: const [
                          Icon(
                            Icons.calendar_today_outlined,
                            size: 16,
                            color: Colors.black87,
                          ),
                          SizedBox(width: 8),
                          Text(
                            "Today",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(width: 4),
                          Icon(
                            Icons.keyboard_arrow_down,
                            size: 18,
                            color: Colors.black87,
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        _buildCircleIconButton(
                          Icons.edit_outlined,
                          _showAddFoodDialog,
                        ),
                        const SizedBox(width: 10),
                        _buildCircleIconButton(Icons.more_vert_rounded, () {}),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // 1️⃣ Daily Intake Card
                Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD7F58C),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.bolt_rounded,
                                  size: 14,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                "Daily intake",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "${dailyPercent.toInt()}%",
                            style: const TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.w900,
                              height: 1.0,
                              letterSpacing: -1,
                            ),
                          ),
                        ],
                      ),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: 100,
                            height: 100,
                            child: CircularProgressIndicator(
                              value: (currentCalories / targetCalories).clamp(
                                0.0,
                                1.0,
                              ),
                              strokeWidth: 10,
                              strokeCap: StrokeCap.round,
                              backgroundColor: Colors.white.withOpacity(0.5),
                              color: const Color(0xFF86C100),
                            ),
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "$currentCalories",
                                style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 18,
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.symmetric(vertical: 2),
                                width: 24,
                                height: 1,
                                color: Colors.grey.shade400,
                              ),
                              Text(
                                "$targetCalories",
                                style: const TextStyle(
                                  color: Colors.black54,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // 2️⃣ Nutritions Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.pie_chart_outline_rounded,
                                  size: 18,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(width: 10),
                              const Text(
                                "Nutritions",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          const Icon(
                            Icons.chevron_right_rounded,
                            color: Colors.black54,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildMacroRow(
                        "Carbs",
                        carbsCurrent,
                        carbsTarget,
                        const Color(0xFFFFD4D4),
                      ),
                      const SizedBox(height: 14),
                      _buildMacroRow(
                        "Fat",
                        fatCurrent,
                        fatTarget,
                        const Color(0xFFFFE8A3),
                      ),
                      const SizedBox(height: 14),
                      _buildMacroRow(
                        "Protein",
                        proteinCurrent,
                        proteinTarget,
                        const Color(0xFFCBE9FF),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // 3️⃣ Water Intake Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Colors.lightBlue.shade50,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.water_drop_rounded,
                                  color: Colors.lightBlue,
                                  size: 18,
                                ),
                              ),
                              const SizedBox(width: 10),
                              const Text(
                                "Water Intake",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          DropdownButton<double>(
                            value: targetWaterLiters,
                            underline: const SizedBox(),
                            icon: const Icon(
                              Icons.keyboard_arrow_down,
                              color: Colors.grey,
                            ),
                            items: [1.5, 2.0, 2.5, 3.0, 3.5, 4.0]
                                .map(
                                  (liters) => DropdownMenuItem(
                                    value: liters,
                                    child: Text(
                                      "${liters}L Target",
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                            onChanged: (val) {
                              if (val != null) {
                                setState(() {
                                  targetWaterLiters = val;
                                });
                              }
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  SizedBox(
                                    width: 50,
                                    height: 50,
                                    child: CircularProgressIndicator(
                                      value: waterPercent,
                                      strokeWidth: 5,
                                      backgroundColor: Colors.lightBlue.shade50,
                                      color: Colors.lightBlue,
                                    ),
                                  ),
                                  Icon(
                                    Icons.local_drink_rounded,
                                    color: waterPercent == 1.0
                                        ? Colors.blue
                                        : Colors.lightBlue.shade300,
                                    size: 22,
                                  ),
                                ],
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${(totalWaterMlDrunk / 1000.0).toStringAsFixed(2)} / ${targetWaterLiters} L",
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "$glassesDrunk Glasses (${(glassesDrunk * 250)} ml)",
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.remove_circle_outline,
                                  color: Colors.redAccent,
                                ),
                                onPressed: glassesDrunk > 0
                                    ? () {
                                        setState(() {
                                          glassesDrunk--;
                                        });
                                      }
                                    : null,
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.add_circle_rounded,
                                  color: Colors.lightBlue,
                                  size: 28,
                                ),
                                onPressed: () {
                                  setState(() {
                                    glassesDrunk++;
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // 4️⃣ Weight Card
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.scale_outlined,
                              size: 18,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            "Weight",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      const Icon(
                        Icons.chevron_right_rounded,
                        color: Colors.black54,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),

      // 🔘 Bottom Navigation Bar with Hub Page Link
      bottomNavigationBar: Container(
        height: 80,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(35)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(
                Icons.grid_view_rounded,
                color: Color(0xFFC7F464),
                size: 26,
              ),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(
                Icons.show_chart_rounded,
                color: Colors.black38,
                size: 26,
              ),
              onPressed: () {},
            ),
            // Center Floating Camera Button
            GestureDetector(
              onTap: _showCameraOptions,
              child: Container(
                width: 56,
                height: 56,
                decoration: const BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.camera_alt_outlined,
                  color: Colors.white,
                  size: 26,
                ),
              ),
            ),
            // 🌟 HUB PAGE BUTTON (SKETCH INTEGRATION)
            IconButton(
              icon: const Icon(
                Icons.widgets_outlined,
                color: Colors.black87,
                size: 26,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HubPage()),
                );
              },
            ),
            // Profile Picture
            // Profile Picture
            Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFC7F464), width: 2),
              ),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UserProfileScreen()),
                  );
                },
                child: const CircleAvatar(
                  radius: 14,
                  backgroundImage: NetworkImage(
                    "https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=100&q=80",
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCircleIconButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Icon(icon, size: 18, color: Colors.black87),
      ),
    );
  }

  Widget _buildMacroRow(
    String label,
    double current,
    double target,
    Color color,
  ) {
    int percent = ((current / target) * 100).toInt();
    double barValue = (current / target).clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            Text(
              "${current % 1 == 0 ? current.toInt() : current} / ${target.toInt()} g",
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            SizedBox(
              width: 40,
              child: Text(
                "$percent%",
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                  color: Colors.black,
                ),
              ),
            ),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: barValue,
                  minHeight: 12,
                  backgroundColor: const Color(0xFFF2F3F0),
                  color: color,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// =============================================================================
// 📱 2x2 GRID HUB PAGE (MATCHES YOUR SKETCH)
// =============================================================================
class HubPage extends StatelessWidget {
  const HubPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8F5),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Fitness Hub",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.95,
          children: [
            // 1. Recipes Card
            _buildHubCard(
              context,
              title: "Recipe",
              subtitle: "Diet & Meal Plans",
              icon: Icons.restaurant_menu_rounded,
              color: const Color(0xFFFFE082),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const RecipesScreen()),
              ),
            ),
            // 2. Exercise Card
            _buildHubCard(
              context,
              title: "Exercise",
              subtitle: "AI Workout Videos",
              icon: Icons.fitness_center_rounded,
              color: const Color(0xFFB39DDB),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ExerciseScreen()),
              ),
            ),
            // 3. PM (Personal Mentor) Card
            _buildHubCard(
              context,
              title: "P M",
              subtitle: "AI Personal Mentor",
              icon: Icons.psychology_rounded,
              color: const Color(0xFF80CBC4),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MentorChatScreen()),
              ),
            ),
            // 4. Myths vs Facts Card
            _buildHubCard(
              context,
              title: "Myths & Facts",
              subtitle: "Do's & Don'ts Guide",
              icon: Icons.lightbulb_outline_rounded,
              color: const Color(0xFFFFAB91),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MythsScreen()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHubCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 28, color: Colors.black87),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// 🍲 1. RECIPES SUB-SCREEN
// -----------------------------------------------------------------------------
class RecipesScreen extends StatelessWidget {
  const RecipesScreen({Key? key}) : super(key: key);

  final List<Map<String, String>> recipes = const [
    {
      "name": "Avocado & Egg Toast",
      "calories": "320 kcal",
      "tag": "Keto",
      "time": "10 min",
    },
    {
      "name": "Grilled Chicken Salad",
      "calories": "410 kcal",
      "tag": "High Protein",
      "time": "20 min",
    },
    {
      "name": "Oatmeal Smoothie Bowl",
      "calories": "280 kcal",
      "tag": "Low Fat",
      "time": "5 min",
    },
    {
      "name": "Quinoa Veggie Bowl",
      "calories": "350 kcal",
      "tag": "Vegan",
      "time": "15 min",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8F5),
      appBar: AppBar(
        title: const Text(
          "Weight Loss Recipes",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: recipes.length,
        itemBuilder: (context, index) {
          final item = recipes[index];
          return Card(
            elevation: 0,
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(12),
              leading: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: const Color(0xFFD7F58C),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.set_meal_rounded,
                  color: Colors.black87,
                ),
              ),
              title: Text(
                item['name']!,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text("${item['calories']} • ${item['time']}"),
              trailing: Chip(
                label: Text(item['tag']!, style: const TextStyle(fontSize: 11)),
                backgroundColor: Colors.grey.shade200,
              ),
            ),
          );
        },
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// 🏋️ 2. EXERCISE SUB-SCREEN
// -----------------------------------------------------------------------------
class ExerciseScreen extends StatelessWidget {
  const ExerciseScreen({Key? key}) : super(key: key);

  final List<Map<String, String>> workouts = const [
    {
      "title": "Full Body HIIT Workout",
      "duration": "15 mins",
      "level": "Beginner",
    },
    {
      "title": "Fat Burning Cardio",
      "duration": "20 mins",
      "level": "Intermediate",
    },
    {"title": "Core & Abs Blast", "duration": "10 mins", "level": "All Levels"},
    {
      "title": "Legs & Glutes Sculpt",
      "duration": "25 mins",
      "level": "Advanced",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8F5),
      appBar: AppBar(
        title: const Text(
          "AI Exercise & Workouts",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: workouts.length,
        itemBuilder: (context, index) {
          final w = workouts[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.play_arrow_rounded,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        w['title']!,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "${w['duration']} • ${w['level']}",
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// 🤖 3. PERSONAL MENTOR (AI CHATBOT SUB-SCREEN)
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
          "Hello! I am your AI Weight Loss Mentor. How can I help you today?",
    },
  ];
  final TextEditingController _msgController = TextEditingController();

  void _sendMessage() {
    if (_msgController.text.trim().isEmpty) return;
    String userText = _msgController.text;
    setState(() {
      messages.add({"sender": "user", "text": userText});
      _msgController.clear();
    });

    Future.delayed(const Duration(milliseconds: 800), () {
      setState(() {
        messages.add({
          "sender": "ai",
          "text":
              "That's a great question! For consistent weight loss, maintain a slight calorie deficit and stay hydrated.",
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8F5),
      appBar: AppBar(
        title: const Text(
          "AI Personal Mentor",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final isUser = messages[index]['sender'] == "user";
                return Align(
                  alignment: isUser
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: isUser ? const Color(0xFFD7F58C) : Colors.white,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Text(
                      messages[index]['text']!,
                      style: const TextStyle(color: Colors.black87),
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _msgController,
                    decoration: const InputDecoration(
                      hintText: "Ask your AI Coach...",
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send_rounded, color: Colors.black),
                  onPressed: _sendMessage,
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
// 💡 4. MYTHS & FACTS (DO'S AND DON'TS SUB-SCREEN)
// -----------------------------------------------------------------------------
class MythsScreen extends StatelessWidget {
  const MythsScreen({Key? key}) : super(key: key);

  final List<Map<String, String>> items = const [
    {
      "type": "Myth",
      "title": "Skipping meals helps you lose weight faster.",
      "desc":
          "Fact: Skipping meals can slow down metabolism and lead to overeating later.",
    },
    {
      "type": "Do",
      "title": "Drink water before meals.",
      "desc":
          "Drinking water 30 mins before food helps digestion and calorie reduction.",
    },
    {
      "type": "Don't",
      "title": "Avoid completely cutting out carbs.",
      "desc":
          "Carbs give energy. Focus on complex carbs like oats & brown rice instead.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8F5),
      appBar: AppBar(
        title: const Text(
          "Weight Loss Do's & Don'ts",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          bool isMyth = item['type'] == "Myth";
          return Container(
            margin: const EdgeInsets.only(bottom: 14),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Chip(
                  label: Text(
                    item['type']!,
                    style: TextStyle(
                      color: isMyth
                          ? Colors.red.shade800
                          : Colors.green.shade800,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  backgroundColor: isMyth
                      ? Colors.red.shade50
                      : Colors.green.shade50,
                ),
                const SizedBox(height: 8),
                Text(
                  item['title']!,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item['desc']!,
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
