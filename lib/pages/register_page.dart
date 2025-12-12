import 'package:flutter/material.dart';

import '../core/app_routes.dart';
import '../core/app_scope.dart';
import '../core/app_colors.dart';
import '../widgets/animated_blobs_background.dart';
import '../widgets/primary_gradient_button.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _pass1 = TextEditingController();
  final _pass2 = TextEditingController();

  bool _loading = false;
  bool _obscure1 = true;
  bool _obscure2 = true;
  String? _error;

  @override
  void dispose() {
    _email.dispose();
    _pass1.dispose();
    _pass2.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    setState(() => _error = null);

    if (!(_formKey.currentState?.validate() ?? false)) return;

    final services = AppScope.of(context);
    setState(() => _loading = true);
    try {
      final token = await services.auth.register(
        services.api,
        email: _email.text.trim(),
        password: _pass1.text,
      );

      if (!mounted) return;
      if (token.isNotEmpty) {
        Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.home, (r) => false);
      } else {
        // Register ok but token not returned
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Ro‘yxatdan o‘tildi. Endi login qiling.")),
        );
        Navigator.of(context).pop();
      }
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
                    Row(
                      children: [
                        IconButton(
                          onPressed: _loading ? null : () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
                        ),
                        const Spacer(),
                      ],
                    ),
                    const SizedBox(height: 6),
                    const _Header(title: 'Ro‘yxatdan o‘tish', subtitle: 'Bir daqiqada akkaunt yarating'),
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
                                controller: _pass1,
                                obscureText: _obscure1,
                                textInputAction: TextInputAction.next,
                                style: const TextStyle(fontWeight: FontWeight.w600),
                                decoration: InputDecoration(
                                  labelText: 'Parol',
                                  prefixIcon: const Icon(Icons.lock_rounded),
                                  suffixIcon: IconButton(
                                    onPressed: () => setState(() => _obscure1 = !_obscure1),
                                    icon: Icon(_obscure1 ? Icons.visibility_rounded : Icons.visibility_off_rounded),
                                  ),
                                ),
                                validator: (v) {
                                  if ((v ?? '').isEmpty) return 'Parol kiriting';
                                  if ((v ?? '').length < 4) return 'Parol juda qisqa';
                                  return null;
                                },
                              ),
                              const SizedBox(height: 12),
                              TextFormField(
                                controller: _pass2,
                                obscureText: _obscure2,
                                textInputAction: TextInputAction.done,
                                onFieldSubmitted: (_) => _submit(),
                                style: const TextStyle(fontWeight: FontWeight.w600),
                                decoration: InputDecoration(
                                  labelText: 'Parolni tasdiqlang',
                                  prefixIcon: const Icon(Icons.verified_user_rounded),
                                  suffixIcon: IconButton(
                                    onPressed: () => setState(() => _obscure2 = !_obscure2),
                                    icon: Icon(_obscure2 ? Icons.visibility_rounded : Icons.visibility_off_rounded),
                                  ),
                                ),
                                validator: (v) {
                                  if ((v ?? '').isEmpty) return 'Parolni qayta kiriting';
                                  if (v != _pass1.text) return 'Parollar mos emas';
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
                                text: _loading ? 'Yaratilmoqda...' : 'Akkaunt yaratish',
                                icon: Icons.person_add_alt_1_rounded,
                                isLoading: _loading,
                                onPressed: _loading ? null : _submit,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Akkauntingiz bormi? Login sahifasiga qayting.',
                                style: TextStyle(color: Colors.white.withOpacity(0.84), fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      ),
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
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withOpacity(0.16),
            border: Border.all(color: Colors.white.withOpacity(0.22)),
          ),
          child: const Icon(Icons.person_add_alt_1_rounded, color: Colors.white, size: 32),
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
