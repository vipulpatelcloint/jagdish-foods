// lib/presentation/screens/auth/welcome_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/routes/app_router.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../widgets/common/jf_button.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Hero section
          Container(
            height: MediaQuery.of(context).size.height * 0.48,
            decoration: const BoxDecoration(
              gradient: AppColors.heroGradient,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(36),
                bottomRight: Radius.circular(36),
              ),
            ),
            child: Stack(
              children: [
                Positioned.fill(child: CustomPaint(painter: _WelcomeBgPainter())),
                SafeArea(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/jagdish_logo.png',
                          width: 100,
                          errorBuilder: (_, __, ___) => Container(
                            width: 100, height: 100,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: const Icon(Icons.restaurant, color: Colors.white, size: 50),
                          ),
                        ).animate().scale(duration: 600.ms, curve: Curves.elasticOut),
                        const SizedBox(height: 20),
                        const Text(
                          'Taste the Heritage',
                          style: TextStyle(
                            fontFamily: 'PlayfairDisplay',
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.w700,
                          ),
                        ).animate(delay: 200.ms).fadeIn().slideY(begin: 0.3),
                        const SizedBox(height: 8),
                        Text(
                          'Authentic Gujarati Snacks Delivered',
                          style: TextStyle(
                            fontFamily: 'DMSans',
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 14,
                          ),
                        ).animate(delay: 350.ms).fadeIn().slideY(begin: 0.3),
                        const SizedBox(height: 20),
                        // Feature pills
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _FeaturePill('🌿 Pure Veg'),
                            const SizedBox(width: 8),
                            _FeaturePill('🏆 Since 1945'),
                            const SizedBox(width: 8),
                            _FeaturePill('🚚 Fast Delivery'),
                          ],
                        ).animate(delay: 500.ms).fadeIn(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Body
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Text('Welcome! 👋', style: AppTextStyles.displayMedium)
                      .animate(delay: 400.ms).fadeIn().slideY(begin: 0.2),
                  const SizedBox(height: 6),
                  Text(
                    'Sign in to enjoy Bhakharwadi, Chevdo,\nand your favourite Gujarati snacks.',
                    style: AppTextStyles.bodyLarge,
                  ).animate(delay: 500.ms).fadeIn(),
                  const SizedBox(height: 28),
                  JFButton(
                    label: 'Continue with Phone',
                    icon: Icons.phone_android_rounded,
                    onTap: () => context.push(AppRoutes.phoneAuth),
                  ).animate(delay: 600.ms).fadeIn().slideY(begin: 0.2),
                  const SizedBox(height: 12),
                  JFButton.outline(
                    label: 'Continue as Guest',
                    icon: Icons.person_outline_rounded,
                    onTap: () => context.go(AppRoutes.home),
                  ).animate(delay: 700.ms).fadeIn().slideY(begin: 0.2),
                  const SizedBox(height: 24),
                  Center(
                    child: RichText(
                      text: TextSpan(
                        style: AppTextStyles.bodySmall,
                        children: [
                          const TextSpan(text: 'By continuing, you agree to our '),
                          TextSpan(
                            text: 'Terms & Privacy Policy',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ).animate(delay: 800.ms).fadeIn(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FeaturePill extends StatelessWidget {
  final String label;
  const _FeaturePill(this.label);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontFamily: 'DMSans', color: Colors.white,
          fontSize: 11, fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _WelcomeBgPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.05)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(size.width, 0), 120, paint);
    canvas.drawCircle(Offset(0, size.height), 100, paint);
  }
  @override
  bool shouldRepaint(_) => false;
}

// ─── Phone Auth Screen ─────────────────────────────────────────────────────
class PhoneAuthScreen extends StatefulWidget {
  const PhoneAuthScreen({super.key});
  @override
  State<PhoneAuthScreen> createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;

  Future<void> _sendOtp() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    setState(() => _loading = false);
    context.push(AppRoutes.otp, extra: '+91${_controller.text.trim()}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter Phone Number'),
        leading: const BackButton(),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                Text('What\'s your number?', style: AppTextStyles.headlineLarge),
                const SizedBox(height: 8),
                Text(
                  'We\'ll send you a one-time password to verify your number.',
                  style: AppTextStyles.bodyMedium,
                ),
                const SizedBox(height: 32),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.border),
                    boxShadow: AppColors.cardShadow,
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        decoration: const BoxDecoration(
                          border: Border(right: BorderSide(color: AppColors.border)),
                        ),
                        child: const Row(
                          children: [
                            Text('🇮🇳', style: TextStyle(fontSize: 20)),
                            SizedBox(width: 6),
                            Text('+91', style: TextStyle(
                              fontFamily: 'DMSans',
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textDark,
                            )),
                            Icon(Icons.arrow_drop_down, color: AppColors.textLight),
                          ],
                        ),
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: _controller,
                          keyboardType: TextInputType.phone,
                          maxLength: 10,
                          style: AppTextStyles.labelLarge.copyWith(fontSize: 16),
                          decoration: const InputDecoration(
                            hintText: '98765 43210',
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            counterText: '',
                            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          ),
                          validator: (v) {
                            if (v == null || v.length != 10) return 'Enter valid 10-digit number';
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                JFButton(
                  label: 'Send OTP',
                  onTap: _sendOtp,
                  isLoading: _loading,
                ),
                const SizedBox(height: 16),
                Center(
                  child: Text(
                    'OTP will be sent via SMS',
                    style: AppTextStyles.bodySmall,
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

// ─── OTP Screen ────────────────────────────────────────────────────────────
class OtpScreen extends StatefulWidget {
  final String phone;
  const OtpScreen({super.key, required this.phone});
  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final _controllers = List.generate(6, (_) => TextEditingController());
  final _focusNodes = List.generate(6, (_) => FocusNode());
  bool _loading = false;
  int _resendCountdown = AppConstants.otpResendSeconds;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() async {
    while (_resendCountdown > 0 && mounted) {
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) setState(() => _resendCountdown--);
    }
  }

  String get _otp => _controllers.map((c) => c.text).join();

  Future<void> _verify() async {
    if (_otp.length != 6) return;
    setState(() => _loading = true);
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    setState(() => _loading = false);
    context.go(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify OTP')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Text('Enter OTP', style: AppTextStyles.headlineLarge),
              const SizedBox(height: 8),
              RichText(
                text: TextSpan(
                  style: AppTextStyles.bodyMedium,
                  children: [
                    const TextSpan(text: 'Sent to '),
                    TextSpan(
                      text: widget.phone,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textDark,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(6, (i) {
                  return SizedBox(
                    width: 46,
                    height: 56,
                    child: TextField(
                      controller: _controllers[i],
                      focusNode: _focusNodes[i],
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: 'DMSans',
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark,
                      ),
                      decoration: InputDecoration(
                        counterText: '',
                        fillColor: AppColors.white,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.border),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.primary, width: 2),
                        ),
                      ),
                      onChanged: (v) {
                        if (v.isNotEmpty && i < 5) {
                          _focusNodes[i + 1].requestFocus();
                        } else if (v.isEmpty && i > 0) {
                          _focusNodes[i - 1].requestFocus();
                        }
                        if (_otp.length == 6) _verify();
                      },
                    ),
                  );
                }),
              ),
              const SizedBox(height: 32),
              JFButton(
                label: 'Verify & Continue',
                onTap: _verify,
                isLoading: _loading,
              ),
              const SizedBox(height: 20),
              Center(
                child: _resendCountdown > 0
                    ? Text(
                        'Resend OTP in ${_resendCountdown}s',
                        style: AppTextStyles.bodyMedium,
                      )
                    : TextButton(
                        onPressed: () {
                          setState(() => _resendCountdown = 30);
                          _startCountdown();
                        },
                        child: const Text('Resend OTP'),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Profile setup - stub
class ProfileSetupScreen extends StatelessWidget {
  const ProfileSetupScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Set Up Profile')),
      body: const Center(child: Text('Profile Setup Screen')),
    );
  }
}
