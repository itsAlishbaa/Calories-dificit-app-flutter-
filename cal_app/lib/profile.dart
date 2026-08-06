import 'package:flutter/material.dart';

import 'AgeGenderWeightScreen.dart'; // Contains userFullName, userEmailAddress
import 'bmi_graph_screen.dart'; // Contains userDOB, userAge
import 'target_weight_screen.dart'; // Contains userCurrentWeight, userHeightCm
import 'welcome_screen.dart'; // Contains userTargetWeight
import 'LoginOnboardingScreen.dart';
import 'user_data.dart'; // Contains userFullName, userEmailAddress, userDOB, userAge, userCurrentWeight, userHeightCm, userTargetWeight

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

  // --- 🧮 Dynamic Calculations (Imported variables se) ---
  double get bmiValue {
    double heightInMeters = userHeightCm / 100;
    return userCurrentWeight / (heightInMeters * heightInMeters);
  }

  String get bmiCategory {
    double bmi = bmiValue;
    if (bmi < 18.5) return "Underweight";
    if (bmi < 25.0) return "Normal Weight";
    if (bmi < 30.0) return "Overweight";
    return "Obese";
  }

  Color get bmiColor {
    double bmi = bmiValue;
    if (bmi < 18.5) return const Color(0xFFF59E0B);
    if (bmi < 25.0) return const Color(0xFF0D9488);
    return const Color(0xFFEF4444);
  }

  double get weightProgressPercent {
    if (userCurrentWeight == userTargetWeight) return 1.0;
    double remaining = (userCurrentWeight - userTargetWeight).abs();
    double progress = 1.0 - (remaining / 15.0);
    return progress.clamp(0.1, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppBar(
        title: const Text(
          "My Profile",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF0D9488),
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 1. Header Card (Name & Age imported)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 46,
                    backgroundColor: Color(0xFFCCFBF1),
                    child: Icon(
                      Icons.person,
                      size: 50,
                      color: Color(0xFF0D9488),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    userFullName, // 👈 Imported from user_name.dart
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "$userEmailAddress • $userAge yrs", // 👈 Imported
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 2. BMI Card (Calculated automatically from imported Height/Weight)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Body Mass Index (BMI)",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              bmiValue.toStringAsFixed(1),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: bmiColor.withOpacity(0.2),
                                border: Border.all(color: bmiColor, width: 1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                bmiCategory,
                                style: TextStyle(
                                  color: bmiColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const CircleAvatar(
                    radius: 26,
                    backgroundColor: Color(0xFF0D9488),
                    child: Icon(
                      Icons.monitor_weight_outlined,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 3. Grid View for Height, Weight, Target Weight & DOB
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.4,
              children: [
                _buildMetricCard(
                  icon: Icons.height,
                  iconColor: const Color(0xFF0284C7),
                  title: "Height",
                  value: "${userHeightCm.toInt()} cm", // 👈 Imported
                ),
                _buildMetricCard(
                  icon: Icons.scale,
                  iconColor: const Color(0xFF0D9488),
                  title: "Current Weight",
                  value: "$userCurrentWeight kg", // 👈 Imported
                ),
                _buildMetricCard(
                  icon: Icons.flag_rounded,
                  iconColor: const Color(0xFFF59E0B),
                  title: "Target Weight",
                  value: "$userTargetWeight kg", // 👈 Imported
                ),
                _buildMetricCard(
                  icon: Icons.cake_outlined,
                  iconColor: const Color(0xFFEC4899),
                  title: "Birthday",
                  value: userDOB, // 👈 Imported
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 4. Weight Goal Progress Bar
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Weight Goal Progress 🎯",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      Text(
                        "${(userCurrentWeight - userTargetWeight).abs().toStringAsFixed(1)} kg left",
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF0D9488),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: weightProgressPercent,
                      minHeight: 10,
                      backgroundColor: const Color(0xFFE2E8F0),
                      color: const Color(0xFF0D9488),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 6),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: iconColor, size: 18),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF64748B),
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
            ),
          ),
        ],
      ),
    );
  }
}
