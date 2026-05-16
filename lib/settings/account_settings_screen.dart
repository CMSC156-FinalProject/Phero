import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../auth/login_screen.dart';

class AccountSettingsScreen extends StatefulWidget {
  final bool isDark;
  final VoidCallback onToggle;

  const AccountSettingsScreen(
      {super.key, required this.isDark, required this.onToggle});

  @override
  State<AccountSettingsScreen> createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  Color get _primary =>
      widget.isDark ? const Color(0xFF2ECC71) : const Color(0xFF3B4A2F);
  Color get _bg => widget.isDark ? const Color(0xFF0D1B2A) : Colors.white;
  Color get _cardBg =>
      widget.isDark ? const Color(0xFF132030) : const Color(0xFFF5F7F2);
  Color get _textColor =>
      widget.isDark ? Colors.white : const Color(0xFF1A1A1A);
  Color get _subText =>
      widget.isDark ? const Color(0xFF8A9BB0) : const Color(0xFF8A9070);

  User? get _firebaseUser => FirebaseAuth.instance.currentUser;

  String get _displayName {
    final u = _firebaseUser;
    if (u == null) return 'User';
    if (u.displayName != null && u.displayName!.trim().isNotEmpty) {
      return u.displayName!;
    }
    return u.email?.split('@').first ?? 'User';
  }

  String get _userEmail => _firebaseUser?.email ?? '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'phero.',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: _primary,
                    ),
                  ),
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: _primary,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.person,
                      color: widget.isDark ? Colors.black : Colors.white,
                      size: 20,
                    ),
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
                    Text(
                      'Account Settings',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: _primary,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Profile card — real user name & email
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: _cardBg,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundColor: _primary.withValues(alpha: 0.2),
                            child: Icon(
                              Icons.person,
                              color: _primary,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _displayName,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: _textColor,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  _userEmail,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: _subText,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Menu items — Notifications removed
                    Container(
                      decoration: BoxDecoration(
                        color: _cardBg,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Column(
                        children: [
                          _buildMenuItem(
                            context,
                            icon: Icons.person_outline,
                            label: 'Personal Information',
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => PersonalInfoScreen(
                                    isDark: widget.isDark,
                                    onToggle: widget.onToggle),
                              ),
                            ).then((_) => setState(() {})),
                          ),
                          _buildDivider(),
                          _buildMenuItem(
                            context,
                            icon: Icons.shield_outlined,
                            label: 'Privacy & Security',
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => PrivacySecurityScreen(
                                    isDark: widget.isDark,
                                    onToggle: widget.onToggle),
                              ),
                            ),
                          ),
                          _buildDivider(),
                          _buildMenuItem(
                            context,
                            icon: Icons.settings_outlined,
                            label: 'App Preferences',
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => AppPreferencesScreen(
                                    isDark: widget.isDark,
                                    onToggle: widget.onToggle),
                              ),
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
                        color: _cardBg,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                            color: Colors.red.withValues(alpha: 0.3), width: 1),
                      ),
                      child: TextButton.icon(
                        onPressed: () async {
                          await FirebaseAuth.instance.signOut();
                          if (context.mounted) {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (_) => LoginScreen(
                                  isDark: widget.isDark,
                                  onToggle: widget.onToggle,
                                ),
                              ),
                              (route) => false,
                            );
                          }
                        },
                        icon: const Icon(Icons.logout, color: Colors.red),
                        label: const Text(
                          'Log Out',
                          style: TextStyle(
                              color: Colors.red, fontWeight: FontWeight.w600),
                        ),
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

  Widget _buildMenuItem(BuildContext context,
      {required IconData icon,
      required String label,
      required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: _subText, size: 22),
      title: Text(label,
          style: TextStyle(
              fontSize: 15, fontWeight: FontWeight.w500, color: _textColor)),
      trailing: Icon(Icons.chevron_right, color: _subText, size: 20),
      onTap: onTap,
    );
  }

  Widget _buildDivider() {
    return Divider(
        height: 1, thickness: 1, color: _subText.withValues(alpha: 0.1), indent: 56);
  }
}

// ─── Personal Information ───────────────────────────────────────────────────

class PersonalInfoScreen extends StatefulWidget {
  final bool isDark;
  final VoidCallback onToggle;
  const PersonalInfoScreen(
      {super.key, required this.isDark, required this.onToggle});
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

