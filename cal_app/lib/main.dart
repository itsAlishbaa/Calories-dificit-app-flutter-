import 'dart:ui';
import 'package:flutter/material.dart';
import 'welcome_screen.dart';

void main() {
  runApp(const MyApp());
}

// ---------------------------------------------------------------------------
// GLOBAL APP PALETTE (#637E9C Steel Blue & White Theme)
// ---------------------------------------------------------------------------
class AppPalette {
  // Slate / Steel Blue Gradient Backgrounds
  static const bgDark = Color(0xFF1E2836);
  static const bgPurpleMid = Color(0xFF2D3B4E);
  static const bgPurpleAccent = Color(0xFF42546B);

  // Core Theme Accents (#637e9c & White variations)
  static const primaryPurple = Color(0xFF637E9C); // Primary Steel Blue
  static const accentNeonViolet = Color(
    0xFFC3D6EC,
  ); // Light Ice Blue/White Highlight
  static const accentPink = Color(0xFF8FA8C8); // Soft Steel Accent

  // Glassmorphic Colors
  static Color glassBg = Colors.white.withOpacity(0.10);
  static Color glassBorder = Colors.white.withOpacity(0.25);
  static Color glassShadow = Colors.black.withOpacity(0.25);

  // Neutrals & Text
  static const pureWhite = Colors.white;
  static const textDark = Color(0xFFF8FAFC);
  static const textMuted = Color(0xFF94A3B8);
  static Color borderLight = Colors.white.withOpacity(0.15);

  // Macro Indicators
  static const carbsOrange = Color(0xFFFB923C);
  static const fatYellow = Color(0xFFFACC15);
  static const proteinBlue = Color(0xFF637E9C);
}

// ---------------------------------------------------------------------------
// APP THEME DEFINITION
// ---------------------------------------------------------------------------
class AppTheme {
  static ThemeData get mainTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppPalette.bgDark,
      primaryColor: AppPalette.primaryPurple,
      colorScheme: const ColorScheme.dark(
        primary: AppPalette.primaryPurple,
        secondary: AppPalette.accentNeonViolet,
        surface: AppPalette.bgPurpleMid,
        background: AppPalette.bgDark,
      ),
      iconTheme: const IconThemeData(color: AppPalette.textMuted),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.5,
          color: AppPalette.pureWhite,
        ),
        bodyMedium: TextStyle(
          color: Color(0xCCFFFFFF),
          fontSize: 13,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }
}

// Helper Widget for Glassmorphic Container
class GlassContainer extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double blur;

  const GlassContainer({
    super.key,
    required this.child,
    this.borderRadius = 16,
    this.padding,
    this.margin,
    this.blur = 15,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              color: AppPalette.glassBg,
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(color: AppPalette.glassBorder, width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: AppPalette.glassShadow,
                  blurRadius: 20,
                  spreadRadius: -5,
                ),
              ],
            ),
            child: child,
          ),
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
      theme: AppTheme.mainTheme,
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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppPalette.bgDark,
              AppPalette.bgPurpleMid,
              AppPalette.bgPurpleAccent,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: LayoutBuilder(
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
                            Text(
                              'CALORIE\nCounter',
                              textAlign: TextAlign.center,
                              style: theme.textTheme.headlineLarge?.copyWith(
                                shadows: [
                                  Shadow(
                                    color: AppPalette.primaryPurple.withOpacity(
                                      0.6,
                                    ),
                                    blurRadius: 16,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 6),
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
                                    child: _PhoneMockup(
                                      width: 320,
                                      height: 640,
                                    ),
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
      ),
    );
  }
}

class _FoodBlob extends StatelessWidget {
  final double diameter;
  final String emoji;

