import 'dart:ui';
import 'package:flutter/material.dart';
import 'target_weight_screen.dart';

class BmiGraphScreen extends StatefulWidget {
  final double weightKg;
  final double heightCm;
  final int age;
  final String gender;

  const BmiGraphScreen({
    Key? key,
    required this.weightKg,
    required this.heightCm,
    required this.age,
    required this.gender,
  }) : super(key: key);

  @override
  State<BmiGraphScreen> createState() => _BmiGraphScreenState();
}

class _BmiGraphScreenState extends State<BmiGraphScreen> {
  late double _bmi;
  late String _bmiCategory;
  late Color _themeColor;
  late List<Color> _backgroundGradient;

  @override
  void initState() {
    super.initState();
    _calculateBmiAndTheme();
  }

  void _calculateBmiAndTheme() {
    double heightMeters = widget.heightCm / 100.0;
    _bmi = widget.weightKg / (heightMeters * heightMeters);

    if (_bmi < 18.5) {
      _bmiCategory = "Underweight";
      _themeColor = const Color(0xFFFFB74D); // Soft Orange
      _backgroundGradient = const [
        Color(0xFF1E1B18),
        Color(0xFF2A231C),
        Color(0xFF141210),
      ];
    } else if (_bmi < 25.0) {
      _bmiCategory = "Normal Weight";
      _themeColor = const Color(0xFF00E676); // Vibrant Green/Cyan
      _backgroundGradient = const [
        Color(0xFF0F2027),
        Color(0xFF203A43),
        Color(0xFF2C5364),
      ];
    } else if (_bmi < 30.0) {
      _bmiCategory = "Overweight";
      _themeColor = const Color(0xFFFFD54F); // Amber Yellow
      _backgroundGradient = const [
        Color(0xFF232018),
        Color(0xFF2D281B),
        Color(0xFF14120E),
      ];
    } else {
      _bmiCategory = "Obese";
      _themeColor = const Color(0xFFFF5252); // Soft Red Accent
      _backgroundGradient = const [
        Color(0xFF251818),
        Color(0xFF331D1D),
        Color(0xFF140D0D),
      ];
    }
  }

