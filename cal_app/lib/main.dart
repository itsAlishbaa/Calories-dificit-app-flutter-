import 'dart:ui';
import 'package:flutter/material.dart';
import 'welcome_screen.dart';

void main() {
  runApp(const MyApp());
}

// ---------------------------------------------------------------------------
// GLOBAL APP PALETTE
// ---------------------------------------------------------------------------
class AppPalette {
  static const primaryPurple = Color(0xFF856699); // Requested Hex Color
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
  static const backgroundDark = Color(0xFF856699); // Changed to #856699
  static const pureWhite = Colors.white;
}

// ---------------------------------------------------------------------------
// APP THEME DEFINITION
// ---------------------------------------------------------------------------
class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppPalette.backgroundDark,
      primaryColor: AppPalette.primaryPurple,
      colorScheme: const ColorScheme.dark(
        primary: AppPalette.primaryPurple,
        secondary: AppPalette.neonGreen,
        surface: AppPalette.pureWhite,
        background: AppPalette.backgroundDark,
      ),
      iconTheme: const IconThemeData(color: AppPalette.grey),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.5,
          color: Colors.white,
        ),
        bodyMedium: TextStyle(
          color: Colors.white70,
          fontSize: 13,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// MAIN APP ENTRY
// ---------------------------------------------------------------------------
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calorie Counter',
      theme: AppTheme.darkTheme,
      home: const SplashScreen(),
    );
  }
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

    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const WelcomeScreen()),
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
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final availableHeight = constraints.maxHeight;

          return Stack(
            fit: StackFit.expand,
            children: [
              Positioned(
                top: availableHeight * 0.05,
                left: -40,
                child: const _FoodBlob(diameter: 150, emoji: '🥗'),
              ),
              Positioned(
                top: availableHeight * 0.10,
                right: -40,
                child: const _FoodBlob(diameter: 140, emoji: '🍳'),
              ),
              Positioned(
                top: availableHeight * 0.28,
                left: -45,
                child: const _FoodBlob(diameter: 130, emoji: '🍇'),
              ),
              Positioned(
                top: availableHeight * 0.32,
                right: -45,
                child: const _FoodBlob(diameter: 145, emoji: '🍊'),
              ),
              Positioned(
                bottom: availableHeight * 0.34,
                left: -40,
                child: const _FoodBlob(diameter: 135, emoji: '🍅'),
              ),
              Positioned(
                bottom: availableHeight * 0.30,
                right: -40,
                child: const _FoodBlob(diameter: 125, emoji: '🥑'),
              ),
              Positioned(
                bottom: availableHeight * 0.06,
                left: -35,
                child: const _FoodBlob(diameter: 130, emoji: '🍓'),
              ),
              Positioned(
                bottom: availableHeight * 0.10,
                right: -35,
                child: const _FoodBlob(diameter: 125, emoji: '🥕'),
              ),
              SafeArea(
                child: Column(
                  children: [
                    const SizedBox(height: 18),
                    FadeTransition(
                      opacity: _fadeIn,
                      child: Column(
                        children: [
                          ShaderMask(
                            shaderCallback: (bounds) => const LinearGradient(
                              colors: [AppPalette.pureWhite, AppPalette.peach],
                            ).createShader(bounds),
                            child: Text(
                              'CALORIE\nCounter',
                              textAlign: TextAlign.center,
                              style: theme.textTheme.headlineLarge,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '"Track Calorie"',
                            style: theme.textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        child: Center(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 360),
                            child: SlideTransition(
                              position: _phoneSlide,
                              child: FadeTransition(
                                opacity: _fadeIn,
                                child: const FittedBox(
                                  fit: BoxFit.contain,
                                  child: _PhoneMockup(width: 320, height: 640),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
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

class _FoodBlob extends StatelessWidget {
  final double diameter;
  final String emoji;
  final String? assetPath;

  const _FoodBlob({
    required this.diameter,
    required this.emoji,
    this.assetPath,
  });

  @override
  Widget build(BuildContext context) {
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
                  color: Colors.white.withOpacity(0.15),
                  blurRadius: 45,
                  spreadRadius: 6,
                ),
              ],
            ),
          ),
          Opacity(
            opacity: 0.6,
            child: ShaderMask(
              blendMode: BlendMode.dstIn,
              shaderCallback: (bounds) => RadialGradient(
                colors: [Colors.white, Colors.white.withOpacity(0.0)],
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

class _PhoneMockup extends StatelessWidget {
  final double width;
  final double height;

  const _PhoneMockup({required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppPalette.pureWhite, // Outer mockup container set to white
        borderRadius: BorderRadius.circular(38),
        border: Border.all(color: const Color(0xFFE0E0E0), width: 6),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 40,
            spreadRadius: 4,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Stack(
          children: [
            Container(color: AppPalette.pureWhite),
            Column(
              children: [
                Container(
                  color: AppPalette.pureWhite,
                  padding: const EdgeInsets.only(
                    top: 8,
                    left: 14,
                    right: 14,
                    bottom: 4,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        '12:01',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                          color: AppPalette.textDark,
                        ),
                      ),
                      Icon(
                        Icons.battery_full,
                        size: 10,
                        color: AppPalette.textDark,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Expanded(
                        child: Text(
                          'Calorie Counter - Track Calorie',
                          style: TextStyle(
                            fontSize: 8.5,
                            fontWeight: FontWeight.w700,
                            color: AppPalette.textDark,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Icon(
                        Icons.settings,
                        size: 12,
                        color: AppPalette.textDark,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                const _DateStrip(),
                const SizedBox(height: 8),
                const _CaloriesCard(),
                const SizedBox(height: 8),
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
                            color: AppPalette.textDark,
                          ),
                        ),
                        SizedBox(height: 6),
                        _MealTile(
                          label: 'Breakfast',
                          kcalText: '464/799 kcal',
                          color: AppPalette.peach,
                        ),
                        SizedBox(height: 6),
                        _MealTile(
                          label: 'Lunch',
                          kcalText: '279/1119 kcal',
                          color: AppPalette.mintBg,
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  decoration: const BoxDecoration(
                    color: AppPalette.pureWhite,
                    border: Border(top: BorderSide(color: Color(0xFFEDEDED))),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Icon(Icons.home, size: 14, color: AppPalette.grey),
                      Container(
                        width: 26,
                        height: 26,
                        decoration: const BoxDecoration(
                          color: AppPalette.primaryPurple,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.add,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                      const Icon(
                        Icons.bar_chart,
                        size: 14,
                        color: AppPalette.grey,
                      ),
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
              color: selected ? AppPalette.primaryPurple : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  d.$1,
                  style: TextStyle(
                    fontSize: 6.5,
                    color: selected ? Colors.white70 : AppPalette.grey,
                  ),
                ),
                Text(
                  d.$2,
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: selected ? Colors.white : AppPalette.textDark,
                  ),
                ),
                Text(
                  d.$3,
                  style: TextStyle(
                    fontSize: 6.5,
                    color: selected ? Colors.white70 : AppPalette.grey,
                  ),
                ),
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
        color: AppPalette.cardCream,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Calorie left to eat today',
                  style: TextStyle(fontSize: 7, color: AppPalette.grey),
                ),
                const SizedBox(height: 2),
                RichText(
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: '2455 ',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: AppPalette.textDark,
                        ),
                      ),
                      TextSpan(
                        text: 'kcal',
                        style: TextStyle(fontSize: 8, color: AppPalette.grey),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Of 3198 kcal',
                  style: TextStyle(fontSize: 6.5, color: AppPalette.grey),
                ),
                const SizedBox(height: 8),
                Row(
                  children: const [
                    _MacroDot(
                      color: AppPalette.carbsOrange,
                      label: 'Carbs',
                      value: '112.7g',
                    ),
                    SizedBox(width: 10),
                    _MacroDot(
                      color: AppPalette.fatYellow,
                      label: 'Fat',
                      value: '26.5g',
                    ),
                    SizedBox(width: 10),
                    _MacroDot(
                      color: AppPalette.proteinBlue,
                      label: 'Protein',
                      value: '16.8g',
                    ),
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
            child: const Center(
              child: Text('🍚', style: TextStyle(fontSize: 18)),
            ),
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
  const _MacroDot({
    required this.color,
    required this.label,
    required this.value,
  });

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
            Text(
              label,
              style: const TextStyle(fontSize: 6, color: AppPalette.grey),
            ),
          ],
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 7.5,
            fontWeight: FontWeight.w700,
            color: AppPalette.textDark,
          ),
        ),
      ],
    );
  }
}

class _MealTile extends StatelessWidget {
  final String label;
  final String kcalText;
  final Color color;
  const _MealTile({
    required this.label,
    required this.kcalText,
    required this.color,
  });

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
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.w700,
                    color: AppPalette.textDark,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  kcalText,
                  style: const TextStyle(fontSize: 6.5, color: AppPalette.grey),
                ),
              ],
            ),
          ),
          Container(
            width: 20,
            height: 20,
            decoration: const BoxDecoration(
              color: AppPalette.primaryPurple,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.add, size: 12, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

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
              color: AppPalette.peach,
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
                  child: const Center(
                    child: Text('🍳', style: TextStyle(fontSize: 14)),
                  ),
                ),
                const SizedBox(width: 8),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Breakfast',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: AppPalette.textDark,
                      ),
                    ),
                    Text(
                      '332/539 Kcal',
                      style: TextStyle(fontSize: 8, color: AppPalette.textDark),
                    ),
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