  Color get _primary =>
      widget.isDark ? const Color(0xFF2ECC71) : const Color(0xFF3B4A2F);
  Color get _bg => widget.isDark ? const Color(0xFF0D1B2A) : Colors.white;
  Color get _cardBg =>
      widget.isDark ? const Color(0xFF132030) : const Color(0xFFF5F7F2);
  Color get _textColor =>
      widget.isDark ? Colors.white : const Color(0xFF1A1A1A);
  Color get _subText =>
      widget.isDark ? const Color(0xFF8A9BB0) : const Color(0xFF8A9070);

  @override
  void initState() {
    super.initState();
    final user = _firebaseUser;
    _nameController = TextEditingController(
      text: user?.displayName ?? '',
    );
    _emailController = TextEditingController(
      text: user?.email ?? '',
    );
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
      setState(() {
        _feedbackMessage = 'Name and email cannot be empty.';
        _isError = true;
      });
      return;
    }

    setState(() {
      _isSaving = true;
      _feedbackMessage = null;
    });

    try {
      if (newName != (user.displayName ?? '')) {
        await user.updateDisplayName(newName);
      }

      if (newEmail != user.email) {
        await user.verifyBeforeUpdateEmail(newEmail);
        setState(() {
          _feedbackMessage =
              'A verification email has been sent to $newEmail. Please verify to complete the email change.';
          _isError = false;
          _isSaving = false;
        });
        return;
      }

      await user.reload();
      setState(() {
        _feedbackMessage = 'Changes saved successfully.';
        _isError = false;
      });
    } on FirebaseAuthException catch (e) {
      setState(() {
        _feedbackMessage = e.message ?? 'An error occurred. Please try again.';
        _isError = true;
      });
    } catch (e) {
      setState(() {
        _feedbackMessage = 'An error occurred. Please try again.';
        _isError = true;
      });
    } finally {
      setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context, 'Personal Information'),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: _cardBg,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInputField('Full Name', _nameController,
                          keyboardType: TextInputType.name),
                      const SizedBox(height: 16),
                      _buildInputField('Email Address', _emailController,
                          keyboardType: TextInputType.emailAddress),
                      const SizedBox(height: 24),

                      if (_feedbackMessage != null) ...[
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: _isError
                                ? Colors.red.withValues(alpha: 0.1)
                                : _primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: _isError
                                  ? Colors.red.withValues(alpha: 0.4)
                                  : _primary.withValues(alpha: 0.4),
                            ),
                          ),
                          child: Text(
                            _feedbackMessage!,
                            style: TextStyle(
                              fontSize: 13,
                              color: _isError ? Colors.red : _primary,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],

                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _primary,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          onPressed: _isSaving ? null : _saveChanges,
                          child: _isSaving
                              ? SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: widget.isDark
                                        ? Colors.black
                                        : Colors.white,
                                  ),
                                )
                              : Text(
                                  'Save Changes',
                                  style: TextStyle(
                                    color: widget.isDark
                                        ? Colors.black
                                        : Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
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

  Widget _buildInputField(String label, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
                fontSize: 13,
                color: _subText,
                fontWeight: FontWeight.w500)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          style: TextStyle(color: _textColor, fontSize: 15),
          keyboardType: keyboardType,
          decoration: InputDecoration(
            filled: true,
            fillColor: _bg,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(Icons.chevron_left, color: _primary, size: 28),
          ),
          const SizedBox(width: 8),
          Text(title,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: _primary)),
        ],
      ),
    );
  }
}

// ─── Privacy & Security ─────────────────────────────────────────────────────

class PrivacySecurityScreen extends StatefulWidget {
  final bool isDark;
  final VoidCallback onToggle;
  const PrivacySecurityScreen(
      {super.key, required this.isDark, required this.onToggle});
  @override
  State<PrivacySecurityScreen> createState() => _PrivacySecurityScreenState();
}

class _PrivacySecurityScreenState extends State<PrivacySecurityScreen> {
  bool _anonymousReporting = true;

