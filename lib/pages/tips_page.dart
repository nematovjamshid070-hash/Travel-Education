import 'dart:math';

import 'package:flutter/material.dart';

import '../core/app_scope.dart';
import '../core/app_colors.dart';
import '../models/tip.dart';

class TipsPage extends StatefulWidget {
  const TipsPage({super.key});

  @override
  State<TipsPage> createState() => _TipsPageState();
}

class _TipsPageState extends State<TipsPage> {
  bool _loading = true;
  String? _error;
  List<Tip> _tips = const [];
  String _query = '';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final services = AppScope.of(context);
      final tips = await services.tips.fetchTips();
      setState(() => _tips = tips);
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _query.trim().isEmpty
        ? _tips
        : _tips
            .where((t) => (t.title + ' ' + t.body).toLowerCase().contains(_query.toLowerCase()))
            .toList();

    return RefreshIndicator(
      onRefresh: _load,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _SearchBar(
            value: _query,
            onChanged: (v) => setState(() => _query = v),
          ),
          const SizedBox(height: 12),
          _HeroCard(
            title: 'Travel Tips',
            subtitle: 'API orqali real vaqt maslahatlar. Pastga torting — yangilanadi.',
            badge: _loading ? 'Yuklanmoqda…' : '${_tips.length} tips',
          ),
          const SizedBox(height: 12),
          if (_loading) ..._skeletons(),
          if (!_loading && _error != null) _ErrorBox(message: _error!, onRetry: _load),
          if (!_loading && _error == null && filtered.isEmpty)
            _EmptyBox(message: _tips.isEmpty ? 'Hozircha tips yo‘q.' : 'Qidiruv bo‘yicha topilmadi.'),
          if (!_loading && _error == null && filtered.isNotEmpty)
            ...List.generate(filtered.length, (i) {
              final tip = filtered[i];
              return _AnimatedTipCard(
                index: i,
                tip: tip,
              );
            }),
          const SizedBox(height: 60),
        ],
      ),
    );
  }

  List<Widget> _skeletons() {
    return List.generate(
      5,
      (i) => Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(height: 14, width: 140 + i * 8, decoration: _skel()),
            const SizedBox(height: 10),
            Container(height: 10, width: double.infinity, decoration: _skel()),
            const SizedBox(height: 6),
            Container(height: 10, width: 220 + i * 5, decoration: _skel()),
          ],
        ),
      ),
    );
  }

  BoxDecoration _skel() {
    return BoxDecoration(
      color: AppColors.primary.withOpacity(0.08),
      borderRadius: BorderRadius.circular(999),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({required this.value, required this.onChanged});

  final String value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      controller: TextEditingController(text: value)
        ..selection = TextSelection.fromPosition(TextPosition(offset: value.length)),
      decoration: InputDecoration(
        hintText: 'Qidirish (masalan: visa, hotel, safety...)',
        prefixIcon: const Icon(Icons.search_rounded),
        suffixIcon: value.isEmpty
            ? null
            : IconButton(
                onPressed: () => onChanged(''),
                icon: const Icon(Icons.close_rounded),
              ),
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({required this.title, required this.subtitle, required this.badge});

  final String title;
  final String subtitle;
  final String badge;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.25),
            blurRadius: 26,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.18),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.lightbulb_rounded, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16)),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(color: Colors.white.withOpacity(0.86), fontWeight: FontWeight.w600, fontSize: 12.5),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.18),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: Colors.white.withOpacity(0.22)),
            ),
            child: Text(
              badge,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}

class _AnimatedTipCard extends StatelessWidget {
  const _AnimatedTipCard({required this.index, required this.tip});

  final int index;
  final Tip tip;

  @override
  Widget build(BuildContext context) {
    // Staggered entrance using TweenAnimationBuilder
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 320 + min(index, 8) * 60),
      tween: Tween(begin: 0, end: 1),
      curve: Curves.easeOutCubic,
      builder: (context, t, child) {
        return Opacity(
          opacity: t,
          child: Transform.translate(
            offset: Offset(0, 14 * (1 - t)),
            child: child,
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.primary, AppColors.secondary],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.travel_explore_rounded, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tip.title,
                    style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14.5),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    tip.body,
                    style: TextStyle(color: AppColors.textSubtle, fontWeight: FontWeight.w600, height: 1.35),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorBox extends StatelessWidget {
  const _ErrorBox({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.danger.withOpacity(0.08),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.danger.withOpacity(0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Xatolik', style: TextStyle(fontWeight: FontWeight.w900)),
          const SizedBox(height: 6),
          Text(message, style: TextStyle(color: AppColors.textSubtle, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: OutlinedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Qayta urinish'),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyBox extends StatelessWidget {
  const _EmptyBox({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(Icons.inbox_rounded, color: AppColors.primary),
          ),
          const SizedBox(height: 10),
          Text(message, style: const TextStyle(fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }
}
