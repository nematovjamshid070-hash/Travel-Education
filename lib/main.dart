import 'package:flutter/material.dart';

import 'core/app_routes.dart';
import 'core/app_scope.dart';
import 'core/app_theme.dart';
import 'pages/splash_page.dart';
import 'pages/login_page.dart';
import 'pages/register_page.dart';
import 'pages/home_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final services = AppServices.create();
  runApp(AppScope(services: services, child: const TravelEducationApp()));
}

class TravelEducationApp extends StatelessWidget {
  const TravelEducationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Travel Education',
      theme: AppTheme.light(),
      initialRoute: AppRoutes.splash,
      routes: {
        AppRoutes.splash: (_) => const SplashPage(),
        AppRoutes.login: (_) => const LoginPage(),
        AppRoutes.register: (_) => const RegisterPage(),
        AppRoutes.home: (_) => const HomePage(),
      },
    );
  }
}
