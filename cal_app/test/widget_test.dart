import 'package:cal_app/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Aapke package ka sahi naam yahan hona chahiye
import 'package:cal_app/main.dart';

void main() {
  testWidgets('Welcome Screen Test', (WidgetTester tester) async {
    // WelcomeScreen ko test karein
    await tester.pumpWidget(const MaterialApp(home: WelcomeScreen()));

    // Check karein ke screen par 'Welcome Back' text hai ya nahi
    expect(find.text('Welcome Back'), findsOneWidget);

    // Check karein ke Login button maujood hai
    expect(find.text('Login'), findsOneWidget);
  });
}
