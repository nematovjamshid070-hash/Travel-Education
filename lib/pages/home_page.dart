import 'package:flutter/material.dart';

import '../core/app_scope.dart';
import '../core/app_routes.dart';
import '../core/app_colors.dart';
import '../widgets/gradient_app_bar.dart';
import 'tips_page.dart';
import 'profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final tabs = const [
      _TabInfo(title: 'Tips', icon: Icons.lightbulb_rounded),
      _TabInfo(title: 'Explore', icon: Icons.map_rounded),
      _TabInfo(title: 'Profil', icon: Icons.person_rounded),
    ];

    final page = switch (_index) {
      0 => const TipsPage(),
      1 => const _ExplorePlaceholder(),
      _ => const ProfilePage(),
    };

    return Scaffold(
      appBar: GradientAppBar(
        title: tabs[_index].title,
        actions: [
          if (_index == 0)
            IconButton(
              tooltip: 'Refresh',
              onPressed: () {
                // TipsPage has pull-to-refresh; this is just a friendly hint.
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Pastga tortib yangilang (pull-to-refresh)')),
                );
              },
              icon: const Icon(Icons.refresh_rounded),
            ),
          IconButton(
            tooltip: 'Logout',
            onPressed: () async {
              final services = AppScope.of(context);
              await services.auth.logout();
              if (!context.mounted) return;
              Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.login, (r) => false);
            },
            icon: const Icon(Icons.logout_rounded),
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 220),
        switchInCurve: Curves.easeOut,
        switchOutCurve: Curves.easeIn,
        child: KeyedSubtree(
          key: ValueKey(_index),
          child: page,
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 18,
              offset: const Offset(0, -8),
            )
          ],
        ),
        child: NavigationBar(
          selectedIndex: _index,
          indicatorColor: AppColors.primary.withOpacity(0.12),
          onDestinationSelected: (i) => setState(() => _index = i),
          destinations: tabs
              .map(
                (t) => NavigationDestination(
                  icon: Icon(t.icon),
                  selectedIcon: Icon(t.icon, color: AppColors.primary),
                  label: t.title,
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

class _TabInfo {
  const _TabInfo({required this.title, required this.icon});
  final String title;
  final IconData icon;
}

class _ExplorePlaceholder extends StatelessWidget {
  const _ExplorePlaceholder();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(Icons.map_rounded, color: AppColors.primary),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text('Explore', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                'Bu bo‘lim keyingi bosqichlar uchun tayyor: city cards, country guides, “saved tips”, va h.k.',
                style: TextStyle(color: AppColors.textSubtle, fontWeight: FontWeight.w600, height: 1.35),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.border),
                ),
                child: Text(
                  'Agar xohlasangiz, shu bo‘limga “country list + details” ham qo‘shib beraman (API yoki lokal JSON bilan).',
                  style: TextStyle(color: AppColors.textSubtle, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
