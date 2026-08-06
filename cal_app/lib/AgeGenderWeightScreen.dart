import 'dart:ui';
import 'package:flutter/material.dart';

import 'bmi_graph_screen.dart';

class AgeGenderWeightScreen extends StatefulWidget {
  const AgeGenderWeightScreen({Key? key}) : super(key: key);

  @override
  State<AgeGenderWeightScreen> createState() => _AgeGenderWeightScreenState();
}

class _AgeGenderWeightScreenState extends State<AgeGenderWeightScreen> {
  final PageController _pageController = PageController();
  int _internalStep = 0; // 0: Gender, 1: Age, 2: Weight, 3: Height

  // Primary Theme Colors
  static const Color primaryColor = Color(0xFF9653AC);
  static const Color primaryGradientStart = Color(0xFFB86AD4);
  static const Color primaryGradientEnd = Color(0xFF9653AC);

  // Form Values
  String? _selectedGender;
  DateTime? _selectedDate;
  int? _manualAge;

  // Weight States
  double _weightKg = 65.0;
  bool _isKg = true; // true = kg, false = lbs

  // Height States
  double _heightCm = 170.0;
  bool _isCm = true; // true = cm, false = ft/in

  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _weightController = TextEditingController(
    text: "65.0",
  );
  final TextEditingController _heightController = TextEditingController(
    text: "170.0",
  );