  Color get _primary =>
      widget.isDark ? const Color(0xFF2ECC71) : const Color(0xFF3B4A2F);
  Color get _bg => widget.isDark ? const Color(0xFF0D1B2A) : Colors.white;
  Color get _cardBg =>
      widget.isDark ? const Color(0xFF132030) : const Color(0xFFF5F7F2);
  Color get _textColor =>
      widget.isDark ? Colors.white : const Color(0xFF1A1A1A);
  Color get _subText =>
      widget.isDark ? const Color(0xFF8A9BB0) : const Color(0xFF8A9070);

  void _showChangePasswordDialog() {
    final currentCtrl = TextEditingController();
    final newCtrl = TextEditingController();
    final confirmCtrl = TextEditingController();
    bool isLoading = false;
    String? error;

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(builder: (ctx, setDialogState) {
          return AlertDialog(
            backgroundColor: _cardBg,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: Text('Change Password',
                style: TextStyle(
                    color: _textColor, fontWeight: FontWeight.bold)),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _dialogField('Current Password', currentCtrl,
                      obscure: true, bgColor: _bg, textColor: _textColor),
                  const SizedBox(height: 12),
                  _dialogField('New Password', newCtrl,
                      obscure: true, bgColor: _bg, textColor: _textColor),
                  const SizedBox(height: 12),
                  _dialogField('Confirm New Password', confirmCtrl,
                      obscure: true, bgColor: _bg, textColor: _textColor),
                  if (error != null) ...[
                    const SizedBox(height: 10),
                    Text(error!,
                        style: const TextStyle(
                            color: Colors.red, fontSize: 13)),
                  ],
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: isLoading ? null : () => Navigator.pop(ctx),
                child: Text('Cancel', style: TextStyle(color: _subText)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: isLoading
                    ? null
                    : () async {
                        final current = currentCtrl.text.trim();
                        final newPass = newCtrl.text.trim();
                        final confirm = confirmCtrl.text.trim();

                        if (current.isEmpty || newPass.isEmpty || confirm.isEmpty) {
                          setDialogState(() => error = 'All fields are required.');
                          return;
                        }
                        if (newPass.length < 6) {
                          setDialogState(() =>
                              error = 'New password must be at least 6 characters.');
                          return;
                        }
                        if (newPass != confirm) {
                          setDialogState(() => error = 'Passwords do not match.');
                          return;
                        }

                        setDialogState(() {
                          isLoading = true;
                          error = null;
                        });

                        try {
                          final user = FirebaseAuth.instance.currentUser;
                          if (user == null || user.email == null) {
                            setDialogState(() {
                              error = 'No authenticated user found.';
                              isLoading = false;
                            });
                            return;
                          }

                          final credential = EmailAuthProvider.credential(
                            email: user.email!,
                            password: current,
                          );
                          await user.reauthenticateWithCredential(credential);
                          await user.updatePassword(newPass);

                          if (ctx.mounted) Navigator.pop(ctx);

                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text('Password updated successfully.'),
                                backgroundColor: _primary,
                              ),
                            );
                          }
                        } on FirebaseAuthException catch (e) {
                          setDialogState(() {
                            error = e.message ?? 'Failed to update password.';
                            isLoading = false;
                          });
                        } catch (_) {
                          setDialogState(() {
                            error = 'An error occurred. Please try again.';
                            isLoading = false;
                          });
                        }
                      },
                child: isLoading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white))
                    : Text('Update',
                        style: TextStyle(
                            color: widget.isDark ? Colors.black : Colors.white)),
              ),
            ],
          );
        });
      },
    );
  }

  Widget _dialogField(String hint, TextEditingController ctrl,
      {bool obscure = false,
      required Color bgColor,
      required Color textColor}) {
    return TextField(
      controller: ctrl,
      obscureText: obscure,
      style: TextStyle(color: textColor, fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: textColor.withValues(alpha: 0.4)),
        filled: true,
        fillColor: bgColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context, 'Privacy & Security'),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionLabel('SECURITY'),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: _cardBg,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: ListTile(
                      leading:
                          Icon(Icons.lock_outline, color: _subText, size: 22),
                      title: Text('Change Password',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: _textColor)),
                      subtitle: Text('Update your account password',
                          style: TextStyle(fontSize: 12, color: _subText)),
                      trailing:
                          Icon(Icons.chevron_right, color: _subText, size: 20),
                      onTap: _showChangePasswordDialog,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildSectionLabel('PRIVACY'),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: _cardBg,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: ListTile(
                      leading: Icon(Icons.visibility_off_outlined,
                          color: _subText, size: 22),
                      title: Text('Anonymous Reporting',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: _textColor)),
                      subtitle: Text('Hide your name on public reports',
                          style: TextStyle(fontSize: 12, color: _subText)),
                      trailing: Switch(
                        value: _anonymousReporting,
                        onChanged: (v) =>
                            setState(() => _anonymousReporting = v),
                        activeThumbColor: const Color(0xFF2ECC71),
                      ),
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

  Widget _buildSectionLabel(String label) {
    return Text(label,
        style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: _subText,
            letterSpacing: 1));
  }

  Widget _buildHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(Icons.chevron_left, color: _primary, size: 28),
          ),
          const SizedBox(width: 8),
          Text(title,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: _primary)),
        ],
      ),
    );
  }
}

