import 'package:flutter/material.dart';
import 'login_screen.dart';
import '../../core/di/app_providers.dart';
import 'map_feed_screen.dart';

class SignInScreen extends StatefulWidget {
  final bool isDark;
  final VoidCallback onToggle;

  const SignInScreen({super.key, required this.isDark, required this.onToggle});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  
  bool _showPassword = false;
  bool _showConfirmPassword = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bg = widget.isDark ? const Color(0xFF0D1B2A) : Colors.white;
    final primary = widget.isDark ? const Color(0xFF2ECC71) : const Color(0xFF3B4A2F);
    final textColor = widget.isDark ? Colors.white : const Color(0xFF3B4A2F);
    final fieldColor = widget.isDark ? const Color(0xFF1A2E1A) : const Color(0xFFEAEFE4);

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Stack(
          children: [
            // Toggle button top right
            Positioned(
              top: 8,
              right: 8,
              child: IconButton(
                icon: Icon(
                  widget.isDark ? Icons.wb_sunny : Icons.nightlight_round,
                  color: widget.isDark ? const Color(0xFF2ECC71) : const Color(0xFF5C6E3E),
                  size: 28,
                ),
                onPressed: widget.onToggle,
              ),
            ),

            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      widget.isDark
                          ? 'assets/images/logo_head_dark.png'
                          : 'assets/images/logo_head_light.png',
                      width: 60,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'SIGN IN',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Divider(color: primary, thickness: 2, indent: 120, endIndent: 120),
                    const SizedBox(height: 32),

                    // Email field
                    _buildField(
                      hint: 'Email',
                      icon: Icons.person_outline,
                      fieldColor: fieldColor,
                      textColor: textColor,
                      controller: _emailController,
                    ),
                    const SizedBox(height: 16),

                    // Password field
                    _buildField(
                      hint: 'Password',
                      icon: Icons.visibility_off_outlined,
                      fieldColor: fieldColor,
                      textColor: textColor,
                      obscure: !_showPassword,
                      controller: _passwordController,
                      onIconTap: () => setState(() => _showPassword = !_showPassword),
                    ),
                    const SizedBox(height: 16),

                    // Confirm Password field
                    _buildField(
                      hint: 'Confirm Password',
                      icon: Icons.visibility_off_outlined,
                      fieldColor: fieldColor,
                      textColor: textColor,
                      obscure: !_showConfirmPassword,
                      controller: _confirmController,
                      onIconTap: () => setState(() => _showConfirmPassword = !_showConfirmPassword),
                    ),
                    const SizedBox(height: 32),

                    // Sign In button
                    ListenableBuilder(
                      listenable: AppProviders.of(context).authViewModel,
                      builder: (context, _) {
                        final auth = AppProviders.of(context).authViewModel;
                        return SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            onPressed: auth.isLoading
                                ? null
                                : () async {
                                    if (_passwordController.text != _confirmController.text) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('Passwords do not match')));
                                      return;
                                    }
                                    final success = await auth.register(
                                      _emailController.text.trim(),
                                      _passwordController.text,
                                    );
                                    if (success && context.mounted) {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => MapFeedScreen(
                                              isDark: widget.isDark, onToggle: widget.onToggle),
                                        ),
                                      );
                                    } else if (context.mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('Registration failed')));
                                    }
                                  },
                            child: auth.isLoading
                                ? const CircularProgressIndicator(color: Colors.white)
                                : Text(
                                    'sign in',
                                    style: TextStyle(
                                      color: widget.isDark ? Colors.black : Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ),
                        );
                      }
                    ),
                    const SizedBox(height: 16),

                    // Already have account
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Already have an account? ',
                            style: TextStyle(color: textColor, fontSize: 13)),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => LoginScreen(
                                  isDark: widget.isDark,
                                  onToggle: widget.onToggle,
                                ),
                              ),
                            );
                          },
                          child: Text(
                            'LOG IN',
                            style: TextStyle(
                              color: primary,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
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
    required TextEditingController controller,
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