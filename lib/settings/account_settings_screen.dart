import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../auth/login_screen.dart';
import '../core/theme/theme_notifier.dart';

// ─── Account Settings ────────────────────────────────────────────────────────

class AccountSettingsScreen extends StatefulWidget {
  const AccountSettingsScreen({super.key});

  @override
  State<AccountSettingsScreen> createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  User? get _firebaseUser => FirebaseAuth.instance.currentUser;

  String get _displayName {
    final u = _firebaseUser;
    if (u == null) return 'User';
    if (u.displayName != null && u.displayName!.trim().isNotEmpty) return u.displayName!;
    return u.email?.split('@').first ?? 'User';
  }

  String get _userEmail => _firebaseUser?.email ?? '';

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeNotifier>().isDark;
    final primary = isDark ? const Color(0xFF2ECC71) : const Color(0xFF3B4A2F);
    final bg = isDark ? const Color(0xFF0D1B2A) : Colors.white;
    final cardBg = isDark ? const Color(0xFF132030) : const Color(0xFFF5F7F2);
    final textColor = isDark ? Colors.white : const Color(0xFF1A1A1A);
    final subText = isDark ? const Color(0xFF8A9BB0) : const Color(0xFF8A9070);

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(Icons.chevron_left, color: primary, size: 28),
                  ),
                  Text('phero.', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: primary)),
                  Container(
                    width: 36, height: 36,
                    decoration: BoxDecoration(color: primary, shape: BoxShape.circle),
                    child: Icon(Icons.person, color: isDark ? Colors.black : Colors.white, size: 20),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    Text('Account Settings', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: primary)),
                    const SizedBox(height: 20),

                    // Profile card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(14)),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundColor: primary.withValues(alpha: 0.2),
                            child: Icon(Icons.person, color: primary, size: 24),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(_displayName, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: textColor), overflow: TextOverflow.ellipsis),
                                const SizedBox(height: 2),
                                Text(_userEmail, style: TextStyle(fontSize: 13, color: subText), overflow: TextOverflow.ellipsis),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Menu items
                    Container(
                      decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(14)),
                      child: Column(
                        children: [
                          _buildMenuItem(
                            context,
                            icon: Icons.person_outline,
                            label: 'Personal Information',
                            subText: subText,
                            textColor: textColor,
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PersonalInfoScreen())).then((_) => setState(() {})),
                          ),
                          _buildDivider(subText),
                          _buildMenuItem(
                            context,
                            icon: Icons.shield_outlined,
                            label: 'Privacy & Security',
                            subText: subText,
                            textColor: textColor,
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PrivacySecurityScreen())),
                          ),
                          _buildDivider(subText),
                          // Dark mode toggle inline
                          ListTile(
                            leading: Icon(Icons.dark_mode_outlined, color: subText, size: 22),
                            title: Text('Dark Mode', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: textColor)),
                            trailing: Switch(
                              value: isDark,
                              onChanged: (_) => context.read<ThemeNotifier>().toggle(),
                              activeThumbColor: const Color(0xFF2ECC71),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Log out
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.red.withValues(alpha: 0.3), width: 1),
                      ),
                      child: TextButton.icon(
                        onPressed: () async {
                          await FirebaseAuth.instance.signOut();
                          if (context.mounted) {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (_) => const LoginScreen()),
                              (route) => false,
                            );
                          }
                        },
                        icon: const Icon(Icons.logout, color: Colors.red),
                        label: const Text('Log Out', style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600)),
                      ),
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, {required IconData icon, required String label, required Color subText, required Color textColor, required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: subText, size: 22),
      title: Text(label, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: textColor)),
      trailing: Icon(Icons.chevron_right, color: subText, size: 20),
      onTap: onTap,
    );
  }

  Widget _buildDivider(Color subText) {
    return Divider(height: 1, thickness: 1, color: subText.withValues(alpha: 0.1), indent: 56);
  }
}

// ─── Personal Information ────────────────────────────────────────────────────

class PersonalInfoScreen extends StatefulWidget {
  const PersonalInfoScreen({super.key});
  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  bool _isSaving = false;
  String? _feedbackMessage;
  bool _isError = false;

