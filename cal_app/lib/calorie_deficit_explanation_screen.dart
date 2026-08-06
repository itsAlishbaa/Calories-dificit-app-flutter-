import 'dart:ui';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'app_palette.dart';
import 'main_ui.dart';

class OnboardingGraphWizard extends StatefulWidget {
  final double weightKg;
  final double heightCm;
  final int age;
  final String gender;

  const OnboardingGraphWizard({
    super.key,
    this.weightKg = 80.0,
    this.heightCm = 175.0,
    this.age = 25,
    this.gender = "Male",
  });

  @override
  State<OnboardingGraphWizard> createState() => _OnboardingGraphWizardState();
}

class _OnboardingGraphWizardState extends State<OnboardingGraphWizard>
    with SingleTickerProviderStateMixin {
  late final PageController _pageController;
  late final AnimationController _projectionAnimController;
  late final Animation<double> _chartAnimation;

  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    _projectionAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _chartAnimation = CurvedAnimation(
      parent: _projectionAnimController,
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _projectionAnimController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() => _currentPage = index);

    if (index == 2) {
      _projectionAnimController.forward(from: 0.0);
    }
  }

  void _nextPage() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainUI()),
      );
    }
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
            colors: [
              AppPalette.bgDark,
              AppPalette.bgPurpleMid,
              AppPalette.bgPurpleAccent,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 12),
              TopStepTracker(currentPage: _currentPage),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: _onPageChanged,
                  physics: const BouncingScrollPhysics(),
                  children: [
                    BmiScreen(
                      weightKg: widget.weightKg,
                      heightCm: widget.heightCm,
                      age: widget.age,
                      gender: widget.gender,
                    ),
                    const EducationalGraphScreen(),
                    ProjectionGraphScreen(
                      weightKg: widget.weightKg,
                      animation: _chartAnimation,
                    ),
                  ],
                ),
              ),
              BottomActionButton(
                currentPage: _currentPage,
                onPressed: _nextPage,
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================
// TOP STEP TRACKER
// ==========================================
class TopStepTracker extends StatelessWidget {
  final int currentPage;

  const TopStepTracker({super.key, required this.currentPage});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        final bool isActive = index == currentPage;
        final bool isPassed = index < currentPage;

        return Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: isActive
                    ? const LinearGradient(
                        colors: [
                          AppPalette.primaryPurple,
                          AppPalette.accentNeonViolet,
                        ],
                      )
                    : null,
                color: isActive
                    ? null
                    : (isPassed
                          ? AppPalette.accentNeonViolet.withOpacity(0.2)
                          : AppPalette.pureWhite.withOpacity(0.08)),
                border: Border.all(
                  color: isActive
                      ? Colors.transparent
                      : (isPassed
                            ? AppPalette.accentNeonViolet
                            : AppPalette.pureWhite.withOpacity(0.2)),
                  width: 1.5,
                ),
              ),
              child: Center(
                child: isPassed
                    ? const Icon(
                        Icons.check,
                        size: 18,
                        color: AppPalette.accentNeonViolet,
                      )
                    : Text(
                        "${index + 1}",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: isActive
                              ? AppPalette.bgDark
                              : AppPalette.pureWhite,
                        ),
                      ),
              ),
            ),
            if (index < 2)
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 30,
                height: 2,
                margin: const EdgeInsets.symmetric(horizontal: 6),
                color: isPassed
                    ? AppPalette.accentNeonViolet
                    : AppPalette.pureWhite.withOpacity(0.15),
              ),
          ],
        );
      }),
    );
  }
}

// ==========================================
// STEP 1: BMI DISPLAY PAGE
// ==========================================
class BmiScreen extends StatelessWidget {
  final double weightKg;
  final double heightCm;
  final int age;
  final String gender;

  const BmiScreen({
    super.key,
    required this.weightKg,
    required this.heightCm,
    required this.age,
    required this.gender,
  });

