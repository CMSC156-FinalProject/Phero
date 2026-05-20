import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'signin_screen.dart';
import '../reports/map_feed_screen.dart';
import '../core/theme/theme_notifier.dart';
import '../presentation/viewmodels/auth_viewmodel.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _showPassword = false;
  String? _emailError;
  String? _passwordError;

  Future<void> _login() async {
    setState(() {
      _emailError = _emailController.text.isEmpty ? 'Email is required' : null;
      _passwordError = _passwordController.text.isEmpty
          ? 'Password is required'
          : null;
    });

    if (_emailError != null || _passwordError != null) return;

    final email = _emailController.text.trim();
    final password = _passwordController.text;

    final authViewModel = context.read<AuthViewModel>();
    final success = await authViewModel.signIn(email, password);

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Logged in successfully!')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MapFeedScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(authViewModel.errorMessage ?? 'Login failed')),
        );
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = context.watch<ThemeNotifier>();
    final isDark = themeNotifier.isDark;
    final bg = isDark ? const Color(0xFF0D1B2A) : Colors.white;
    final primary = isDark ? const Color(0xFF2ECC71) : const Color(0xFF3B4A2F);
    final textColor = isDark ? Colors.white : const Color(0xFF3B4A2F);
    final fieldColor = isDark
        ? const Color(0xFF1A2E1A)
        : const Color(0xFFEAEFE4);

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: 10,
              right: 10,
              child: IconButton(
                icon: Icon(
                  isDark ? Icons.wb_sunny : Icons.nightlight_round,
                  color: textColor,
                ),
                onPressed: () => themeNotifier.toggle(),
              ),
            ),
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      isDark
                          ? 'assets/images/logo_head_dark.png'
                          : 'assets/images/logo_head_light.png',
                      width: 60,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'LOG IN',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: textColor,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Divider(
                      color: primary,
                      thickness: 2,
                      indent: 120,
                      endIndent: 120,
                    ),
                    const SizedBox(height: 32),

                    _buildField(
                      hint: 'Email',
                      icon: Icons.person_outline,
                      fieldColor: fieldColor,
                      textColor: textColor,
                      controller: _emailController,
                      errorText: _emailError,
                    ),
                    const SizedBox(height: 16),

                    _buildField(
                      hint: 'Password',
                      icon: Icons.visibility_off_outlined,
                      fieldColor: fieldColor,
                      textColor: textColor,
                      obscure: !_showPassword,
                      controller: _passwordController,
                      onIconTap: () =>
                          setState(() => _showPassword = !_showPassword),
                      errorText: _passwordError,
                    ),
                    const SizedBox(height: 32),

                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: context.watch<AuthViewModel>().isLoading
                            ? null
                            : _login,
                        child: context.watch<AuthViewModel>().isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : Text(
                                'LOG IN',
                                style: TextStyle(
                                  color: isDark ? Colors.black : Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account? ",
                          style: TextStyle(color: textColor, fontSize: 13),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const SignInScreen(),
                              ),
                            );
                          },
                          child: Text(
                            'SIGN IN',
                            style: TextStyle(
                              color: primary,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField({
    required String hint,
    required IconData icon,
    required Color fieldColor,
    required Color textColor,
    TextEditingController? controller,
    bool obscure = false,
    VoidCallback? onIconTap,
    String? errorText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: fieldColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: controller,
            obscureText: obscure,
            style: TextStyle(color: textColor),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: textColor.withValues(alpha: 0.5)),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              suffixIcon: GestureDetector(
                onTap: onIconTap,
                child: Icon(icon, color: textColor.withValues(alpha: 0.6)),
              ),
            ),
          ),
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(left: 8, top: 4),
            child: Text(
              errorText,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }
}