  User? get _firebaseUser => FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    final user = _firebaseUser;
    _nameController = TextEditingController(text: user?.displayName ?? '');
    _emailController = TextEditingController(text: user?.email ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    final newName = _nameController.text.trim();
    final newEmail = _emailController.text.trim();
    final user = _firebaseUser;

    if (user == null) return;
    if (newName.isEmpty || newEmail.isEmpty) {
      setState(() { _feedbackMessage = 'Name and email cannot be empty.'; _isError = true; });
      return;
    }

    setState(() { _isSaving = true; _feedbackMessage = null; });

    try {
      if (newName != (user.displayName ?? '')) await user.updateDisplayName(newName);
      if (newEmail != user.email) {
        await user.verifyBeforeUpdateEmail(newEmail);
        setState(() {
          _feedbackMessage = 'A verification email has been sent to $newEmail. Please verify to complete the email change.';
          _isError = false;
          _isSaving = false;
        });
        return;
      }
      await user.reload();
      setState(() { _feedbackMessage = 'Changes saved successfully.'; _isError = false; });
    } on FirebaseAuthException catch (e) {
      setState(() { _feedbackMessage = e.message ?? 'An error occurred.'; _isError = true; });
    } catch (_) {
      setState(() { _feedbackMessage = 'An error occurred. Please try again.'; _isError = true; });
    } finally {
      setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeNotifier>().isDark;
    final primary = isDark ? const Color(0xFF2ECC71) : const Color(0xFF3B4A2F);
    final bg = isDark ? const Color(0xFF0D1B2A) : Colors.white;
    final cardBg = isDark ? const Color(0xFF132030) : const Color(0xFFF5F7F2);
    final textColor = isDark ? Colors.white : const Color(0xFF1A1A1A);
    final subText = isDark ? const Color(0xFF8A9BB0) : const Color(0xFF8A9070);

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context, 'Personal Information', primary),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(14)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInputField('Full Name', _nameController, bg: bg, textColor: textColor, subText: subText, keyboardType: TextInputType.name),
                      const SizedBox(height: 16),
                      _buildInputField('Email Address', _emailController, bg: bg, textColor: textColor, subText: subText, keyboardType: TextInputType.emailAddress),
                      const SizedBox(height: 24),

                      if (_feedbackMessage != null) ...[
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: _isError ? Colors.red.withValues(alpha: 0.1) : primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: _isError ? Colors.red.withValues(alpha: 0.4) : primary.withValues(alpha: 0.4)),
                          ),
                          child: Text(_feedbackMessage!, style: TextStyle(fontSize: 13, color: _isError ? Colors.red : primary)),
                        ),
                        const SizedBox(height: 16),
                      ],

                      SizedBox(
                        width: double.infinity, height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                          onPressed: _isSaving ? null : _saveChanges,
                          child: _isSaving
                              ? SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: isDark ? Colors.black : Colors.white))
                              : Text('Save Changes', style: TextStyle(color: isDark ? Colors.black : Colors.white, fontWeight: FontWeight.w600)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller, {required Color bg, required Color textColor, required Color subText, TextInputType keyboardType = TextInputType.text}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 13, color: subText, fontWeight: FontWeight.w500)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          style: TextStyle(color: textColor, fontSize: 15),
          keyboardType: keyboardType,
          decoration: InputDecoration(
            filled: true, fillColor: bg,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context, String title, Color primary) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          GestureDetector(onTap: () => Navigator.pop(context), child: Icon(Icons.chevron_left, color: primary, size: 28)),
          const SizedBox(width: 8),
          Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: primary)),
        ],
      ),
    );
  }
}

// ─── Privacy & Security ──────────────────────────────────────────────────────

class PrivacySecurityScreen extends StatefulWidget {
  const PrivacySecurityScreen({super.key});
  @override
  State<PrivacySecurityScreen> createState() => _PrivacySecurityScreenState();
}

class _PrivacySecurityScreenState extends State<PrivacySecurityScreen> {
  bool _anonymousReporting = true;

