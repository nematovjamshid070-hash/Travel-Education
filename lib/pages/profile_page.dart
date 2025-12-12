import 'package:flutter/material.dart';

import '../core/app_routes.dart';
import '../core/app_scope.dart';
import '../core/app_config.dart';
import '../core/app_colors.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? _email;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final services = AppScope.of(context);
      final email = await services.auth.getEmail();
      if (!mounted) return;
      setState(() => _email = email);
    });
  }

  Future<void> _logout() async {
    final services = AppScope.of(context);
    await services.auth.logout();
    if (!mounted) return;
    Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.login, (r) => false);
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.18),
                blurRadius: 24,
                offset: const Offset(0, 14),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.18),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.person_rounded, color: Colors.white, size: 28),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Profil',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16)),
                    const SizedBox(height: 4),
                    Text(
                      _email ?? '—',
                      style: TextStyle(color: Colors.white.withOpacity(0.86), fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: ListTile(
            leading: const Icon(Icons.link_rounded, color: AppColors.primary),
            title: const Text('API Base URL', style: TextStyle(fontWeight: FontWeight.w800)),
            subtitle: Text(AppConfig.baseUrl, style: TextStyle(color: AppColors.textSubtle, fontWeight: FontWeight.w600)),
          ),
        ),
        Card(
          child: ListTile(
            leading: const Icon(Icons.shield_rounded, color: AppColors.primary),
            title: const Text('Token saqlash', style: TextStyle(fontWeight: FontWeight.w800)),
            subtitle: Text(
              'SharedPreferences orqali token saqlanadi va keyingi ishga tushishda login so‘ramaydi.',
              style: TextStyle(color: AppColors.textSubtle, fontWeight: FontWeight.w600),
            ),
          ),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: _logout,
          icon: const Icon(Icons.logout_rounded),
          label: const Text('Chiqish', style: TextStyle(fontWeight: FontWeight.w800)),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
        ),
      ],
    );
  }
}
