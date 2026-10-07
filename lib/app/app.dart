import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';

class CountryWeatherApp extends StatelessWidget {
  const CountryWeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather Explorer',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const Scaffold(
        body: Center(
          child: Text('Weather Explorer'),
        ),
      ),
    );
  }
}