  void _showChangePasswordDialog(BuildContext context, bool isDark, Color primary, Color bg, Color cardBg, Color textColor, Color subText) {
    final currentCtrl = TextEditingController();
    final newCtrl = TextEditingController();
    final confirmCtrl = TextEditingController();
    bool isLoading = false;
    String? error;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(builder: (ctx, setDialogState) {
        return AlertDialog(
          backgroundColor: cardBg,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text('Change Password', style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _dialogField('Current Password', currentCtrl, obscure: true, bgColor: bg, textColor: textColor),
                const SizedBox(height: 12),
                _dialogField('New Password', newCtrl, obscure: true, bgColor: bg, textColor: textColor),
                const SizedBox(height: 12),
                _dialogField('Confirm New Password', confirmCtrl, obscure: true, bgColor: bg, textColor: textColor),
                if (error != null) ...[
                  const SizedBox(height: 10),
                  Text(error!, style: const TextStyle(color: Colors.red, fontSize: 13)),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: isLoading ? null : () => Navigator.pop(ctx),
              child: Text('Cancel', style: TextStyle(color: subText)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
              onPressed: isLoading ? null : () async {
                final current = currentCtrl.text.trim();
                final newPass = newCtrl.text.trim();
                final confirm = confirmCtrl.text.trim();

                if (current.isEmpty || newPass.isEmpty || confirm.isEmpty) { setDialogState(() => error = 'All fields are required.'); return; }
                if (newPass.length < 6) { setDialogState(() => error = 'New password must be at least 6 characters.'); return; }
                if (newPass != confirm) { setDialogState(() => error = 'Passwords do not match.'); return; }

                setDialogState(() { isLoading = true; error = null; });

                try {
                  final user = FirebaseAuth.instance.currentUser;
                  if (user == null || user.email == null) {
                    setDialogState(() { error = 'No authenticated user found.'; isLoading = false; });
                    return;
                  }
                  final credential = EmailAuthProvider.credential(email: user.email!, password: current);
                  await user.reauthenticateWithCredential(credential);
                  await user.updatePassword(newPass);
                  if (ctx.mounted) Navigator.pop(ctx);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const Text('Password updated successfully.'), backgroundColor: primary));
                  }
                } on FirebaseAuthException catch (e) {
                  setDialogState(() { error = e.message ?? 'Failed to update password.'; isLoading = false; });
                } catch (_) {
                  setDialogState(() { error = 'An error occurred. Please try again.'; isLoading = false; });
                }
              },
              child: isLoading
                  ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : Text('Update', style: TextStyle(color: isDark ? Colors.black : Colors.white)),
            ),
          ],
        );
      }),
    );
  }

  Widget _dialogField(String hint, TextEditingController ctrl, {bool obscure = false, required Color bgColor, required Color textColor}) {
    return TextField(
      controller: ctrl, obscureText: obscure,
      style: TextStyle(color: textColor, fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: textColor.withValues(alpha: 0.4)),
        filled: true, fillColor: bgColor,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeNotifier>().isDark;
    final primary = isDark ? const Color(0xFF2ECC71) : const Color(0xFF3B4A2F);
    final bg = isDark ? const Color(0xFF0D1B2A) : Colors.white;
    final cardBg = isDark ? const Color(0xFF132030) : const Color(0xFFF5F7F2);
    final textColor = isDark ? Colors.white : const Color(0xFF1A1A1A);
    final subText = isDark ? const Color(0xFF8A9BB0) : const Color(0xFF8A9070);

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context, 'Privacy & Security', primary),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionLabel('SECURITY', subText),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(14)),
                    child: ListTile(
                      leading: Icon(Icons.lock_outline, color: subText, size: 22),
                      title: Text('Change Password', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: textColor)),
                      subtitle: Text('Update your account password', style: TextStyle(fontSize: 12, color: subText)),
                      trailing: Icon(Icons.chevron_right, color: subText, size: 20),
                      onTap: () => _showChangePasswordDialog(context, isDark, primary, bg, cardBg, textColor, subText),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildSectionLabel('PRIVACY', subText),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(14)),
                    child: ListTile(
                      leading: Icon(Icons.visibility_off_outlined, color: subText, size: 22),
                      title: Text('Anonymous Reporting', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: textColor)),
                      subtitle: Text('Hide your name on public reports', style: TextStyle(fontSize: 12, color: subText)),
                      trailing: Switch(value: _anonymousReporting, onChanged: (v) => setState(() => _anonymousReporting = v), activeThumbColor: const Color(0xFF2ECC71)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String label, Color subText) {
    return Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: subText, letterSpacing: 1));
  }

  Widget _buildHeader(BuildContext context, String title, Color primary) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          GestureDetector(onTap: () => Navigator.pop(context), child: Icon(Icons.chevron_left, color: primary, size: 28)),
          const SizedBox(width: 8),
          Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: primary)),
        ],
      ),
    );
  }
}