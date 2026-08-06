import 'dart:ui';
import 'package:flutter/material.dart';
import 'AgeGenderWeightScreen.dart';
import 'app_palette.dart'; // 👈 Aapki custom AppPalette file import yahan hai

class LoginOnboardingScreen extends StatefulWidget {
  const LoginOnboardingScreen({Key? key}) : super(key: key);

  @override
  State<LoginOnboardingScreen> createState() => _LoginOnboardingScreenState();
}

class _LoginOnboardingScreenState extends State<LoginOnboardingScreen> {
  final TextEditingController _nameController = TextEditingController();
  int _currentStep = 1;
  final int _totalSteps = 4;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your name first!'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    if (_currentStep < _totalSteps) {
      setState(() {
        _currentStep++;
      });

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AgeGenderWeightScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

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
              const SizedBox(height: 20),
              _buildStepTracker(),
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(28),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                            child: Container(
                              width: size.width * 0.9,
                              padding: const EdgeInsets.all(28.0),
                              decoration: BoxDecoration(
                                color: AppPalette.glassBg,
                                borderRadius: BorderRadius.circular(28.0),
                                border: Border.all(
                                  color: AppPalette.glassBorder,
                                  width: 1.5,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppPalette.glassShadow,
                                    blurRadius: 30,
                                    offset: const Offset(0, 15),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppPalette.accentNeonViolet
                                          .withOpacity(0.12),
                                      border: Border.all(
                                        color: AppPalette.accentNeonViolet
                                            .withOpacity(0.3),
                                        width: 1.5,
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.person_outline_rounded,
                                      size: 30,
                                      color: AppPalette.accentNeonViolet,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  const Text(
                                    "Let's get started",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: AppPalette.accentNeonViolet,
                                      letterSpacing: 0.8,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  const Text(
                                    "What's your name?",
                                    style: TextStyle(
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold,
                                      color: AppPalette.pureWhite,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    "We'll use this to personalize your calorie plan and keep you motivated along the way.",
                                    style: TextStyle(
                                      fontSize: 13.5,
                                      height: 1.4,
                                      color: AppPalette.pureWhite.withOpacity(
                                        0.65,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 28),
                                  const Text(
                                    "FULL NAME",
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: AppPalette.textMuted,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  TextField(
                                    controller: _nameController,
                                    style: const TextStyle(
                                      color: AppPalette.pureWhite,
                                      fontSize: 15,
                                    ),
                                    cursorColor: AppPalette.accentNeonViolet,
                                    decoration: InputDecoration(
                                      hintText: "e.g. Alishba",
                                      hintStyle: TextStyle(
                                        color: AppPalette.pureWhite.withOpacity(
                                          0.3,
                                        ),
                                        fontSize: 15,
                                      ),
                                      filled: true,
                                      fillColor: Colors.black.withOpacity(0.2),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            horizontal: 20,
                                            vertical: 16,
                                          ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        borderSide: BorderSide(
                                          color: AppPalette.pureWhite
                                              .withOpacity(0.12),
                                          width: 1,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        borderSide: const BorderSide(
                                          color: AppPalette.accentNeonViolet,
                                          width: 1.5,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 28),
                                  SizedBox(
                                    width: double.infinity,
                                    height: 52,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          colors: [
                                            AppPalette.primaryPurple,
                                            AppPalette.accentNeonViolet,
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(16),
                                        boxShadow: [
                                          BoxShadow(
                                            color: AppPalette.accentNeonViolet
                                                .withOpacity(0.35),
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
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ),
                                          ),
                                        ),
                                        onPressed: _nextStep,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: const [
                                            Text(
                                              "Continue",
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: AppPalette.bgDark,
                                              ),
                                            ),
                                            SizedBox(width: 8),
                                            Icon(
                                              Icons.arrow_forward_rounded,
                                              color: AppPalette.bgDark,
                                              size: 20,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          "Step 1 of 4",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: AppPalette.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepTracker() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_totalSteps, (index) {
        int stepNumber = index + 1;
        bool isActive = stepNumber == _currentStep;
        bool isPassed = stepNumber < _currentStep;

        return Row(
          children: [
            Container(
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
                boxShadow: isActive
                    ? [
                        BoxShadow(
                          color: AppPalette.accentNeonViolet.withOpacity(0.4),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : [],
              ),
              child: Center(
                child: Text(
                  "$stepNumber",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isActive ? AppPalette.bgDark : AppPalette.pureWhite,
                  ),
                ),
              ),
            ),
            if (index < _totalSteps - 1)
              Container(
                width: 24,
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
