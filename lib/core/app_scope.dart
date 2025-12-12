import 'package:flutter/material.dart';

import '../services/api_client.dart';
import '../services/auth_service.dart';
import '../services/tips_service.dart';

class AppServices {
  final AuthService auth;
  final ApiClient api;
  final TipsService tips;

  AppServices._(this.auth, this.api, this.tips);

  factory AppServices.create() {
    final auth = AuthService();
    final api = ApiClient(authService: auth);
    final tips = TipsService(api);
    return AppServices._(auth, api, tips);
  }
}

class AppScope extends InheritedWidget {
  const AppScope({super.key, required this.services, required super.child});

  final AppServices services;

  static AppServices of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppScope>();
    assert(scope != null, 'AppScope topilmadi. AppScope ichida ishlating.');
    return scope!.services;
  }

  @override
  bool updateShouldNotify(AppScope oldWidget) => services != oldWidget.services;
}