  const _FoodBlob({required this.diameter, required this.emoji});

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
                  color: AppPalette.primaryPurple.withOpacity(0.35),
                  blurRadius: 30,
                  spreadRadius: 4,
                ),
              ],
            ),
          ),
          Opacity(
            opacity: 0.55,
            child: Text(emoji, style: TextStyle(fontSize: diameter * 0.55)),
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
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFF18212D),
        borderRadius: BorderRadius.circular(38),
        border: Border.all(color: AppPalette.glassBorder, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: AppPalette.primaryPurple.withOpacity(0.4),
            blurRadius: 35,
            spreadRadius: 2,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppPalette.bgDark, AppPalette.bgPurpleMid],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            children: [
              Container(
                color: Colors.transparent,
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
                        fontWeight: FontWeight.w700,
                        color: AppPalette.pureWhite,
                      ),
                    ),
                    Icon(
                      Icons.battery_full,
                      size: 10,
                      color: AppPalette.pureWhite,
                    ),
                  ],
                ),
              ),
              Container(
                color: Colors.transparent,
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 6,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Expanded(
                      child: Text(
                        'Calorie Counter',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: AppPalette.accentNeonViolet,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.settings_outlined,
                      size: 13,
                      color: AppPalette.accentNeonViolet,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              const _DateStrip(),
              const SizedBox(height: 8),
              const _CaloriesCard(),
              const SizedBox(height: 8),
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Meal Record',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: AppPalette.pureWhite,
                        ),
                      ),
                      SizedBox(height: 6),
                      _MealTile(
                        label: 'Breakfast',
                        kcalText: '464/799 kcal',
                        icon: '🍳',
                      ),
                      SizedBox(height: 6),
                      _MealTile(
                        label: 'Lunch',
                        kcalText: '279/1119 kcal',
                        icon: '🥗',
                      ),
                    ],
                  ),
                ),
              ),
              GlassContainer(
                borderRadius: 0,
                blur: 10,
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Icon(
                      Icons.home_rounded,
                      size: 16,
                      color: AppPalette.accentNeonViolet,
                    ),
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            AppPalette.primaryPurple,
                            AppPalette.accentNeonViolet,
                          ],
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppPalette.primaryPurple.withOpacity(0.5),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.add,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                    const Icon(
                      Icons.bar_chart_rounded,
                      size: 16,
                      color: AppPalette.textMuted,
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      height: 46,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: days.map((d) {
          final selected = d.$4;
          return GlassContainer(
            borderRadius: 10,
            blur: 5,
            child: Container(
              width: 30,
              padding: const EdgeInsets.symmetric(vertical: 4),
              decoration: BoxDecoration(
                color: selected
                    ? AppPalette.primaryPurple.withOpacity(0.5)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(10),
                border: selected
                    ? Border.all(color: AppPalette.accentNeonViolet, width: 1)
                    : null,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    d.$1,
                    style: TextStyle(
                      fontSize: 6.5,
                      color: selected ? Colors.white : AppPalette.textMuted,
                    ),
                  ),
                  Text(
                    d.$2,
                    style: TextStyle(
                      fontSize: 9.5,
                      fontWeight: FontWeight.w700,
                      color: selected ? Colors.white : AppPalette.textDark,
                    ),
                  ),
                  Text(
                    d.$3,
                    style: TextStyle(
                      fontSize: 6.5,
                      color: selected ? Colors.white : AppPalette.textMuted,
                    ),
                  ),
                ],
              ),
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
    return GlassContainer(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Calorie left to eat today',
                  style: TextStyle(fontSize: 7.5, color: AppPalette.textMuted),
                ),
                const SizedBox(height: 2),
                RichText(
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: '2455 ',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: AppPalette.accentNeonViolet,
                        ),
                      ),
                      TextSpan(
                        text: 'kcal',
                        style: TextStyle(
                          fontSize: 9,
                          color: AppPalette.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Of 3198 kcal',
                  style: TextStyle(fontSize: 7, color: AppPalette.textMuted),
                ),
                const SizedBox(height: 8),
                Row(
                  children: const [
                    _MacroDot(
                      color: AppPalette.carbsOrange,
                      label: 'Carbs',
                      value: '112.7g',
                    ),
                    SizedBox(width: 8),
                    _MacroDot(
                      color: AppPalette.fatYellow,
                      label: 'Fat',
                      value: '26.5g',
                    ),
                    SizedBox(width: 8),
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
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppPalette.primaryPurple.withOpacity(0.3),
              border: Border.all(color: AppPalette.glassBorder),
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
              style: const TextStyle(
                fontSize: 6.5,
                color: AppPalette.textMuted,
              ),
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
  final String icon;

  const _MealTile({
    required this.label,
    required this.kcalText,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      borderRadius: 12,
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 12)),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 8.5,
                    fontWeight: FontWeight.w700,
                    color: AppPalette.textDark,
                  ),
                ),
                Text(
                  kcalText,
                  style: const TextStyle(
                    fontSize: 7,
                    color: AppPalette.textMuted,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: AppPalette.primaryPurple.withOpacity(0.35),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.add,
              size: 12,
              color: AppPalette.accentNeonViolet,
            ),
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
          GlassContainer(
            borderRadius: 18,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: AppPalette.primaryPurple.withOpacity(0.35),
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
                        fontWeight: FontWeight.w800,
                        color: AppPalette.pureWhite,
                      ),
                    ),
                    Text(
                      '332/539 Kcal',
                      style: TextStyle(
                        fontSize: 8,
                        color: AppPalette.textMuted,
                      ),
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
