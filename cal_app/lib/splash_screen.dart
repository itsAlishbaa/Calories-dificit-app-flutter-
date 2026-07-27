// ============================================================================
// CALORIE COUNTER — SPLASH SCREEN
// ============================================================================
// A pixel-close recreation of the uploaded design:
//  - Pure black background
//  - Blurred food bowls floating behind a centered phone mockup
//  - Phone mockup contains a miniature replica of the app's home UI
//    (date strip, "calories left" card, macros, meal records)
//  - Bottom banner: headline copy + a small "Breakfast" stat card
//
// HOW TO USE
// -----------------------------------------------------------------------
// 1. Drop this file into lib/splash_screen.dart
// 2. Add these to pubspec.yaml under flutter/assets (or swap for your own):
//        assets/images/food_bowl_1.png
//        assets/images/food_bowl_2.png
//        assets/images/food_bowl_3.png
//        assets/images/breakfast_icon.png
//    If you don't have these yet, the screen still renders perfectly using
//    the built-in vector/icon placeholders below (see _FoodBlob widget) —
//    swap Image.asset(...) in for the placeholder whenever you're ready.
// 3. Set SplashScreen() as your `home` in MaterialApp, or navigate to it
//    first and pushReplacement to your real home screen after a delay.
// ============================================================================

import 'package:flutter/material.dart';
import 'main.dart'; // <-- so we can navigate to MyHomePage after the splash

// ---------------------------------------------------------------------------
// COLORS
// ---------------------------------------------------------------------------
class _Palette {
  static const neonGreen = Color(0xFFB4E600);
  static const softGreen = Color(0xFF7ED957);
  static const cardCream = Color(0xFFFFF7EC);
  static const peach = Color(0xFFFFD9A0);
  static const mintBg = Color(0xFFE9F7E4);
  static const carbsOrange = Color(0xFFFF9F45);
  static const fatYellow = Color(0xFFFFD166);
  static const proteinBlue = Color(0xFF6EC6FF);
  static const textDark = Color(0xFF20241F);
  static const grey = Color(0xFF8A8F86);
}

