import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'signin_screen.dart';
import '../reports/map_feed_screen.dart';
import '../core/theme/theme_notifier.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _showPassword = false;
  bool _isLoading = false;

  Future<void> _login() async {
    setState(() => _isLoading = true);
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Logged in successfully!')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MapFeedScreen()),
        );
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? 'Login failed')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
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
    final isDark = context.watch<ThemeNotifier>().isDark;
    final bg = isDark ? const Color(0xFF0D1B2A) : Colors.white;
    final primary = isDark ? const Color(0xFF2ECC71) : const Color(0xFF3B4A2F);
    final textColor = isDark ? Colors.white : const Color(0xFF3B4A2F);
    final fieldColor = isDark ? const Color(0xFF1A2E1A) : const Color(0xFFEAEFE4);

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Stack(
          children: [
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
                    Divider(color: primary, thickness: 2, indent: 120, endIndent: 120),
                    const SizedBox(height: 32),

                    _buildField(
                      hint: 'Email',
                      icon: Icons.person_outline,
                      fieldColor: fieldColor,
                      textColor: textColor,
                      controller: _emailController,
                    ),
                    const SizedBox(height: 16),

                    _buildField(
                      hint: 'Password',
                      icon: Icons.visibility_off_outlined,
                      fieldColor: fieldColor,
                      textColor: textColor,
                      obscure: !_showPassword,
                      controller: _passwordController,
                      onIconTap: () => setState(() => _showPassword = !_showPassword),
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
                        onPressed: _isLoading ? null : _login,
                        child: _isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : Text(
                                'log in',
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
                        Text("Don't have an account? ",
                            style: TextStyle(color: textColor, fontSize: 13)),
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
  }) {
    return Container(
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
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          suffixIcon: GestureDetector(
            onTap: onIconTap,
            child: Icon(icon, color: textColor.withValues(alpha: 0.6)),
          ),
        ),
      ),
    );
  }
}