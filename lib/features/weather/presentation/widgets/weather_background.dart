import 'dart:math';

import 'package:flutter/material.dart';

class WeatherBackground extends StatefulWidget {
  const WeatherBackground({
    super.key,
    required this.weatherCode,
    required this.child,
  });

  final int weatherCode;
  final Widget child;

  @override
  State<WeatherBackground> createState() => _WeatherBackgroundState();
}

class _WeatherBackgroundState extends State<WeatherBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  final Random _random = Random();

  late List<_Particle> _particles;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    _particles = _createParticles();
  }

  @override
  void didUpdateWidget(covariant WeatherBackground oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.weatherCode != widget.weatherCode) {
      _particles = _createParticles();
    }
  }

  List<_Particle> _createParticles() {
    final type = _weatherType;

    final count = switch (type) {
      _WeatherType.rain => 90,
      _WeatherType.thunderstorm => 100,
      _WeatherType.snow => 60,
      _ => 30,
    };

    return List.generate(
      count,
      (_) => _Particle(
        x: _random.nextDouble(),
        y: _random.nextDouble(),
        speed: 0.3 + _random.nextDouble() * 0.7,
        size: 1 + _random.nextDouble() * 3,
        drift: -0.15 + _random.nextDouble() * 0.3,
      ),
    );
  }

  _WeatherType get _weatherType {
    final code = widget.weatherCode;

    if (code >= 200 && code < 300) {
      return _WeatherType.thunderstorm;
    }

    if (code >= 300 && code < 400) {
      return _WeatherType.drizzle;
    }

    if (code >= 500 && code < 600) {
      return _WeatherType.rain;
    }

    if (code >= 600 && code < 700) {
      return _WeatherType.snow;
    }

    if (code >= 700 && code < 800) {
      return _WeatherType.mist;
    }

    if (code == 800) {
      return _WeatherType.clear;
    }

    if (code > 800 && code <= 804) {
      return _WeatherType.clouds;
    }

    return _WeatherType.clouds;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        _WeatherGradient(type: _weatherType),
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return CustomPaint(
              painter: _WeatherPainter(
                type: _weatherType,
                progress: _controller.value,
                particles: _particles,
              ),
            );
          },
        ),
        widget.child,
      ],
    );
  }
}

enum _WeatherType {
  clear,
  clouds,
  rain,
  drizzle,
  thunderstorm,
  snow,
  mist,
}

class _Particle {
  _Particle({
    required this.x,
    required this.y,
    required this.speed,
    required this.size,
    required this.drift,
  });

  final double x;
  final double y;
  final double speed;
  final double size;
  final double drift;
}

class _WeatherGradient extends StatelessWidget {
  const _WeatherGradient({
    required this.type,
  });

  final _WeatherType type;

  List<Color> get colors {
    switch (type) {
      case _WeatherType.clear:
        return const [
          Color(0xFF087EA4),
          Color(0xFF35B8D4),
          Color(0xFFFFB74D),
        ];

      case _WeatherType.clouds:
        return const [
          Color(0xFF26364A),
          Color(0xFF526579),
          Color(0xFF91A0AD),
        ];

      case _WeatherType.rain:
      case _WeatherType.drizzle:
        return const [
          Color(0xFF101C2C),
          Color(0xFF263D55),
          Color(0xFF405B70),
        ];

      case _WeatherType.thunderstorm:
        return const [
          Color(0xFF080B17),
          Color(0xFF171D35),
          Color(0xFF303752),
        ];

      case _WeatherType.snow:
        return const [
          Color(0xFF536A7D),
          Color(0xFF8EA5B7),
          Color(0xFFD7E3EA),
        ];

      case _WeatherType.mist:
        return const [
          Color(0xFF68777D),
          Color(0xFF9BA7AA),
          Color(0xFFC7CECD),
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 1200),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
        ),
      ),
    );
  }
}

class _WeatherPainter extends CustomPainter {
  _WeatherPainter({
    required this.type,
    required this.progress,
    required this.particles,
  });

  final _WeatherType type;
  final double progress;
  final List<_Particle> particles;

  @override
  void paint(Canvas canvas, Size size) {
    switch (type) {
      case _WeatherType.clear:
        _paintSun(canvas, size);

      case _WeatherType.clouds:
        _paintClouds(canvas, size);

      case _WeatherType.rain:
      case _WeatherType.drizzle:
        _paintRain(canvas, size);

      case _WeatherType.thunderstorm:
        _paintRain(canvas, size);
        _paintLightning(canvas, size);

      case _WeatherType.snow:
        _paintSnow(canvas, size);

      case _WeatherType.mist:
        _paintMist(canvas, size);
    }
  }

