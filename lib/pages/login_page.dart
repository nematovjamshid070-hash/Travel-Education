import 'package:flutter/material.dart';

import '../core/app_routes.dart';
import '../core/app_scope.dart';
import '../core/app_colors.dart';
import '../widgets/animated_blobs_background.dart';
import '../widgets/primary_gradient_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();

  bool _loading = false;
  bool _obscure = true;
  String? _error;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    setState(() => _error = null);

    if (!(_formKey.currentState?.validate() ?? false)) return;

    final services = AppScope.of(context);
    setState(() => _loading = true);
    try {
      await services.auth.login(
        services.api,
        email: _email.text.trim(),
        password: _password.text,
      );
      if (!mounted) return;
      Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.home, (r) => false);
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final maxCardW = w < 520 ? w : 520.0;

    return Scaffold(
      body: AnimatedBlobsBackground(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(18),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxCardW),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 18),
                    _Header(
                      title: 'Xush kelibsiz',
                      subtitle: 'Davom etish uchun tizimga kiring',
                    ),
                    const SizedBox(height: 18),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                controller: _email,
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
                                style: const TextStyle(fontWeight: FontWeight.w600),
                                decoration: const InputDecoration(
                                  labelText: 'Email',
                                  prefixIcon: Icon(Icons.email_rounded),
                                ),
                                validator: (v) {
                                  final t = (v ?? '').trim();
                                  if (t.isEmpty) return 'Email kiriting';
                                  if (!t.contains('@')) return 'Email formati noto‘g‘ri';
                                  return null;
                                },
                              ),
                              const SizedBox(height: 12),
                              TextFormField(
                                controller: _password,
                                obscureText: _obscure,
                                textInputAction: TextInputAction.done,
                                onFieldSubmitted: (_) => _submit(),
                                style: const TextStyle(fontWeight: FontWeight.w600),
                                decoration: InputDecoration(
                                  labelText: 'Parol',
                                  prefixIcon: const Icon(Icons.lock_rounded),
                                  suffixIcon: IconButton(
                                    onPressed: () => setState(() => _obscure = !_obscure),
                                    icon: Icon(_obscure ? Icons.visibility_rounded : Icons.visibility_off_rounded),
                                  ),
                                ),
                                validator: (v) {
                                  if ((v ?? '').isEmpty) return 'Parol kiriting';
                                  if ((v ?? '').length < 4) return 'Parol juda qisqa';
                                  return null;
                                },
                              ),
                              const SizedBox(height: 12),
                              AnimatedSwitcher(
                                duration: const Duration(milliseconds: 200),
                                child: _error == null
                                    ? const SizedBox.shrink()
                                    : Container(
                                        key: const ValueKey('err'),
                                        width: double.infinity,
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: AppColors.danger.withOpacity(0.10),
                                          borderRadius: BorderRadius.circular(14),
                                          border: Border.all(color: AppColors.danger.withOpacity(0.35)),
                                        ),
                                        child: Text(
                                          _error!,
                                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                                        ),
                                      ),
                              ),
                              const SizedBox(height: 14),
                              PrimaryGradientButton(
                                text: _loading ? 'Kirilmoqda...' : 'Kirish',
                                icon: Icons.login_rounded,
                                isLoading: _loading,
                                onPressed: _loading ? null : _submit,
                              ),
                              const SizedBox(height: 12),
                              TextButton(
                                onPressed: _loading
                                    ? null
                                    : () => Navigator.of(context).pushNamed(AppRoutes.register),
                                child: Text(
                                  'Ro‘yxatdan o‘tish',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.95),
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _HintBox(
                      text:
                          'Eslatma: API ishlashi uchun backend serveringiz RUN holatda bo‘lishi kerak. Android Emulator uchun baseUrl odatda 10.0.2.2:3000.',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withOpacity(0.16),
            border: Border.all(color: Colors.white.withOpacity(0.22)),
          ),
          child: const Icon(Icons.explore_rounded, color: Colors.white, size: 32),
        ),
        const SizedBox(height: 12),
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white.withOpacity(0.84), fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

class _HintBox extends StatelessWidget {
  const _HintBox({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.18)),
      ),
      child: Text(
        text,
        style: TextStyle(color: Colors.white.withOpacity(0.86), fontWeight: FontWeight.w600, fontSize: 12.5),
      ),
    );
  }
}
