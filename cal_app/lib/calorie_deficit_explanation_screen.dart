import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class OnboardingGraphWizard extends StatefulWidget {
  final double weightKg;
  final double heightCm;
  final int age;
  final String gender;

  const OnboardingGraphWizard({
    Key? key,
    this.weightKg = 80.0,
    this.heightCm = 175.0,
    this.age = 25,
    this.gender = "Male",
  }) : super(key: key);

  @override
  State<OnboardingGraphWizard> createState() => _OnboardingGraphWizardState();
}

class _OnboardingGraphWizardState extends State<OnboardingGraphWizard>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Animation for the 3-Month Projection Graph (Step 3)
  late AnimationController _projectionAnimController;
  late Animation<double> _chartAnimation;

  @override
  void initState() {
    super.initState();

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
    setState(() {
      _currentPage = index;
    });

    // Jab user Page 3 (Projection Graph) par pahocha tabhi animation play hogi
    if (index == 2) {
      _projectionAnimController.reset();
      _projectionAnimController.forward();
    }
  }

  void _nextPage() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      // Final Action (e.g., Navigate to Home Dashboard)
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Onboarding Completed!")));
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
            colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 12),
              _buildTopTracker(),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: _onPageChanged,
                  physics: const BouncingScrollPhysics(),
                  children: [
                    _buildBmiScreen(),
                    _buildEducationalGraphScreen(),
                    _buildProjectionGraphScreen(),
                  ],
                ),
              ),
              _buildBottomButton(),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================
  // TOP STEP TRACKER WIDGET
  // ==========================================
  Widget _buildTopTracker() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        bool isActive = index == _currentPage;
        bool isPassed = index < _currentPage;

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
                        colors: [Color(0xFF4FACFE), Color(0xFF00F2FE)],
                      )
                    : null,
                color: isActive
                    ? null
                    : (isPassed
                          ? const Color(0xFF00F2FE).withOpacity(0.2)
                          : Colors.white.withOpacity(0.08)),
                border: Border.all(
                  color: isActive
                      ? Colors.transparent
                      : (isPassed
                            ? const Color(0xFF00F2FE)
                            : Colors.white.withOpacity(0.2)),
                  width: 1.5,
                ),
              ),
              child: Center(
                child: isPassed
                    ? const Icon(
                        Icons.check,
                        size: 18,
                        color: Color(0xFF00F2FE),
                      )
                    : Text(
                        "${index + 1}",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: isActive ? Colors.black87 : Colors.white,
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
                    ? const Color(0xFF00F2FE)
                    : Colors.white.withOpacity(0.15),
              ),
          ],
        );
      }),
    );
  }

  // ==========================================
  // STEP 1: BMI DISPLAY PAGE
  // ==========================================
  Widget _buildBmiScreen() {
    double heightMeters = widget.heightCm / 100.0;
    double bmi = widget.weightKg / (heightMeters * heightMeters);

    String category = "Normal Weight";
    Color bmiColor = const Color(0xFF00F2FE);
    if (bmi < 18.5) {
      category = "Underweight";
      bmiColor = Colors.orangeAccent;
    } else if (bmi >= 25.0 && bmi < 30) {
      category = "Overweight";
      bmiColor = Colors.amberAccent;
    } else if (bmi >= 30) {
      category = "Obese";
      bmiColor = Colors.redAccent;
    }

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Container(
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.07),
                borderRadius: BorderRadius.circular(28.0),
                border: Border.all(color: Colors.white.withOpacity(0.18)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "YOUR CURRENT BMI",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white.withOpacity(0.5),
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
                      color: Colors.black.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _metricText("Weight", "${widget.weightKg} kg"),
                        _metricText("Height", "${widget.heightCm.toInt()} cm"),
                        _metricText(
                          "Age / Sex",
                          "${widget.age} / ${widget.gender[0]}",
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _metricText(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 10, color: Colors.white.withOpacity(0.4)),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  // ==========================================
  // STEP 2: EDUCATIONAL CALORIE DEFICIT SCREEN
  // ==========================================
  Widget _buildEducationalGraphScreen() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "HOW CALORIE DEFICIT WORKS",
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF00F2FE),
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            "Burn More Than You Eat",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "A steady 500 kcal daily deficit results in ~0.5kg of weight loss every week.",
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.07),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.white.withOpacity(0.15)),
                  ),
                  child: LineChart(
                    LineChartData(
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        getDrawingHorizontalLine: (v) => FlLine(
                          color: Colors.white.withOpacity(0.08),
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
                            getTitlesWidget: (v, m) => Text(
                              "${v.toInt()}k",
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.5),
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
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.5),
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
                          color: const Color(0xFF00F2FE),
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
                          color: Colors.orangeAccent,
                          barWidth: 3,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // STEP 3: ANIMATED PROJECTION GRAPH SCREEN
  // ==========================================
  Widget _buildProjectionGraphScreen() {
    double start = widget.weightKg;
    double noDeficitTarget = start + 2.5;
    double deficitTarget = start - 6.0;

    return AnimatedBuilder(
      animation: _chartAnimation,
      builder: (context, child) {
        double anim = _chartAnimation.value;

        // Dynamic points calculation based on animation progress
        double noDeficitM1 = start + (0.8 * anim);
        double noDeficitM2 = start + (1.6 * anim);
        double noDeficitM3 = start + ((noDeficitTarget - start) * anim);

        double deficitM1 = start - (2.0 * anim);
        double deficitM2 = start - (4.0 * anim);
        double deficitM3 = start - ((start - deficitTarget) * anim);

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
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "If you stay on track vs. maintaining current habits.",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _statBox(
                      "No Deficit",
                      "+2.5 kg",
                      "${noDeficitTarget.toStringAsFixed(1)} kg",
                      Colors.redAccent,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _statBox(
                      "With Deficit",
                      "-6.0 kg",
                      "${deficitTarget.toStringAsFixed(1)} kg",
                      const Color(0xFF00E676),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.07),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.15),
                        ),
                      ),
                      child: LineChart(
                        LineChartData(
                          minY: deficitTarget - 2,
                          maxY: noDeficitTarget + 2,
                          gridData: FlGridData(
                            show: true,
                            drawVerticalLine: false,
                            getDrawingHorizontalLine: (v) => FlLine(
                              color: Colors.white.withOpacity(0.08),
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
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.5),
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (v, m) {
                                  List<String> labels = [
                                    "Today",
                                    "M1",
                                    "M2",
                                    "M3",
                                  ];
                                  int idx = v.toInt();
                                  if (idx >= 0 && idx < labels.length) {
                                    return Text(
                                      labels[idx],
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.5),
                                        fontSize: 10,
                                      ),
                                    );
                                  }
                                  return const Text('');
                                },
                              ),
                            ),
                          ),
                          borderData: FlBorderData(show: false),
                          lineBarsData: [
                            // 🔴 RED LINE (Weight Increase)
                            LineChartBarData(
                              spots: [
                                FlSpot(0, start),
                                FlSpot(1, noDeficitM1),
                                FlSpot(2, noDeficitM2),
                                FlSpot(3, noDeficitM3),
                              ],
                              isCurved: true,
                              color: Colors.redAccent,
                              barWidth: 3.5,
                              dotData: const FlDotData(show: true),
                            ),
                            // 🟢 GREEN LINE (Weight Decrease)
                            LineChartBarData(
                              spots: [
                                FlSpot(0, start),
                                FlSpot(1, deficitM1),
                                FlSpot(2, deficitM2),
                                FlSpot(3, deficitM3),
                              ],
                              isCurved: true,
                              color: const Color(0xFF00E676),
                              barWidth: 3.5,
                              dotData: const FlDotData(show: true),
                              belowBarData: BarAreaData(
                                show: true,
                                color: const Color(0xFF00E676).withOpacity(0.1),
                              ),
                            ),
                          ],
                        ),
                      ),
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

  Widget _statBox(String title, String change, String total, Color color) {
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
              color: Colors.white,
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

  // ==========================================
  // BOTTOM NAV / CONTINUE BUTTON
  // ==========================================
  Widget _buildBottomButton() {
    String buttonText = "Continue";
    if (_currentPage == 1) buttonText = "See 3-Month Forecast";
    if (_currentPage == 2) buttonText = "Start My Plan";

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: SizedBox(
        height: 52,
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          onPressed: _nextPage,
          child: Ink(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF4FACFE), Color(0xFF00F2FE)],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Container(
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    buttonText,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.arrow_forward_rounded,
                    color: Colors.black87,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
