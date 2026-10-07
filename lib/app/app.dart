import 'package:country_weather_explorer/features/auth/presentation/screens/countries_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/theme/app_theme.dart';
import '../features/auth/bloc/auth_bloc.dart';
import '../features/auth/bloc/auth_event.dart';
import '../features/auth/bloc/auth_state.dart';
import '../features/auth/data/auth_repository.dart';
import '../features/auth/presentation/screens/login_screen.dart';

class WeatherExplorerApp extends StatelessWidget {
  const WeatherExplorerApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (_) => AuthRepository(),
      child: BlocProvider(
        create: (context) => AuthBloc(
          authRepository: context.read<AuthRepository>(),
        )..add(const AuthStarted()),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Weather Explorer',
          theme: AppTheme.lightTheme,
          home: const _AuthGate(),
        ),
      ),
    );
  }
}

class _AuthGate extends StatelessWidget {
  const _AuthGate();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthLoading || state is AuthInitial) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (state is AuthAuthenticated) {
          return const CountriesScreen();
        }

        return const LoginScreen();
      },
    );
  }
}
