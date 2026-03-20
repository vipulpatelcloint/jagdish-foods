// lib/presentation/screens/auth/splash_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/routes/app_router.dart';
import '../../../providers/auth_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _loaderController;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));
    _loaderController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    _init();
  }

  Future<void> _init() async {
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;
    final authProvider = context.read<AuthProvider>();
    await authProvider.checkAuth();

    if (!mounted) return;
    if (authProvider.isAuthenticated) {
      context.go(AppRoutes.home);
    } else {
      context.go(AppRoutes.welcome);
    }
  }

  @override
  void dispose() {
    _loaderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.heroGradient),
        child: Stack(
          children: [
            // Pattern background
            Positioned.fill(
              child: CustomPaint(painter: _PatternPainter()),
            ),

            // Decorative circles
            Positioned(
              top: -60, right: -60,
              child: Container(
                width: 200, height: 200,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.06),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              bottom: -80, left: -60,
              child: Container(
                width: 260, height: 260,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.04),
                  shape: BoxShape.circle,
                ),
              ),
            ),

            // Content
            SafeArea(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo Card
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 36, vertical: 28,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 30,
                            offset: const Offset(0, 15),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Image.asset(
                            'assets/images/jagdish_logo.png',
                            width: 120,
                            errorBuilder: (_, __, ___) => const _LogoFallback(),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'FOODS',
                            style: TextStyle(
                              fontFamily: 'DMSans',
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Colors.white.withOpacity(0.7),
                              letterSpacing: 4,
                            ),
                          ),
                        ],
                      ),
                    )
                    .animate()
                    .scale(
                      begin: const Offset(0.8, 0.8),
                      duration: 600.ms,
                      curve: Curves.elasticOut,
                    )
                    .fadeIn(duration: 400.ms),

                    const SizedBox(height: 24),

                    Text(
                      AppConstants.appTagline,
                      style: TextStyle(
                        fontFamily: 'DMSans',
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withOpacity(0.75),
                        letterSpacing: 1.5,
                      ),
                    )
                    .animate(delay: 400.ms)
                    .fadeIn(duration: 400.ms)
                    .slideY(begin: 0.3),

                    const SizedBox(height: 60),

                    // Loader bar
                    SizedBox(
                      width: 80,
                      child: AnimatedBuilder(
                        animation: _loaderController,
                        builder: (context, _) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(2),
                            child: LinearProgressIndicator(
                              value: _loaderController.value,
                              backgroundColor: Colors.white.withOpacity(0.2),
                              valueColor: const AlwaysStoppedAnimation(
                                AppColors.yellow,
                              ),
                              minHeight: 3,
                            ),
                          );
                        },
                      ),
                    )
                    .animate(delay: 600.ms)
                    .fadeIn(duration: 300.ms),
                  ],
                ),
              ),
            ),

            // Bottom tagline
            Positioned(
              bottom: 40,
              left: 0, right: 0,
              child: Text(
                'Authentic • Premium • Gujarati',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'DMSans',
                  fontSize: 11,
                  color: Colors.white.withOpacity(0.5),
                  letterSpacing: 2,
                ),
              )
              .animate(delay: 800.ms)
              .fadeIn(duration: 400.ms),
            ),
          ],
        ),
      ),
    );
  }
}

class _LogoFallback extends StatelessWidget {
  const _LogoFallback();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 80, height: 80,
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Icon(
            Icons.restaurant_rounded,
            color: AppColors.primary,
            size: 40,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Jagdish',
          style: TextStyle(
            fontFamily: 'PlayfairDisplay',
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _PatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.04)
      ..style = PaintingStyle.fill;

    for (int i = 0; i < 10; i++) {
      for (int j = 0; j < 20; j++) {
        canvas.drawCircle(
          Offset(i * 44.0, j * 44.0),
          2,
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(_) => false;
}
