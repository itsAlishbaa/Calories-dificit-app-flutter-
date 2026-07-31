import 'dart:ui';
import 'package:flutter/material.dart';
import 'onboarding_quiz_code.dart'; // Quiz file imported here!

class TargetWeightScreen extends StatefulWidget {
  final double currentWeightKg;
  final double heightCm;

  const TargetWeightScreen({
    Key? key,
    this.currentWeightKg = 78.0,
    this.heightCm = 175.0,
  }) : super(key: key);

  @override
  State<TargetWeightScreen> createState() => _TargetWeightScreenState();
}

class _TargetWeightScreenState extends State<TargetWeightScreen> {
  late double _targetWeight;
  late TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _targetWeight = widget.currentWeightKg > 40
        ? widget.currentWeightKg - 5
        : 65.0;
    _textController = TextEditingController(
      text: _targetWeight.toStringAsFixed(1),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _updateTargetWeight(double newValue) {
    double clamped = newValue.clamp(30.0, 200.0);
    setState(() {
      _targetWeight = double.parse(clamped.toStringAsFixed(1));
      _textController.text = _targetWeight.toStringAsFixed(1);
    });
  }

  // MODIFIED ACTION: Navigates to Quiz Screen now
  void _onNextPressed() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const OnboardingQuizFlow()));
  }

  @override
  Widget build(BuildContext context) {
    double weightDifference = widget.currentWeightKg - _targetWeight;
    bool isWeightLoss = weightDifference >= 0;

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
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 16.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios_rounded,
                    color: Colors.white,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                const SizedBox(height: 10),

                const Text(
                  "SET YOUR GOAL",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF00F2FE),
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  "What is your target weight?",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                const Spacer(),

                ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.06),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.12),
                        ),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            "TARGET WEIGHT",
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 16),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildCircularButton(
                                icon: Icons.remove,
                                onTap: () =>
                                    _updateTargetWeight(_targetWeight - 0.5),
                              ),
                              const SizedBox(width: 20),

                              IntrinsicWidth(
                                child: TextFormField(
                                  controller: _textController,
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                        decimal: true,
                                      ),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 48,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    isDense: true,
                                  ),
                                  onChanged: (val) {
                                    double? parsed = double.tryParse(val);
                                    if (parsed != null) {
                                      setState(() {
                                        _targetWeight = parsed;
                                      });
                                    }
                                  },
                                ),
                              ),
                              const Text(
                                " kg",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF00F2FE),
                                ),
                              ),
                              const SizedBox(width: 20),

                              _buildCircularButton(
                                icon: Icons.add,
                                onTap: () =>
                                    _updateTargetWeight(_targetWeight + 0.5),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              activeTrackColor: const Color(0xFF00F2FE),
                              inactiveTrackColor: Colors.white24,
                              thumbColor: const Color(0xFF00F2FE),
                              overlayColor: const Color(
                                0xFF00F2FE,
                              ).withOpacity(0.2),
                              thumbShape: const RoundSliderThumbShape(
                                enabledThumbRadius: 12,
                              ),
                            ),
                            child: Slider(
                              value: _targetWeight.clamp(30.0, 150.0),
                              min: 30.0,
                              max: 150.0,
                              onChanged: (val) => _updateTargetWeight(val),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: isWeightLoss
                          ? Colors.greenAccent.withOpacity(0.15)
                          : Colors.orangeAccent.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: isWeightLoss
                            ? Colors.greenAccent
                            : Colors.orangeAccent,
                      ),
                    ),
                    child: Text(
                      isWeightLoss
                          ? "🔥 Target: Lose ${weightDifference.toStringAsFixed(1)} kg"
                          : "💪 Target: Gain ${weightDifference.abs().toStringAsFixed(1)} kg",
                      style: TextStyle(
                        color: isWeightLoss
                            ? Colors.greenAccent
                            : Colors.orangeAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),

                const Spacer(),

                // Continue to Questions Screen Button
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00F2FE),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: _onNextPressed,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Continue to Questions",
                          style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCircularButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xFF00F2FE).withOpacity(0.15),
          border: Border.all(color: const Color(0xFF00F2FE)),
        ),
        child: Icon(icon, color: const Color(0xFF00F2FE), size: 24),
      ),
    );
  }
}