  @override
  void dispose() {
    _pageController.dispose();
    _ageController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  void _nextInternalPage() {
    if (_internalStep == 0 && _selectedGender == null) {
      _showSnackBar("Please select your gender!");
      return;
    }
    if (_internalStep == 1 &&
        _selectedDate == null &&
        _ageController.text.isEmpty) {
      _showSnackBar("Please select DOB or enter your age!");
      return;
    }
    if (_internalStep == 2 && _weightKg <= 0) {
      _showSnackBar("Please enter a valid weight!");
      return;
    }
    if (_internalStep == 3 && _heightCm <= 0) {
      _showSnackBar("Please enter a valid height!");
      return;
    }

    if (_internalStep < 3) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Data pass to BmiGraphScreen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BmiGraphScreen(
            weightKg: _weightKg,
            heightCm: _heightCm,
            age: _manualAge ?? 0,
            gender: _selectedGender ?? 'Other',
          ),
        ),
      );
    }
  }

  void _previousInternalPage() {
    if (_internalStep > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pop(context);
    }
  }

  void _showSnackBar(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        backgroundColor: Colors.redAccent,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1940),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: primaryColor,
              onPrimary: Colors.white,
              surface: Color(0xFF1F1225),
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        int calculatedAge = DateTime.now().year - picked.year;
        if (DateTime.now().isBefore(
          DateTime(DateTime.now().year, picked.month, picked.day),
        )) {
          calculatedAge--;
        }
        _manualAge = calculatedAge;
        _ageController.text = calculatedAge.toString();
      });
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
            colors: [Color(0xFF180E1C), Color(0xFF281332), Color(0xFF381845)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 20),
              _buildTopTracker(),
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(28),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                        child: Container(
                          width: size.width * 0.9,
                          height: 520,
                          padding: const EdgeInsets.all(28.0),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.07),
                            borderRadius: BorderRadius.circular(28.0),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.18),
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.35),
                                blurRadius: 30,
                                offset: const Offset(0, 15),
                              ),
                            ],
                          ),
                          child: PageView(
                            controller: _pageController,
                            physics: const NeverScrollableScrollPhysics(),
                            onPageChanged: (index) {
                              setState(() {
                                _internalStep = index;
                              });
                            },
                            children: [
                              _buildGenderSection(),
                              _buildAgeSection(),
                              _buildWeightSection(),
                              _buildHeightSection(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Text(
                "Step ${_internalStep + 1} of 4",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.white.withOpacity(0.5),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  // --- TOP STEP TRACKER ---
  Widget _buildTopTracker() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (index) {
        int stepNumber = index + 1;
        bool isActive = _internalStep == index;
        bool isPassed = _internalStep > index;

        return Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: isActive
                    ? const LinearGradient(
                        colors: [primaryGradientStart, primaryGradientEnd],
                      )
                    : null,
                color: isActive
                    ? null
                    : (isPassed
                          ? primaryColor.withOpacity(0.25)
                          : Colors.white.withOpacity(0.08)),
                border: Border.all(
                  color: isActive
                      ? Colors.transparent
                      : (isPassed
                            ? primaryColor
                            : Colors.white.withOpacity(0.2)),
                  width: 1.5,
                ),
              ),
              child: Center(
                child: isPassed
                    ? const Icon(Icons.check, size: 18, color: primaryColor)
                    : Text(
                        "$stepNumber",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
            if (index < 3)
              Container(
                width: 24,
                height: 2,
                margin: const EdgeInsets.symmetric(horizontal: 6),
                color: isPassed ? primaryColor : Colors.white.withOpacity(0.15),
              ),
          ],
        );
      }),
    );
  }

  // --- SECTION 1: GENDER SELECTION ---
  Widget _buildGenderSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeaderIcon(Icons.wc_rounded),
        const SizedBox(height: 16),
        const Text(
          "STEP 2.1",
          style: TextStyle(
            fontSize: 12,
            color: primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Text(
          "Select Your Gender",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(child: _genderCard("Male", Icons.male_rounded)),
            const SizedBox(width: 12),
            Expanded(child: _genderCard("Female", Icons.female_rounded)),
            const SizedBox(width: 12),
            Expanded(child: _genderCard("Other", Icons.transgender_rounded)),
          ],
        ),
        const Spacer(),
        _buildContinueButton("Continue", _nextInternalPage),
      ],
    );
  }

  Widget _genderCard(String label, IconData icon) {
    bool isSelected = _selectedGender == label;
    return GestureDetector(
      onTap: () => setState(() => _selectedGender = label),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: isSelected
              ? primaryColor.withOpacity(0.25)
              : Colors.black.withOpacity(0.2),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? primaryColor : Colors.white.withOpacity(0.12),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? primaryColor : Colors.white60,
              size: 28,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.white60,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- SECTION 2: AGE SELECTION ---
  Widget _buildAgeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeaderIcon(Icons.calendar_month_rounded),
        const SizedBox(height: 16),
        const Text(
          "STEP 2.2",
          style: TextStyle(
            fontSize: 12,
            color: primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Text(
          "How old are you?",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 20),
        InkWell(
          onTap: _pickDate,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: primaryColor.withOpacity(0.5)),
            ),
            child: Row(
              children: [
                const Icon(Icons.edit_calendar_rounded, color: primaryColor),
                const SizedBox(width: 12),
                Text(
                  _selectedDate == null
                      ? "Select Date of Birth (Calendar)"
                      : "DOB: ${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}",
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: Text(
            "— OR ENTER AGE MANUALLY —",
            style: TextStyle(
              color: Colors.white.withOpacity(0.4),
              fontSize: 10,
              letterSpacing: 1,
            ),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _ageController,
          keyboardType: TextInputType.number,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: "Enter Age (e.g. 25)",
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
            filled: true,
            fillColor: Colors.black.withOpacity(0.2),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.white.withOpacity(0.12)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: primaryColor),
            ),
          ),
          onChanged: (val) {
            _manualAge = int.tryParse(val);
          },
        ),
        const Spacer(),
        Row(
          children: [
            _buildBackButton(_previousInternalPage),
            const SizedBox(width: 12),
            Expanded(
              child: _buildContinueButton("Continue", _nextInternalPage),
            ),
          ],
        ),
      ],
    );
  }

  // --- SECTION 3: WEIGHT SELECTION ---
  Widget _buildWeightSection() {
    double displayedWeight = _isKg ? _weightKg : _weightKg * 2.20462;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildHeaderIcon(Icons.monitor_weight_outlined),
            _buildUnitToggle(
              isFirstUnit: _isKg,
              unit1: "kg",
              unit2: "lbs",
              onToggle: (isKgSelected) {
                setState(() {
                  _isKg = isKgSelected;
                  double val = _isKg ? _weightKg : _weightKg * 2.20462;
                  _weightController.text = val.toStringAsFixed(1);
                });
              },
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Text(
          "STEP 2.3",
          style: TextStyle(
            fontSize: 12,
            color: primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Text(
          "What is your weight?",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.25),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.12)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  if (_weightKg > 10) {
                    setState(() {
                      _weightKg -= _isKg ? 0.5 : (0.5 / 2.20462);
                      double val = _isKg ? _weightKg : _weightKg * 2.20462;
                      _weightController.text = val.toStringAsFixed(1);
                    });
                  }
                },
                icon: const Icon(
                  Icons.remove_circle_outline,
                  color: primaryColor,
                  size: 32,
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    displayedWeight.toStringAsFixed(1),
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    _isKg ? "kg" : "lbs",
                    style: const TextStyle(fontSize: 16, color: primaryColor),
                  ),
                ],
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    _weightKg += _isKg ? 0.5 : (0.5 / 2.20462);
                    double val = _isKg ? _weightKg : _weightKg * 2.20462;
                    _weightController.text = val.toStringAsFixed(1);
                  });
                },
                icon: const Icon(
                  Icons.add_circle_outline,
                  color: primaryColor,
                  size: 32,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        TextField(
          controller: _weightController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          style: const TextStyle(color: Colors.white, fontSize: 14),
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.edit, color: primaryColor, size: 18),
            hintText: "Or type weight directly...",
            hintStyle: TextStyle(
              color: Colors.white.withOpacity(0.3),
              fontSize: 13,
            ),
            filled: true,
            fillColor: Colors.black.withOpacity(0.2),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.white.withOpacity(0.12)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: primaryColor),
            ),
          ),
          onChanged: (val) {
            double? parsed = double.tryParse(val);
            if (parsed != null) {
              setState(() {
                _weightKg = _isKg ? parsed : parsed / 2.20462;
              });
            }
          },
        ),
        const Spacer(),
        Row(
          children: [
            _buildBackButton(_previousInternalPage),
            const SizedBox(width: 12),
            Expanded(
              child: _buildContinueButton("Continue", _nextInternalPage),
            ),
          ],
        ),
      ],
    );
  }

  // --- SECTION 4: HEIGHT SELECTION ---
  Widget _buildHeightSection() {
    double displayedHeight = _isCm ? _heightCm : _heightCm / 30.48;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildHeaderIcon(Icons.height_rounded),
            _buildUnitToggle(
              isFirstUnit: _isCm,
              unit1: "cm",
              unit2: "ft",
              onToggle: (isCmSelected) {
                setState(() {
                  _isCm = isCmSelected;
                  double val = _isCm ? _heightCm : _heightCm / 30.48;
                  _heightController.text = val.toStringAsFixed(1);
                });
              },
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Text(
          "STEP 2.4",
          style: TextStyle(
            fontSize: 12,
            color: primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Text(
          "What is your height?",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.25),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.12)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  if (_heightCm > 50) {
                    setState(() {
                      _heightCm -= _isCm ? 1.0 : 3.048;
                      double val = _isCm ? _heightCm : _heightCm / 30.48;
                      _heightController.text = val.toStringAsFixed(1);
                    });
                  }
                },
                icon: const Icon(
                  Icons.remove_circle_outline,
                  color: primaryColor,
                  size: 32,
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    displayedHeight.toStringAsFixed(1),
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    _isCm ? "cm" : "ft",
                    style: const TextStyle(fontSize: 16, color: primaryColor),
                  ),
                ],
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    _heightCm += _isCm ? 1.0 : 3.048;
                    double val = _isCm ? _heightCm : _heightCm / 30.48;
                    _heightController.text = val.toStringAsFixed(1);
                  });
                },
                icon: const Icon(
                  Icons.add_circle_outline,
                  color: primaryColor,
                  size: 32,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        TextField(
          controller: _heightController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          style: const TextStyle(color: Colors.white, fontSize: 14),
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.edit, color: primaryColor, size: 18),
            hintText: "Or type height directly...",
            hintStyle: TextStyle(
              color: Colors.white.withOpacity(0.3),
              fontSize: 13,
            ),
            filled: true,
            fillColor: Colors.black.withOpacity(0.2),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.white.withOpacity(0.12)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: primaryColor),
            ),
          ),
          onChanged: (val) {
            double? parsed = double.tryParse(val);
            if (parsed != null) {
              setState(() {
                _heightCm = _isCm ? parsed : parsed * 30.48;
              });
            }
          },
        ),
        const Spacer(),
        Row(
          children: [
            _buildBackButton(_previousInternalPage),
            const SizedBox(width: 12),
            Expanded(
              child: _buildContinueButton("Calculate BMI", _nextInternalPage),
            ),
          ],
        ),
      ],
    );
  }

  // --- HELPER TOGGLE SWITCH ---
  Widget _buildUnitToggle({
    required bool isFirstUnit,
    required String unit1,
    required String unit2,
    required Function(bool) onToggle,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.15)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () => onToggle(true),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: isFirstUnit ? primaryColor : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                unit1,
                style: TextStyle(
                  color: isFirstUnit ? Colors.white : Colors.white70,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () => onToggle(false),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: !isFirstUnit ? primaryColor : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                unit2,
                style: TextStyle(
                  color: !isFirstUnit ? Colors.white : Colors.white70,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- COMMON UI HELPER WIDGETS ---
  Widget _buildHeaderIcon(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: primaryColor.withOpacity(0.15),
        border: Border.all(color: primaryColor.withOpacity(0.4), width: 1.5),
      ),
      child: Icon(icon, size: 28, color: primaryColor),
    );
  }

  Widget _buildContinueButton(String label, VoidCallback onTap) {
    return SizedBox(
      height: 50,
      width: double.infinity,
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [primaryGradientStart, primaryGradientEnd],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: primaryColor.withOpacity(0.35),
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
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          onPressed: onTap,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 6),
              const Icon(
                Icons.arrow_forward_rounded,
                color: Colors.white,
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackButton(VoidCallback onTap) {
    return Container(
      height: 50,
      width: 50,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.15)),
      ),
      child: IconButton(
        icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
        onPressed: onTap,
      ),
    );
  }
}
