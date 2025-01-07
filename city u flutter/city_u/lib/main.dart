import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'splash_screen.dart';
import 'firebase_options.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions
          .currentPlatform, // Initialize Firebase with options
    );
  } catch (e) {
    print('Firebase initialization error: $e');
  }
  runApp(const MyApp());
}

// Dark Mode Provider for the toggle
class ThemeProvider with ChangeNotifier {
  bool isDarkMode = false;
  void toggleTheme() {
    isDarkMode = !isDarkMode;
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            theme:
                themeProvider.isDarkMode ? ThemeData.dark() : ThemeData.light(),
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