  double _getBmiPositionRatio() {
    double minBmi = 15.0;
    double maxBmi = 35.0;
    double clampedBmi = _bmi.clamp(minBmi, maxBmi);
    return (clampedBmi - minBmi) / (maxBmi - minBmi);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: _backgroundGradient,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 12),
              _buildTopTracker(),
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(28),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                        child: Container(
                          padding: const EdgeInsets.all(28.0),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.06),
                            borderRadius: BorderRadius.circular(28.0),
                            border: Border.all(
                              color: _themeColor.withOpacity(0.3),
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.4),
                                blurRadius: 30,
                                offset: const Offset(0, 15),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _buildBmiDisplay(),
                              const SizedBox(height: 32),
                              _buildBmiGauge(),
                              const SizedBox(height: 32),
                              _buildUserDetailRow(),
                              const SizedBox(height: 32),
                              _buildContinueButton(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Text(
                "Step 3 of 4",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.white.withOpacity(0.5),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopTracker() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (index) {
        int stepNumber = index + 1;
        bool isActive = stepNumber == 3;
        bool isPassed = stepNumber < 3;

        return Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: isActive
                    ? LinearGradient(
                        colors: [_themeColor, _themeColor.withOpacity(0.7)],
                      )
                    : null,
                color: isActive
                    ? null
                    : (isPassed
                          ? _themeColor.withOpacity(0.2)
                          : Colors.white.withOpacity(0.08)),
                border: Border.all(
                  color: isActive
                      ? Colors.transparent
                      : (isPassed
                            ? _themeColor
                            : Colors.white.withOpacity(0.2)),
                  width: 1.5,
                ),
              ),
              child: Center(
                child: isPassed
                    ? Icon(Icons.check, size: 18, color: _themeColor)
                    : Text(
                        "$stepNumber",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: isActive ? Colors.black87 : Colors.white,
                        ),
                      ),
              ),
            ),
            if (index < 3)
              Container(
                width: 24,
                height: 2,
                margin: const EdgeInsets.symmetric(horizontal: 6),
                color: isPassed ? _themeColor : Colors.white.withOpacity(0.15),
              ),
          ],
        );
      }),
    );
  }

  Widget _buildBmiDisplay() {
    return Column(
      children: [
        Text(
          "YOUR BMI SCORE",
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.white.withOpacity(0.5),
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          _bmi.toStringAsFixed(1),
          style: TextStyle(
            fontSize: 64,
            fontWeight: FontWeight.w800,
            color: _themeColor,
            height: 1,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: _themeColor.withOpacity(0.15),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: _themeColor, width: 1.5),
          ),
          child: Text(
            _bmiCategory.toUpperCase(),
            style: TextStyle(
              color: _themeColor,
              fontWeight: FontWeight.bold,
              fontSize: 13,
              letterSpacing: 1.1,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBmiGauge() {
    return LayoutBuilder(
      builder: (context, constraints) {
        double maxWidth = constraints.maxWidth;
        double positionX = (maxWidth - 16) * _getBmiPositionRatio();

        return Column(
          children: [
            SizedBox(
              height: 24,
              child: Stack(
                children: [
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.easeOutBack,
                    left: positionX,
                    child: Icon(
                      Icons.arrow_drop_down_rounded,
                      color: _themeColor,
                      size: 32,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 2),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SizedBox(
                height: 10,
                child: Row(
                  children: [
                    Expanded(
                      flex: 185,
                      child: Container(color: const Color(0xFFFFB74D)),
                    ),
                    const SizedBox(width: 2),
                    Expanded(
                      flex: 65,
                      child: Container(color: const Color(0xFF00E676)),
                    ),
                    const SizedBox(width: 2),
                    Expanded(
                      flex: 50,
                      child: Container(color: const Color(0xFFFFD54F)),
                    ),
                    const SizedBox(width: 2),
                    Expanded(
                      flex: 100,
                      child: Container(color: const Color(0xFFFF5252)),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildGaugeLabel("18.5", "Under"),
                _buildGaugeLabel("25.0", "Normal"),
                _buildGaugeLabel("30.0", "Over"),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildGaugeLabel(String val, String title) {
    return Column(
      children: [
        Text(
          val,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: Colors.white.withOpacity(0.7),
          ),
        ),
        Text(
          title,
          style: TextStyle(fontSize: 10, color: Colors.white.withOpacity(0.4)),
        ),
      ],
    );
  }

  Widget _buildUserDetailRow() {
    String genderShort = widget.gender.isNotEmpty
        ? widget.gender[0].toUpperCase()
        : '-';

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildMetricItem(
            "Weight",
            "${widget.weightKg.toStringAsFixed(1)} kg",
          ),
          Container(
            width: 1,
            height: 24,
            color: Colors.white.withOpacity(0.15),
          ),
          _buildMetricItem("Height", "${widget.heightCm.toInt()} cm"),
          Container(
            width: 1,
            height: 24,
            color: Colors.white.withOpacity(0.15),
          ),
          _buildMetricItem("Age / Gender", "${widget.age} / $genderShort"),
        ],
      ),
    );
  }

  Widget _buildMetricItem(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: Colors.white.withOpacity(0.4),
            fontWeight: FontWeight.w500,
          ),
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

  Widget _buildContinueButton() {
    return SizedBox(
      height: 52,
      width: double.infinity,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [_themeColor, _themeColor.withOpacity(0.8)],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: _themeColor.withOpacity(0.35),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TargetWeightScreen(
                  currentWeightKg: widget.weightKg,
                  heightCm: widget.heightCm,
                ),
              ),
            );
          },
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Finish Step 3",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(width: 8),
              Icon(
                Icons.arrow_forward_rounded,
                color: Colors.black87,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
