import 'dart:ui';
import 'package:flutter/material.dart';
import 'loginonboardingscreen.dart';

// App Palette matching the Dark Purple Glassmorphic Theme
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

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        // Updated Dark Purple Gradient Background
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
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo Icon Container with Glass Effect & Neon Glow
                  ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppPalette.glassBg,
                          border: Border.all(
                            color: AppPalette.glassBorder,
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppPalette.primaryPurple.withOpacity(0.3),
                              blurRadius: 25,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.auto_awesome_rounded,
                          size: 48,
                          color: AppPalette.accentNeonViolet,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    "Welcome Back",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                      color: AppPalette.pureWhite,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Select an option to get started",
                    style: TextStyle(
                      fontSize: 14,
                      color: AppPalette.pureWhite.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 48),

                  // Main Glassmorphic Card Container
                  ClipRRect(
                    borderRadius: BorderRadius.circular(24.0),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                      child: Container(
                        width: size.width * 0.9,
                        padding: const EdgeInsets.all(24.0),
                        decoration: BoxDecoration(
                          color: AppPalette.glassBg,
                          borderRadius: BorderRadius.circular(24.0),
                          border: Border.all(
                            color: AppPalette.glassBorder,
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppPalette.glassShadow,
                              blurRadius: 25,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            // --- LOGIN BUTTON (Neon Gradient) ---
                            Expanded(
                              child: Container(
                                height: 52,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      AppPalette.primaryPurple,
                                      AppPalette.accentPink,
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(14),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppPalette.primaryPurple
                                          .withOpacity(0.4),
                                      blurRadius: 12,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const LoginOnboardingScreen(),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    "Login",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(width: 16),

                            // --- SIGN UP BUTTON (Frosted Glass Border) ---
                            Expanded(
                              child: Container(
                                height: 52,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: AppPalette.glassBorder,
                                    width: 1.5,
                                  ),
                                  color: AppPalette.glassBg,
                                ),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                  ),
                                  onPressed: () {
                                    // TODO: Sign Up Action
                                  },
                                  child: const Text(
                                    "Sign Up",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: AppPalette.pureWhite,
                                    ),
                                  ),
                                ),
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
        ),
      ),
    );
  }
}