  @override
  Widget build(BuildContext context) {
    final double heightMeters = heightCm / 100.0;
    final double bmi = weightKg / (heightMeters * heightMeters);

    String category = "Normal Weight";
    Color bmiColor = AppPalette.accentNeonViolet;

    if (bmi < 18.5) {
      category = "Underweight";
      bmiColor = AppPalette.accentPink;
    } else if (bmi >= 25.0 && bmi < 30) {
      category = "Overweight";
      bmiColor = AppPalette.accentPink;
    } else if (bmi >= 30) {
      category = "Obese";
      bmiColor = AppPalette.accentPink;
    }

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Center(
        child: GlassContainer(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "YOUR CURRENT BMI",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppPalette.textMuted,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                bmi.toStringAsFixed(1),
                style: TextStyle(
                  fontSize: 60,
                  fontWeight: FontWeight.w800,
                  color: bmiColor,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: bmiColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: bmiColor, width: 1.5),
                ),
                child: Text(
                  category.toUpperCase(),
                  style: TextStyle(
                    color: bmiColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
              const SizedBox(height: 28),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppPalette.glassShadow,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    MetricTile(label: "Weight", value: "$weightKg kg"),
                    MetricTile(
                      label: "Height",
                      value: "${heightCm.toInt()} cm",
                    ),
                    MetricTile(
                      label: "Age / Sex",
                      value: "$age / ${gender.isNotEmpty ? gender[0] : ''}",
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

class MetricTile extends StatelessWidget {
  final String label;
  final String value;

  const MetricTile({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 10, color: AppPalette.textMuted),
        ),
        const SizedBox(height: 4),
         Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: AppPalette.textDark,
          ),
        ),
      ],
    );
  }
}

// ==========================================
// STEP 2: EDUCATIONAL GRAPH SCREEN
// ==========================================
class EducationalGraphScreen extends StatelessWidget {
  const EducationalGraphScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "HOW CALORIE DEFICIT WORKS",
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: AppPalette.accentNeonViolet,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            "Burn More Than You Eat",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppPalette.textDark,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            "A steady 500 kcal daily deficit results in ~0.5kg of weight loss every week.",
            style: TextStyle(fontSize: 12, color: AppPalette.textMuted),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: GlassContainer(
              padding: const EdgeInsets.all(18),
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    getDrawingHorizontalLine: (v) => FlLine(
                      color: AppPalette.pureWhite.withOpacity(0.08),
                      strokeWidth: 1,
                    ),
                  ),
                  titlesData: FlTitlesData(
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 28,
                        getTitlesWidget: (v, m) => const Text(
                          "",
                          style: TextStyle(
                            color: AppPalette.textMuted,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (v, m) => Text(
                          "W${v.toInt()}",
                          style: const TextStyle(
                            color: AppPalette.textMuted,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: const [
                        FlSpot(1, 3.5),
                        FlSpot(2, 7.0),
                        FlSpot(3, 10.5),
                        FlSpot(4, 14.0),
                      ],
                      isCurved: true,
                      color: AppPalette.accentNeonViolet,
                      barWidth: 3,
                    ),
                    LineChartBarData(
                      spots: const [
                        FlSpot(1, 0.5),
                        FlSpot(2, 1.2),
                        FlSpot(3, 1.8),
                        FlSpot(4, 2.5),
                      ],
                      isCurved: true,
                      color: AppPalette.accentPink,
                      barWidth: 3,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// STEP 3: ANIMATED PROJECTION GRAPH SCREEN
// ==========================================
class ProjectionGraphScreen extends StatelessWidget {
  final double weightKg;
  final Animation<double> animation;

  const ProjectionGraphScreen({
    super.key,
    required this.weightKg,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    final double noDeficitTarget = weightKg + 2.5;
    final double deficitTarget = weightKg - 6.0;

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final double anim = animation.value;

        final double noDeficitM1 = weightKg + (0.8 * anim);
        final double noDeficitM2 = weightKg + (1.6 * anim);
        final double noDeficitM3 =
            weightKg + ((noDeficitTarget - weightKg) * anim);

        final double deficitM1 = weightKg - (2.0 * anim);
        final double deficitM2 = weightKg - (4.0 * anim);
        final double deficitM3 = weightKg - ((weightKg - deficitTarget) * anim);

        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "3-Month Weight Forecast",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppPalette.textDark,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                "If you stay on track vs. maintaining current habits.",
                style: TextStyle(fontSize: 12, color: AppPalette.textMuted),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: StatCard(
                      title: "No Deficit",
                      change: "+2.5 kg",
                      total: "${noDeficitTarget.toStringAsFixed(1)} kg",
                      color: AppPalette.accentPink,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: StatCard(
                      title: "With Deficit",
                      change: "-6.0 kg",
                      total: "${deficitTarget.toStringAsFixed(1)} kg",
                      color: AppPalette.accentNeonViolet,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: GlassContainer(
                  padding: const EdgeInsets.all(16),
                  child: LineChart(
                    LineChartData(
                      minY: deficitTarget - 2,
                      maxY: noDeficitTarget + 2,
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        getDrawingHorizontalLine: (v) => FlLine(
                          color: AppPalette.pureWhite.withOpacity(0.08),
                          strokeWidth: 1,
                        ),
                      ),
                      titlesData: FlTitlesData(
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 34,
                            getTitlesWidget: (v, m) => Text(
                              "${v.toInt()}kg",
                              style: const TextStyle(
                                color: AppPalette.textMuted,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (v, m) {
                              const labels = ["Today", "M1", "M2", "M3"];
                              final idx = v.toInt();
                              if (idx >= 0 && idx < labels.length) {
                                return Text(
                                  labels[idx],
                                  style: const TextStyle(
                                    color: AppPalette.textMuted,
                                    fontSize: 10,
                                  ),
                                );
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      lineBarsData: [
                        LineChartBarData(
                          spots: [
                            FlSpot(0, weightKg),
                            FlSpot(1, noDeficitM1),
                            FlSpot(2, noDeficitM2),
                            FlSpot(3, noDeficitM3),
                          ],
                          isCurved: true,
                          color: AppPalette.accentPink,
                          barWidth: 3.5,
                          dotData: const FlDotData(show: true),
                        ),
                        LineChartBarData(
                          spots: [
                            FlSpot(0, weightKg),
                            FlSpot(1, deficitM1),
                            FlSpot(2, deficitM2),
                            FlSpot(3, deficitM3),
                          ],
                          isCurved: true,
                          color: AppPalette.accentNeonViolet,
                          barWidth: 3.5,
                          dotData: const FlDotData(show: true),
                          belowBarData: BarAreaData(
                            show: true,
                            color: AppPalette.accentNeonViolet.withOpacity(0.1),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class StatCard extends StatelessWidget {
  final String title;
  final String change;
  final String total;
  final Color color;

  const StatCard({
    super.key,
    required this.title,
    required this.change,
    required this.total,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            total,
            style: const TextStyle(
              color: AppPalette.textDark,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            change,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// REUSABLE GLASS CONTAINER WIDGET
// ==========================================
class GlassContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const GlassContainer({
    super.key,
    required this.child,
    this.padding = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: AppPalette.glassBg,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppPalette.glassBorder),
          ),
          child: child,
        ),
      ),
    );
  }
}

// ==========================================
// BOTTOM ACTION BUTTON
// ==========================================
class BottomActionButton extends StatelessWidget {
  final int currentPage;
  final VoidCallback onPressed;

  const BottomActionButton({
    super.key,
    required this.currentPage,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    String buttonText = "Continue";
    if (currentPage == 1) buttonText = "See 3-Month Forecast";
    if (currentPage == 2) buttonText = "Start My Plan";

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: SizedBox(
        height: 52,
        width: double.infinity,
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppPalette.primaryPurple, AppPalette.accentNeonViolet],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            onPressed: onPressed,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  buttonText,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppPalette.bgDark,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.arrow_forward_rounded,
                  color: AppPalette.bgDark,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
