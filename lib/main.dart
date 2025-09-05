import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'presentation/auth/views/login_screen.dart';
import 'presentation/home/views/home_screen.dart';
import 'presentation/categories/views/add_category_screen.dart';
import 'presentation/auth/controllers/auth_controller.dart';

void main() {
  // Initialize AuthController once at app start
  Get.put(AuthController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Admin Dashboard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.blue),
          ),
        ),
      ),
      initialRoute: '/',
      getPages: [
        GetPage(
          name: '/',
          page: () => const SplashScreen(),
        ),
        GetPage(
          name: '/login',
          page: () => const LoginScreen(),
        ),
        GetPage(
          name: '/home',
          page: () => const HomeScreen(),
        ),
        GetPage(
          name: '/add-category',
          page: () => const AddCategoryScreen(),
        ),
      ],
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AuthController authController = Get.find<AuthController>();
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (authController.isLoggedIn.value) {
        Get.offAllNamed('/home');
      } else {
        Get.offAllNamed('/login');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.purpleAccent,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.admin_panel_settings,
              size: 100,
              color: Colors.pink,
            ),
            SizedBox(height: 20),
            Text(
              'Admin Dashboard',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.pink,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Loading...',
              style: TextStyle(
                fontSize: 16,
                color: Colors.pinkAccent,
              ),
            ),
            SizedBox(height: 30),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.pink),
            ),
          ],
        ),
      ),
    );
  }
}
