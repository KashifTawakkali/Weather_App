import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:weather/weather.dart';

import '../../bloc/weather_bloc.dart';
import '../../bloc/weather_event.dart';
import '../../bloc/weather_state.dart';
import '../widgets/weather_background.dart';

class WeatherScreen extends StatelessWidget {
  const WeatherScreen({
    super.key,
    required this.latitude,
    required this.longitude,
  });

  final double latitude;
  final double longitude;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => WeatherBloc()
        ..add(
          FetchWeather(
            latitude: latitude,
            longitude: longitude,
          ),
        ),
      child: const _WeatherView(),
    );
  }
}

class _WeatherView extends StatelessWidget {
  const _WeatherView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarBrightness: Brightness.dark,
          statusBarIconBrightness: Brightness.light,
        ),
      ),
      body: BlocBuilder<WeatherBloc, WeatherState>(
        builder: (context, state) {
          if (state is WeatherLoading) {
            return const _LoadingView();
          }

          if (state is WeatherFailure) {
            return _ErrorView(
              message: state.message,
              onRetry: () {
                context.read<WeatherBloc>().add(
                      const FetchWeather(
                        latitude: 28.6139,
                        longitude: 77.2090,
                      ),
                    );
              },
            );
          }

          if (state is WeatherSuccess) {
            return WeatherBackground(
              weatherCode: state.weather.weatherConditionCode ?? 800,
              child: _WeatherContent(
                weather: state.weather,
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _WeatherContent extends StatelessWidget {
  const _WeatherContent({
    required this.weather,
  });

  final Weather weather;

  Widget getWeatherIcon(int code) {
    switch (code) {
      case >= 200 && < 300:
        return Image.asset(
          'assets/1.png',
          width: 150,
          height: 150,
        );

      case >= 300 && < 400:
        return Image.asset(
          'assets/2.png',
          width: 150,
          height: 150,
        );

      case >= 500 && < 600:
        return Image.asset(
          'assets/3.png',
          width: 150,
          height: 150,
        );

      case >= 600 && < 700:
        return Image.asset(
          'assets/4.png',
          width: 150,
          height: 150,
        );

      case >= 700 && < 800:
        return Image.asset(
          'assets/5.png',
          width: 150,
          height: 150,
        );

      case == 800:
        return Image.asset(
          'assets/6.png',
          width: 150,
          height: 150,
        );

      case > 800 && <= 804:
        return Image.asset(
          'assets/7.png',
          width: 150,
          height: 150,
        );

      default:
        return Image.asset(
          'assets/7.png',
          width: 150,
          height: 150,
        );
    }
  }

  String _greeting() {
    final hour = DateTime.now().hour;

    if (hour < 12) {
      return 'Good Morning';
    }

    if (hour < 17) {
      return 'Good Afternoon';
    }

    if (hour < 21) {
      return 'Good Evening';
    }

    return 'Good Night';
  }

  String _formatTemperature(Temperature? temperature) {
    final value = temperature?.celsius;

    if (value == null) {
      return '--°C';
    }

    return '${value.round()}°C';
  }

  String _formatTime(DateTime? dateTime) {
    if (dateTime == null) {
      return '--';
    }

    return DateFormat().add_jm().format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    final weatherCode = weather.weatherConditionCode ?? 800;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          28,
          20,
          28,
          20,
        ),
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Location
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        weather.areaName ?? 'Unknown location',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Greeting
                Text(
                  _greeting(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 27,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                // Weather icon
                Center(
                  child: SizedBox(
                    height: 180,
                    width: 180,
                    child: getWeatherIcon(weatherCode),
                  ),
                ),

                const SizedBox(height: 4),

                // Temperature
                Center(
                  child: Text(
                    _formatTemperature(weather.temperature),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 64,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                const SizedBox(height: 2),

                // Weather condition
                Center(
                  child: Text(
                    weather.weatherMain?.toUpperCase() ?? 'UNKNOWN',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1,
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // Date
                Center(
                  child: Text(
                    weather.date == null
                        ? '--'
                        : DateFormat(
                            'EEEE dd • ',
                          ).add_jm().format(weather.date!),
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 15,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // Sunrise / Sunset
                _GlassCard(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _WeatherInfo(
                        icon: Icons.wb_sunny_outlined,
                        title: 'Sunrise',
                        value: _formatTime(weather.sunrise),
                      ),
                      _WeatherInfo(
                        icon: Icons.nights_stay_outlined,
                        title: 'Sunset',
                        value: _formatTime(weather.sunset),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                // Temperature max / min
                _GlassCard(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _WeatherInfo(
                        icon: Icons.thermostat_rounded,
                        title: 'Temp Max',
                        value:
                            '${weather.tempMax?.celsius?.round() ?? '--'} °C',
                      ),
                      _WeatherInfo(
                        icon: Icons.ac_unit_rounded,
                        title: 'Temp Min',
                        value:
                            '${weather.tempMin?.celsius?.round() ?? '--'} °C',
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                // Additional information
                _GlassCard(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _WeatherInfo(
                        icon: Icons.water_drop_outlined,
                        title: 'Humidity',
                        value: '${weather.humidity ?? '--'}%',
                      ),
                      _WeatherInfo(
                        icon: Icons.air_rounded,
                        title: 'Wind',
                        value: '${weather.windSpeed?.round() ?? '--'} m/s',
                      ),
                      _WeatherInfo(
                        icon: Icons.compress_rounded,
                        title: 'Pressure',
                        value: '${weather.pressure ?? '--'} hPa',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GlassCard extends StatelessWidget {
  const _GlassCard({
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 15,
          sigmaY: 15,
        ),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            vertical: 20,
            horizontal: 12,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.15),
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}

class _WeatherInfo extends StatelessWidget {
  const _WeatherInfo({
    required this.icon,
    required this.title,
    required this.value,
  });

  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: Colors.white,
          size: 26,
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
                fontWeight: FontWeight.w300,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF172554),
            Color(0xFF0F172A),
          ],
        ),
      ),
      child: const Center(
        child: CircularProgressIndicator(
          color: Colors.white,
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF172554),
            Color(0xFF0F172A),
          ],
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.cloud_off_rounded,
                color: Colors.white,
                size: 64,
              ),
              const SizedBox(height: 20),
              const Text(
                'Unable to load weather',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Try Again'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