  void _paintSun(Canvas canvas, Size size) {
    final center = Offset(
      size.width * 0.78,
      size.height * 0.18,
    );

    final pulse = sin(progress * 2 * pi) * 8;

    final glowPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.white.withValues(alpha: 0.35),
          Colors.orange.withValues(alpha: 0.15),
          Colors.transparent,
        ],
      ).createShader(
        Rect.fromCircle(
          center: center,
          radius: 100 + pulse,
        ),
      );

    canvas.drawCircle(
      center,
      100 + pulse,
      glowPaint,
    );

    final sunPaint = Paint()..color = const Color(0xFFFFD54F);

    canvas.drawCircle(
      center,
      42,
      sunPaint,
    );

    final rayPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.35)
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    for (var i = 0; i < 12; i++) {
      final angle = i * pi / 6;

      final start = Offset(
        center.dx + cos(angle) * 55,
        center.dy + sin(angle) * 55,
      );

      final end = Offset(
        center.dx + cos(angle) * 72,
        center.dy + sin(angle) * 72,
      );

      canvas.drawLine(start, end, rayPaint);
    }
  }

  void _paintRain(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.45)
      ..strokeWidth = 1.4
      ..strokeCap = StrokeCap.round;

    for (final particle in particles) {
      final y = ((particle.y + progress * particle.speed) % 1.2) * size.height;

      final x = ((particle.x + progress * particle.drift) % 1.0) * size.width;

      final length = particle.size * 10;

      canvas.drawLine(
        Offset(x, y),
        Offset(
          x - 3,
          y + length,
        ),
        paint,
      );
    }

    _paintClouds(canvas, size);
  }

  void _paintSnow(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withValues(alpha: 0.8);

    for (final particle in particles) {
      final y =
          ((particle.y + progress * particle.speed * 0.5) % 1.1) * size.height;

      final x =
          ((particle.x + sin(progress * 2 * pi + particle.y * 10) * 0.03) %
                  1.0) *
              size.width;

      canvas.drawCircle(
        Offset(x, y),
        particle.size,
        paint,
      );
    }

    _paintClouds(canvas, size);
  }

  void _paintClouds(Canvas canvas, Size size) {
    final movement = sin(progress * 2 * pi) * 20;

    final cloudPaint = Paint()..color = Colors.white.withValues(alpha: 0.18);

    _drawCloud(
      canvas,
      Offset(
        size.width * 0.2 + movement,
        size.height * 0.2,
      ),
      110,
      cloudPaint,
    );

    _drawCloud(
      canvas,
      Offset(
        size.width * 0.7 - movement,
        size.height * 0.35,
      ),
      140,
      cloudPaint,
    );
  }

  void _drawCloud(
    Canvas canvas,
    Offset center,
    double width,
    Paint paint,
  ) {
    canvas.drawOval(
      Rect.fromCenter(
        center: center,
        width: width,
        height: width * 0.45,
      ),
      paint,
    );

    canvas.drawCircle(
      Offset(
        center.dx - width * 0.25,
        center.dy - width * 0.12,
      ),
      width * 0.25,
      paint,
    );

    canvas.drawCircle(
      Offset(
        center.dx + width * 0.05,
        center.dy - width * 0.2,
      ),
      width * 0.32,
      paint,
    );

    canvas.drawCircle(
      Offset(
        center.dx + width * 0.3,
        center.dy - width * 0.08,
      ),
      width * 0.22,
      paint,
    );
  }

  void _paintMist(Canvas canvas, Size size) {
    final movement = sin(progress * 2 * pi) * size.width * 0.15;

    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.12)
      ..maskFilter = const MaskFilter.blur(
        BlurStyle.normal,
        20,
      );

    for (var i = 0; i < 5; i++) {
      final y = size.height * (0.2 + i * 0.15);

      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(
            size.width * 0.5 + movement,
            y,
          ),
          width: size.width * 1.2,
          height: 35,
        ),
        paint,
      );
    }
  }

  void _paintLightning(Canvas canvas, Size size) {
    final flash = sin(progress * pi * 6);

    if (flash > 0.97) {
      final paint = Paint()..color = Colors.white.withValues(alpha: 0.75);

      canvas.drawRect(
        Offset.zero & size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _WeatherPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.type != type;
  }
}
