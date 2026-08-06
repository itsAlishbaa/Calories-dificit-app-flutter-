import 'dart:ui';
import 'package:flutter/material.dart';

import 'AgeGenderWeightScreen.dart';
import 'bmi_graph_screen.dart';
import 'target_weight_screen.dart';
import 'welcome_screen.dart';
import 'LoginOnboardingScreen.dart';
import 'user_data.dart';

// Dark Purple Glassmorphic Palette Definition
class AppPalette {
  static const bgDark = Color(0xFF0F081D);
  static const bgPurpleMid = Color(0xFF1D1035);
  static const bgPurpleAccent = Color(0xFF2D124D);

  static const primaryPurple = Color(0xFFA855F7);
  static const accentNeonViolet = Color(0xFFC084FC);
  static const accentPink = Color(0xFFEC4899);

  static Color glassBg = Colors.white.withOpacity(0.07);
  static Color glassBorder = Colors.white.withOpacity(0.18);
  static Color glassShadow = Colors.black.withOpacity(0.3);

  static const pureWhite = Colors.white;
  static const textMuted = Color(0xFF9CA3AF);
}

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

  // --- Dynamic Calculations ---
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
    if (bmi < 18.5) return const Color(0xFFFACC15); // Yellow/Orange
    if (bmi < 25.0) return AppPalette.accentNeonViolet; // Neon Purple
    return AppPalette.accentPink; // Pinkish Red
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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          "My Profile",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppPalette.pureWhite,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppPalette.bgDark,
              AppPalette.bgPurpleMid,
              AppPalette.bgPurpleAccent,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // 1. Header Card (Glassmorphic Container)
                _buildGlassCard(
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppPalette.accentNeonViolet,
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppPalette.primaryPurple.withOpacity(0.4),
                              blurRadius: 15,
                            ),
                          ],
                        ),
                        child: const CircleAvatar(
                          radius: 42,
                          backgroundColor: AppPalette.bgPurpleMid,
                          child: Icon(
                            Icons.person,
                            size: 48,
                            color: AppPalette.accentNeonViolet,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        userFullName,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppPalette.pureWhite,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "$userEmailAddress • $userAge yrs",
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppPalette.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // 2. BMI Card
                _buildGlassCard(
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Body Mass Index (BMI)",
                              style: TextStyle(
                                color: AppPalette.textMuted,
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
                                    color: AppPalette.pureWhite,
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
                                    border: Border.all(
                                      color: bmiColor,
                                      width: 1,
                                    ),
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
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppPalette.primaryPurple.withOpacity(0.2),
                          border: Border.all(color: AppPalette.glassBorder),
                        ),
                        child: const Icon(
                          Icons.monitor_weight_outlined,
                          color: AppPalette.accentNeonViolet,
                          size: 26,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // 3. Metric Cards Grid
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
                      iconColor: const Color(0xFF38BDF8),
                      title: "Height",
                      value: "${userHeightCm.toInt()} cm",
                    ),
                    _buildMetricCard(
                      icon: Icons.scale,
                      iconColor: AppPalette.primaryPurple,
                      title: "Current Weight",
                      value: "$userCurrentWeight kg",
                    ),
                    _buildMetricCard(
                      icon: Icons.flag_rounded,
                      iconColor: const Color(0xFFFB923C),
                      title: "Target Weight",
                      value: "$userTargetWeight kg",
                    ),
                    _buildMetricCard(
                      icon: Icons.cake_outlined,
                      iconColor: AppPalette.accentPink,
                      title: "Birthday",
                      value: userDOB,
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // 4. Weight Goal Progress Bar Card
                _buildGlassCard(
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
                              color: AppPalette.pureWhite,
                            ),
                          ),
                          Text(
                            "${(userCurrentWeight - userTargetWeight).abs().toStringAsFixed(1)} kg left",
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppPalette.accentNeonViolet,
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
                          backgroundColor: Colors.white.withOpacity(0.1),
                          color: AppPalette.primaryPurple,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Generic Glassmorphic Box Wrapper
  Widget _buildGlassCard({required Widget child, EdgeInsetsGeometry? padding}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          width: double.infinity,
          padding: padding ?? const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppPalette.glassBg,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppPalette.glassBorder, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: AppPalette.glassShadow,
                blurRadius: 15,
                spreadRadius: -2,
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }

  // Metric Card for Grid
  Widget _buildMetricCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
  }) {
    return _buildGlassCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: iconColor.withOpacity(0.4),
                    width: 1,
                  ),
                ),
                child: Icon(icon, color: iconColor, size: 18),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppPalette.textMuted,
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
              color: AppPalette.pureWhite,
            ),
          ),
        ],
      ),
    );
  }
}