// ─── App Preferences ────────────────────────────────────────────────────────

class AppPreferencesScreen extends StatefulWidget {
  final bool isDark;
  final VoidCallback onToggle;
  const AppPreferencesScreen(
      {super.key, required this.isDark, required this.onToggle});
  @override
  State<AppPreferencesScreen> createState() => _AppPreferencesScreenState();
}

class _AppPreferencesScreenState extends State<AppPreferencesScreen> {
  bool _inAppSounds = true;

  Color get _primary =>
      widget.isDark ? const Color(0xFF2ECC71) : const Color(0xFF3B4A2F);
  Color get _bg => widget.isDark ? const Color(0xFF0D1B2A) : Colors.white;
  Color get _cardBg =>
      widget.isDark ? const Color(0xFF132030) : const Color(0xFFF5F7F2);
  Color get _textColor =>
      widget.isDark ? Colors.white : const Color(0xFF1A1A1A);
  Color get _subText =>
      widget.isDark ? const Color(0xFF8A9BB0) : const Color(0xFF8A9070);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context, 'App Preferences'),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionLabel('DISPLAY'),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: _cardBg,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: ListTile(
                      leading: Icon(Icons.dark_mode_outlined,
                          color: _subText, size: 22),
                      title: Text('Dark Mode',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: _textColor)),
                      subtitle: Text('Toggle dark appearance',
                          style: TextStyle(fontSize: 12, color: _subText)),
                      trailing: Switch(
                        value: widget.isDark,
                        onChanged: (_) => widget.onToggle(),
                        activeThumbColor: const Color(0xFF2ECC71),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildSectionLabel('GENERAL'),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: _cardBg,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          leading: Icon(Icons.language_outlined,
                              color: _subText, size: 22),
                          title: Text('Language',
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: _textColor)),
                          subtitle: Text('English (US)',
                              style:
                                  TextStyle(fontSize: 12, color: _subText)),
                          trailing: Icon(Icons.chevron_right,
                              color: _subText, size: 20),
                          onTap: () => _showLanguageSheet(context),
                        ),
                        Divider(
                            height: 1,
                            thickness: 1,
                            color: _subText.withValues(alpha: 0.1),
                            indent: 56),
                        ListTile(
                          leading: Icon(Icons.music_note_outlined,
                              color: _subText, size: 22),
                          title: Text('In-App Sounds',
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: _textColor)),
                          subtitle: Text('Play sounds for alerts',
                              style:
                                  TextStyle(fontSize: 12, color: _subText)),
                          trailing: Switch(
                            value: _inAppSounds,
                            onChanged: (v) =>
                                setState(() => _inAppSounds = v),
                            activeThumbColor: const Color(0xFF2ECC71),
                          ),
                        ),
                      ],
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

  void _showLanguageSheet(BuildContext context) {
    final languages = ['English (US)', 'Filipino', 'Español', 'Français'];
    showModalBottomSheet(
      context: context,
      backgroundColor: _cardBg,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Text('Select Language',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: _textColor)),
            ),
            ...languages.map(
              (lang) => ListTile(
                title: Text(lang,
                    style: TextStyle(color: _textColor, fontSize: 15)),
                trailing: lang == 'English (US)'
                    ? Icon(Icons.check, color: _primary)
                    : null,
                onTap: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Text(label,
        style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: _subText,
            letterSpacing: 1));
  }

  Widget _buildHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(Icons.chevron_left, color: _primary, size: 28),
          ),
          const SizedBox(width: 8),
          Text(title,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: _primary)),
        ],
      ),
    );
  }
}