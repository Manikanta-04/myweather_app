import 'dart:convert';
import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App - 3D Extravaganza',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.indigo, useMaterial3: true),
      home: const WeatherPage(),
    );
  }
}

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage>
    with TickerProviderStateMixin {
  final TextEditingController _cityController = TextEditingController(
    text: 'Hyderabad',
  );

  bool _loading = false;
  String? _errorMessage;
  Weather? _weather;

  late AnimationController _floatingController;
  late AnimationController _rotationController;
  late AnimationController _pulseController;
  late AnimationController _particleController;
  late AnimationController _cardController;

  late Animation<double> _floatingAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _pulseAnimation;

  static const String _apiKey = '49c06d6656d9726aac9d1524ff2fd1de';

  @override
  void initState() {
    super.initState();

    _floatingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();

    _cardController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _floatingAnimation = Tween<double>(begin: -10, end: 10).animate(
      CurvedAnimation(parent: _floatingController, curve: Curves.easeInOut),
    );

    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 2 * math.pi,
    ).animate(_rotationController);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _cityController.dispose();
    _floatingController.dispose();
    _rotationController.dispose();
    _pulseController.dispose();
    _particleController.dispose();
    _cardController.dispose();
    super.dispose();
  }

  Future<void> _fetchWeather(String city) async {
    if (city.trim().isEmpty) {
      setState(() {
        _errorMessage = 'Please enter a city';
        _weather = null;
      });
      return;
    }

    setState(() {
      _loading = true;
      _errorMessage = null;
      _weather = null;
    });

    // Try HTTPS first, then HTTP as fallback
    final uris = [
      Uri.https('api.openweathermap.org', '/data/2.5/weather', {
        'q': city,
        'appid': _apiKey,
        'units': 'metric',
      }),
      Uri.http('api.openweathermap.org', '/data/2.5/weather', {
        'q': city,
        'appid': _apiKey,
        'units': 'metric',
      }),
    ];

    for (var uri in uris) {
      try {
        final resp = await http.get(uri).timeout(const Duration(seconds: 15));
        if (resp.statusCode == 200) {
          final data = jsonDecode(resp.body) as Map<String, dynamic>;
          setState(() {
            _weather = Weather.fromJson(data);
            _loading = false;
          });
          _cardController.forward(from: 0);
          return; // Success, exit
        } else if (resp.statusCode == 401) {
          setState(() {
            _errorMessage = 'Invalid API key. Please check your API key.';
            _loading = false;
          });
          return;
        } else if (resp.statusCode == 404) {
          setState(() {
            _errorMessage = 'City not found. Please try another city.';
            _loading = false;
          });
          return;
        } else {
          final data = jsonDecode(resp.body);
          setState(() {
            _errorMessage = data['message'] ?? 'Failed to fetch weather';
            _loading = false;
          });
          return;
        }
      } catch (e) {
        // Try next URI
        if (uri == uris.last) {
          setState(() {
            _errorMessage =
                'Network error. Please check your internet connection and try again.';
            _loading = false;
          });
        }
      }
    }
  }

  String _formattedTime(int timestamp, int timezoneOffset) {
    final dt = DateTime.fromMillisecondsSinceEpoch(
      (timestamp + timezoneOffset) * 1000,
      isUtc: true,
    ).toLocal();
    return DateFormat('dd MMM yyyy, HH:mm').format(dt);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Dynamic gradient background
          AnimatedContainer(
            duration: const Duration(seconds: 2),
            decoration: BoxDecoration(gradient: _getBackgroundGradient()),
          ),

          // Animated geometric shapes in background
          AnimatedBuilder(
            animation: _rotationController,
            builder: (context, child) {
              return CustomPaint(
                painter: GeometricBackgroundPainter(
                  _rotationAnimation.value,
                  _weather,
                ),
                size: Size.infinite,
              );
            },
          ),

          // Particle effects
          AnimatedBuilder(
            animation: _particleController,
            builder: (context, child) {
              return CustomPaint(
                painter: ParticlesPainter(_particleController.value, _weather),
                size: Size.infinite,
              );
            },
          ),

          // Main content
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  // Animated title
                  AnimatedBuilder(
                    animation: _pulseAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _pulseAnimation.value,
                        child: ShaderMask(
                          shaderCallback: (bounds) => LinearGradient(
                            colors: [
                              Colors.white,
                              Colors.white.withOpacity(0.8),
                              Colors.white,
                            ],
                          ).createShader(bounds),
                          child: const Text(
                            'Weather Hub',
                            style: TextStyle(
                              fontSize: 42,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 40),

                  // 3D Search bar
                  _build3DSearchBar(),

                  const SizedBox(height: 40),

                  // Weather content
                  _buildWeatherContent(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  LinearGradient _getBackgroundGradient() {
    if (_weather == null) {
      return const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF1e3c72), Color(0xFF2a5298), Color(0xFF7e22ce)],
      );
    }

    final desc = _weather!.description.toLowerCase();
    if (desc.contains('rain')) {
      return const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF283E51), Color(0xFF0A2342), Color(0xFF4CA1AF)],
      );
    } else if (desc.contains('clear') || desc.contains('sun')) {
      return const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFFF6B6B), Color(0xFFFFE66D), Color(0xFF4ECDC4)],
      );
    } else if (desc.contains('cloud')) {
      return const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF2C3E50), Color(0xFF3498DB), Color(0xFF2980B9)],
      );
    } else if (desc.contains('snow')) {
      return const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFE0EAFC), Color(0xFFCFDEF3), Color(0xFF9ED1F3)],
      );
    } else if (desc.contains('thunder')) {
      return const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF141E30), Color(0xFF243B55), Color(0xFF8E44AD)],
      );
    }

    return const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF667EEA), Color(0xFF764BA2), Color(0xFFF093FB)],
    );
  }

  Widget _build3DSearchBar() {
    return AnimatedBuilder(
      animation: _floatingAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _floatingAnimation.value),
          child: Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateX(-0.05)
              ..scale(1.0),
            alignment: Alignment.center,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withOpacity(0.3),
                    Colors.white.withOpacity(0.1),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 40,
                    offset: const Offset(0, 20),
                    spreadRadius: -5,
                  ),
                  BoxShadow(
                    color: Colors.white.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(-10, -10),
                    spreadRadius: -5,
                  ),
                ],
                border: Border.all(
                  width: 2,
                  color: Colors.white.withOpacity(0.3),
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 8,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.search,
                          color: Colors.white.withOpacity(0.9),
                          size: 28,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextField(
                            controller: _cityController,
                            textInputAction: TextInputAction.search,
                            onSubmitted: (v) => _fetchWeather(v),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Enter city name...',
                              hintStyle: TextStyle(
                                color: Colors.white.withOpacity(0.5),
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        _loading
                            ? const SizedBox(
                                width: 28,
                                height: 28,
                                child: CircularProgressIndicator(
                                  strokeWidth: 3,
                                  valueColor: AlwaysStoppedAnimation(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : GestureDetector(
                                onTap: () =>
                                    _fetchWeather(_cityController.text),
                                child: Container(
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.white.withOpacity(0.4),
                                        Colors.white.withOpacity(0.2),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        blurRadius: 10,
                                        offset: const Offset(0, 5),
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.arrow_forward_rounded,
                                    color: Colors.white,
                                    size: 24,
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
      },
    );
  }

  Widget _buildWeatherContent() {
    if (_errorMessage != null) {
      return _buildErrorCard();
    }

    if (_weather != null) {
      return AnimatedBuilder(
        animation: _cardController,
        builder: (context, child) {
          final animation = CurvedAnimation(
            parent: _cardController,
            curve: Curves.elasticOut,
          );
          // FIXED: Clamp values to valid range
          final animValue = animation.value.clamp(0.0, 1.0);
          return Transform.scale(
            scale: animValue,
            child: Opacity(
              opacity: animValue,
              child: _build3DWeatherCard(_weather!),
            ),
          );
        },
      );
    }

    return _buildEmptyState();
  }

  Widget _buildErrorCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: LinearGradient(
          colors: [Colors.red.withOpacity(0.3), Colors.red.withOpacity(0.1)],
        ),
        border: Border.all(color: Colors.red.withOpacity(0.5), width: 2),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.white, size: 40),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              _errorMessage!,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return AnimatedBuilder(
      animation: _floatingAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _floatingAnimation.value * 2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(40),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withOpacity(0.2),
                      Colors.white.withOpacity(0.05),
                    ],
                  ),
                ),
                child: Icon(
                  Icons.wb_sunny_outlined,
                  size: 100,
                  color: Colors.white.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Search for a city',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Get real-time weather updates',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                  fontSize: 16,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _build3DWeatherCard(Weather w) {
    return AnimatedBuilder(
      animation: _floatingAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _floatingAnimation.value * 0.5),
          child: Column(
            children: [
              // Main weather card
              Transform(
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.002)
                  ..rotateX(-0.08)
                  ..rotateY(0.02),
                alignment: Alignment.center,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withOpacity(0.25),
                        Colors.white.withOpacity(0.1),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 50,
                        offset: const Offset(0, 30),
                        spreadRadius: -10,
                      ),
                      BoxShadow(
                        color: Colors.white.withOpacity(0.1),
                        blurRadius: 30,
                        offset: const Offset(-20, -20),
                        spreadRadius: -10,
                      ),
                    ],
                    border: Border.all(
                      width: 2,
                      color: Colors.white.withOpacity(0.3),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Column(
                          children: [
                            // City name with glow effect
                            ShaderMask(
                              shaderCallback: (bounds) => const LinearGradient(
                                colors: [Colors.white, Colors.white70],
                              ).createShader(bounds),
                              child: Text(
                                '${w.cityName}, ${w.country}',
                                style: const TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 1,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _formattedTime(w.dt, w.timezone),
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white.withOpacity(0.7),
                              ),
                            ),
                            const SizedBox(height: 40),

                            // Temperature and icon
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Weather icon with rotation
                                if (w.icon.isNotEmpty)
                                  AnimatedBuilder(
                                    animation: _pulseAnimation,
                                    builder: (context, child) {
                                      return Transform.scale(
                                        scale: _pulseAnimation.value,
                                        child: Container(
                                          padding: const EdgeInsets.all(20),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            gradient: LinearGradient(
                                              colors: [
                                                Colors.white.withOpacity(0.3),
                                                Colors.white.withOpacity(0.1),
                                              ],
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.white.withOpacity(
                                                  0.3,
                                                ),
                                                blurRadius: 30,
                                                spreadRadius: 5,
                                              ),
                                            ],
                                          ),
                                          child: Image.network(
                                            'https://openweathermap.org/img/wn/${w.icon}@4x.png',
                                            width: 100,
                                            height: 100,
                                            errorBuilder: (_, __, ___) =>
                                                const Icon(
                                                  Icons.wb_cloudy,
                                                  size: 100,
                                                  color: Colors.white,
                                                ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                const SizedBox(width: 30),

                                // Temperature
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ShaderMask(
                                      shaderCallback: (bounds) =>
                                          LinearGradient(
                                            colors: [
                                              Colors.white,
                                              Colors.white.withOpacity(0.8),
                                            ],
                                          ).createShader(bounds),
                                      child: Text(
                                        '${w.temp.round()}°',
                                        style: const TextStyle(
                                          fontSize: 90,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          height: 1,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      w.description.toUpperCase(),
                                      style: TextStyle(
                                        fontSize: 18,
                                        letterSpacing: 2,
                                        color: Colors.white.withOpacity(0.9),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            const SizedBox(height: 30),

                            // Feels like
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.white.withOpacity(0.2),
                              ),
                              child: Text(
                                'Feels like ${w.feelsLike.round()}°C',
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
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

              const SizedBox(height: 30),

              // Details cards in a grid
              GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 1,
                children: [
                  _build3DDetailCard(
                    'Humidity',
                    '${w.humidity}%',
                    Icons.water_drop,
                    Colors.blue,
                  ),
                  _build3DDetailCard(
                    'Wind',
                    '${w.windSpeed}\nm/s',
                    Icons.air,
                    Colors.cyan,
                  ),
                  _build3DDetailCard(
                    'Pressure',
                    '${w.pressure}\nhPa',
                    Icons.speed,
                    Colors.purple,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _build3DDetailCard(
    String title,
    String value,
    IconData icon,
    Color accentColor,
  ) {
    return Transform(
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.002)
        ..rotateX(-0.05),
      alignment: Alignment.center,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withOpacity(0.25),
              Colors.white.withOpacity(0.1),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: accentColor.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
            BoxShadow(
              color: Colors.white.withOpacity(0.1),
              blurRadius: 15,
              offset: const Offset(-5, -5),
            ),
          ],
          border: Border.all(width: 2, color: Colors.white.withOpacity(0.3)),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: accentColor.withOpacity(0.3),
                    ),
                    child: Icon(icon, color: Colors.white, size: 28),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Geometric background painter
class GeometricBackgroundPainter extends CustomPainter {
  final double rotation;
  final Weather? weather;

  GeometricBackgroundPainter(this.rotation, this.weather);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // Draw rotating circles
    for (int i = 0; i < 3; i++) {
      paint.color = Colors.white.withOpacity(0.05 + i * 0.02);
      final radius = 100.0 + i * 80;
      canvas.save();
      canvas.translate(size.width / 2, size.height / 3);
      canvas.rotate(rotation + i * 0.5);
      canvas.drawCircle(Offset.zero, radius, paint);
      canvas.restore();
    }

    // Draw floating polygons
    paint.style = PaintingStyle.fill;
    for (int i = 0; i < 5; i++) {
      paint.color = Colors.white.withOpacity(0.03);
      final x = (size.width * 0.2) + (i * size.width * 0.15);
      final y = (size.height * 0.2) + (math.sin(rotation + i) * 50);
      _drawPolygon(canvas, paint, x, y, 6, 40 + i * 10, rotation * (i + 1));
    }
  }

  void _drawPolygon(
    Canvas canvas,
    Paint paint,
    double x,
    double y,
    int sides,
    double radius,
    double rotation,
  ) {
    final path = Path();
    for (int i = 0; i <= sides; i++) {
      final angle = (2 * math.pi * i / sides) + rotation;
      final px = x + radius * math.cos(angle);
      final py = y + radius * math.sin(angle);
      if (i == 0) {
        path.moveTo(px, py);
      } else {
        path.lineTo(px, py);
      }
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(GeometricBackgroundPainter oldDelegate) => true;
}

// Enhanced particles painter
class ParticlesPainter extends CustomPainter {
  final double progress;
  final Weather? weather;
  final math.Random random = math.Random(42);

  ParticlesPainter(this.progress, this.weather);

  @override
  void paint(Canvas canvas, Size size) {
    if (weather == null) return;

    final desc = weather!.description.toLowerCase();
    if (desc.contains('rain')) {
      _drawRain(canvas, size);
    } else if (desc.contains('snow')) {
      _drawSnow(canvas, size);
    } else if (desc.contains('clear')) {
      _drawSparkles(canvas, size);
    }
  }

  void _drawRain(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.4)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < 150; i++) {
      final x = random.nextDouble() * size.width;
      final baseY = random.nextDouble() * size.height;
      final speed = 1.5 + random.nextDouble();
      final y = (baseY + progress * size.height * speed) % size.height;
      final length = 15 + random.nextDouble() * 25;

      canvas.drawLine(Offset(x, y), Offset(x - 8, y + length), paint);
    }
  }

  void _drawSnow(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.9)
      ..style = PaintingStyle.fill;

    for (int i = 0; i < 80; i++) {
      final x = random.nextDouble() * size.width;
      final baseY = random.nextDouble() * size.height;
      final speed = 0.3 + random.nextDouble() * 0.3;
      final y = (baseY + progress * size.height * speed) % size.height;
      final radius = 2 + random.nextDouble() * 4;
      final drift = math.sin(progress * 2 * math.pi + i) * 20;

      canvas.drawCircle(Offset(x + drift, y), radius, paint);
    }
  }

  void _drawSparkles(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.6)
      ..style = PaintingStyle.fill;

    for (int i = 0; i < 50; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final scale = (math.sin(progress * 2 * math.pi + i * 0.5) + 1) / 2;
      final starSize = 2 + scale * 3;

      // Draw star shape
      _drawStar(canvas, paint, x, y, starSize);
    }
  }

  void _drawStar(Canvas canvas, Paint paint, double x, double y, double size) {
    final path = Path();
    for (int i = 0; i < 5; i++) {
      final angle = (i * 2 * math.pi / 5) - math.pi / 2;
      final outerX = x + size * math.cos(angle);
      final outerY = y + size * math.sin(angle);

      if (i == 0) {
        path.moveTo(outerX, outerY);
      } else {
        path.lineTo(outerX, outerY);
      }

      final innerAngle = angle + math.pi / 5;
      final innerX = x + (size / 2) * math.cos(innerAngle);
      final innerY = y + (size / 2) * math.sin(innerAngle);
      path.lineTo(innerX, innerY);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(ParticlesPainter oldDelegate) => true;
}

// Weather model
class Weather {
  final String cityName;
  final String country;
  final double temp;
  final double feelsLike;
  final String description;
  final String icon;
  final int humidity;
  final double windSpeed;
  final int pressure;
  final int dt;
  final int timezone;

  Weather({
    required this.cityName,
    required this.country,
    required this.temp,
    required this.feelsLike,
    required this.description,
    required this.icon,
    required this.humidity,
    required this.windSpeed,
    required this.pressure,
    required this.dt,
    required this.timezone,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      cityName: json['name'] ?? '',
      country: (json['sys'] != null && json['sys']['country'] != null)
          ? json['sys']['country']
          : '',
      temp: (json['main']?['temp'] ?? 0).toDouble(),
      feelsLike: (json['main']?['feels_like'] ?? 0).toDouble(),
      description:
          ((json['weather'] as List).isNotEmpty
                  ? json['weather'][0]['description']
                  : '')
              .toString(),
      icon:
          ((json['weather'] as List).isNotEmpty
                  ? json['weather'][0]['icon']
                  : '')
              .toString(),
      humidity: (json['main']?['humidity'] ?? 0).toInt(),
      windSpeed: (json['wind']?['speed'] ?? 0).toDouble(),
      pressure: (json['main']?['pressure'] ?? 0).toInt(),
      dt: (json['dt'] ?? 0).toInt(),
      timezone: (json['timezone'] ?? 0).toInt(),
    );
  }
}