// ---------------------------------------------------------------------------
// SPLASH SCREEN
// ---------------------------------------------------------------------------
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeIn;
  late final Animation<Offset> _phoneSlide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();

    _fadeIn = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _phoneSlide = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    // Navigate to your home page after the splash has been shown.
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => const MyHomePage(title: 'Flutter Demo Home Page'),
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final availableHeight = constraints.maxHeight;
          final availableWidth = constraints.maxWidth;

          return Stack(
            fit: StackFit.expand,
            children: [
              // ---- floating food imagery, blended softly into the black bg ----
              Positioned(
                top: availableHeight * 0.16,
                left: -availableWidth * 0.06,
                child: const _FoodBlob(diameter: 130, emoji: '🥗'),
              ),
              Positioned(
                top: availableHeight * 0.30,
                right: -availableWidth * 0.06,
                child: const _FoodBlob(diameter: 110, emoji: '🍳'),
              ),
              Positioned(
                bottom: availableHeight * 0.30,
                left: -availableWidth * 0.05,
                child: const _FoodBlob(diameter: 100, emoji: '🍅'),
              ),
              Positioned(
                bottom: availableHeight * 0.20,
                right: -availableWidth * 0.05,
                child: const _FoodBlob(diameter: 95, emoji: '🥑'),
              ),

              // ------------------------------- content -------------------------------
              SafeArea(
                child: Column(
                  children: [
                    // ---------------- headline ----------------
                    const SizedBox(height: 18),
                    FadeTransition(
                      opacity: _fadeIn,
                      child: Column(
                        children: [
                          ShaderMask(
                            shaderCallback: (bounds) => const LinearGradient(
                              colors: [_Palette.neonGreen, _Palette.softGreen],
                            ).createShader(bounds),
                            child: const Text(
                              'CALORIE\nCounter',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.w900,
                                height: 1.0,
                                color: Colors.white,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            '"Track Calorie"',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // ---------------- phone mockup ----------------
                    // Kept at its fixed design size (250x500 — every inner
                    // font/padding was tuned for this) and scaled DOWN as a
                    // whole via FittedBox, so nothing inside it can ever
                    // overflow, no matter how small the screen is.
                    Expanded(
                      child: Center(
                        child: SlideTransition(
                          position: _phoneSlide,
                          child: FadeTransition(
                            opacity: _fadeIn,
                            child: const FittedBox(
                              fit: BoxFit.scaleDown,
                              child: _PhoneMockup(width: 250, height: 500),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // ---------------- bottom banner ----------------
                    FadeTransition(
                      opacity: _fadeIn,
                      child: const _BottomBanner(),
                    ),
                    const SizedBox(height: 18),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Decorative floating food image (falls back to an emoji if no asset found)
// ---------------------------------------------------------------------------
class _FoodBlob extends StatelessWidget {
  final double diameter;
  final String emoji;
  /// Optional: pass a real photo instead of the emoji, e.g.
  /// assetPath: 'assets/images/food_bowl_1.png'
  final String? assetPath;

  const _FoodBlob({
    required this.diameter,
    required this.emoji,
    this.assetPath,
  });

  @override
  Widget build(BuildContext context) {
    // A soft glow behind it, then the image/emoji is masked with a radial
    // fade so its edges dissolve into the black background instead of
    // showing a hard circle outline (this is what made it look like an
    // "icon" instead of blended background art).
    return SizedBox(
      width: diameter,
      height: diameter,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: diameter * 0.7,
            height: diameter * 0.7,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: _Palette.softGreen.withOpacity(0.18),
                  blurRadius: 45,
                  spreadRadius: 6,
                ),
              ],
            ),
          ),
          Opacity(
            opacity: 0.5,
            child: ShaderMask(
              blendMode: BlendMode.dstIn,
              shaderCallback: (bounds) => RadialGradient(
                colors: [
                  Colors.white,
                  Colors.white.withOpacity(0.0),
                ],
                stops: const [0.45, 1.0],
              ).createShader(bounds),
              child: assetPath == null
                  ? Text(emoji, style: TextStyle(fontSize: diameter * 0.55))
                  : ClipOval(
                      child: Image.asset(
                        assetPath!,
                        width: diameter,
                        height: diameter,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Text(
                          emoji,
                          style: TextStyle(fontSize: diameter * 0.55),
                        ),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// PHONE MOCKUP — replicates the reference app's home screen
// ---------------------------------------------------------------------------
class _PhoneMockup extends StatelessWidget {
  final double width;
  final double height;

  const _PhoneMockup({required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    final phoneWidth = width;
    final phoneHeight = height;

    return Container(
      width: phoneWidth,
      height: phoneHeight,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(38),
        border: Border.all(color: const Color(0xFF2B2B2B), width: 6),
        boxShadow: [
          BoxShadow(
            color: _Palette.neonGreen.withOpacity(0.18),
            blurRadius: 60,
            spreadRadius: 6,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Stack(
          children: [
            Container(color: Colors.white),
            Column(
              children: [
                // notch / status bar
                Container(
                  color: Colors.white,
                  padding:
                      const EdgeInsets.only(top: 8, left: 14, right: 14, bottom: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('12:01',
                          style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600)),
                      Icon(Icons.battery_full, size: 10),
                    ],
                  ),
                ),
                // app bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Expanded(
                        child: Text(
                          'Calorie Counter - Track Calorie',
                          style: TextStyle(
                            fontSize: 8.5,
                            fontWeight: FontWeight.w700,
                            color: _Palette.textDark,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Icon(Icons.settings, size: 12, color: _Palette.textDark),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                // date strip
                const _DateStrip(),
                const SizedBox(height: 8),
                // calories left card
                const _CaloriesCard(),
                const SizedBox(height: 8),
                // meal record section
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Meal Record',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            color: _Palette.textDark,
                          ),
                        ),
                        SizedBox(height: 6),
                        _MealTile(
                          label: 'Breakfast',
                          kcalText: '464/799 kcal',
                          color: _Palette.peach,
                        ),
                        SizedBox(height: 6),
                        _MealTile(
                          label: 'Lunch',
                          kcalText: '279/1119 kcal',
                          color: _Palette.mintBg,
                        ),
                      ],
                    ),
                  ),
                ),
                // bottom nav
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border(top: BorderSide(color: Color(0xFFEDEDED))),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Icon(Icons.home, size: 14, color: _Palette.grey),
                      Container(
                        width: 26,
                        height: 26,
                        decoration: const BoxDecoration(
                          color: _Palette.softGreen,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.add, size: 16, color: Colors.white),
                      ),
                      const Icon(Icons.bar_chart, size: 14, color: _Palette.grey),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DateStrip extends StatelessWidget {
  const _DateStrip();

  @override
  Widget build(BuildContext context) {
    final days = [
      ('Jan', '08', 'Wed', false),
      ('Jan', '09', 'Thu', false),
      ('Jan', '10', 'Fri', true),
      ('Jan', '11', 'Sat', false),
      ('Jan', '12', 'Sun', false),
    ];
    return SizedBox(
      height: 44,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: days.map((d) {
          final selected = d.$4;
          return Container(
            width: 34,
            padding: const EdgeInsets.symmetric(vertical: 4),
            decoration: BoxDecoration(
              color: selected ? _Palette.softGreen : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(d.$1,
                    style: TextStyle(
                        fontSize: 6.5,
                        color: selected ? Colors.white70 : _Palette.grey)),
                Text(d.$2,
                    style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        color: selected ? Colors.white : _Palette.textDark)),
                Text(d.$3,
                    style: TextStyle(
                        fontSize: 6.5,
                        color: selected ? Colors.white70 : _Palette.grey)),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _CaloriesCard extends StatelessWidget {
  const _CaloriesCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: _Palette.cardCream,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Calorie left to eat today',
                    style: TextStyle(fontSize: 7, color: _Palette.grey)),
                const SizedBox(height: 2),
                RichText(
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: '2455 ',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: _Palette.textDark,
                        ),
                      ),
                      TextSpan(
                        text: 'kcal',
                        style: TextStyle(fontSize: 8, color: _Palette.grey),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 2),
                const Text('Of 3198 kcal',
                    style: TextStyle(fontSize: 6.5, color: _Palette.grey)),
                const SizedBox(height: 8),
                Row(
                  children: const [
                    _MacroDot(color: _Palette.carbsOrange, label: 'Carbs', value: '112.7g'),
                    SizedBox(width: 10),
                    _MacroDot(color: _Palette.fatYellow, label: 'Fat', value: '26.5g'),
                    SizedBox(width: 10),
                    _MacroDot(color: _Palette.proteinBlue, label: 'Protein', value: '16.8g'),
                  ],
                ),
              ],
            ),
          ),
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFFFE7C2),
            ),
            child: const Center(child: Text('🍚', style: TextStyle(fontSize: 18))),
          ),
        ],
      ),
    );
  }
}

class _MacroDot extends StatelessWidget {
  final Color color;
  final String label;
  final String value;
  const _MacroDot({required this.color, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 5,
              height: 5,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 3),
            Text(label, style: const TextStyle(fontSize: 6, color: _Palette.grey)),
          ],
        ),
        Text(value,
            style: const TextStyle(
                fontSize: 7.5, fontWeight: FontWeight.w700, color: _Palette.textDark)),
      ],
    );
  }
}

class _MealTile extends StatelessWidget {
  final String label;
  final String kcalText;
  final Color color;
  const _MealTile({required this.label, required this.kcalText, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        fontSize: 8, fontWeight: FontWeight.w700, color: _Palette.textDark)),
                const SizedBox(height: 2),
                Text(kcalText,
                    style: const TextStyle(fontSize: 6.5, color: _Palette.grey)),
              ],
            ),
          ),
          Container(
            width: 20,
            height: 20,
            decoration: const BoxDecoration(
              color: _Palette.softGreen,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.add, size: 12, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// BOTTOM BANNER
// ---------------------------------------------------------------------------
class _BottomBanner extends StatelessWidget {
  const _BottomBanner();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Expanded(
            child: Text(
              'Track Your\nBreakfast, Stay\nOn Track!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w800,
                height: 1.25,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: _Palette.peach,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 26,
                  height: 26,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(child: Text('🍳', style: TextStyle(fontSize: 14))),
                ),
                const SizedBox(width: 8),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Breakfast',
                        style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: _Palette.textDark)),
                    Text('332/539 Kcal',
                        style: TextStyle(fontSize: 8, color: _Palette.textDark)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}