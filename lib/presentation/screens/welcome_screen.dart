import 'package:flutter/material.dart';
import 'signin_screen.dart';

class WelcomeScreen extends StatelessWidget {
  final bool isDark;
  final VoidCallback onToggle;

  const WelcomeScreen({super.key, required this.isDark, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    final bg = isDark ? const Color(0xFF0D1B2A) : Colors.white;
    final primary = isDark ? const Color(0xFF2ECC71) : const Color(0xFF3B4A2F);
    final textColor = isDark ? Colors.white : const Color(0xFF3B4A2F);

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
                  isDark ? Icons.wb_sunny : Icons.nightlight_round,
                  color: isDark ? const Color(0xFF7A9A6A) : const Color(0xFF5C6E3E),
                  size: 28,
                ),
                onPressed: onToggle,
              ),
            ),

            // Main content
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo icon only
                    Image.asset(
                      isDark
                          ? 'assets/images/logo_head_dark.png'
                          : 'assets/images/logo_head_light.png',
                      width: 80,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'welcome!',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 60),
                    // Continue button
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
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => SignInScreen(
                                isDark: isDark,
                                onToggle: onToggle,
                              ),
                            ),
                          );
                        },
                        child: Text(
                          'continue',
                          style: TextStyle(
                            color: isDark ? Colors.black : Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
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
}