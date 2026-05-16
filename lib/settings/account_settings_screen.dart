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
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: _primary.withValues(alpha: 0.2),
                    child: Text(
                      'US',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: _primary,
                      ),
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

                    // Profile card
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
                            child: Text(
                              'US',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: _primary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'User Settings',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: _textColor,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'user@example.com',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: _subText,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Menu items
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
                            ),
                          ),
                          _buildDivider(),
                          _buildMenuItem(
                            context,
                            icon: Icons.notifications_outlined,
                            label: 'Notifications',
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => NotificationsScreen(
                                    isDark: widget.isDark,
                                    onToggle: widget.onToggle),
                              ),
                            ),
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
  final _nameController =
      TextEditingController(text: 'User Settings');
  final _emailController =
      TextEditingController(text: 'user@example.com');
  final _phoneController =
      TextEditingController(text: '+1 (555) 000-0000');

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
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
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
                      _buildInputField('Full Name', _nameController),
                      const SizedBox(height: 16),
                      _buildInputField('Email Address', _emailController),
                      const SizedBox(height: 16),
                      _buildInputField('Phone Number', _phoneController),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _primary,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          onPressed: () => Navigator.pop(context),
                          child: Text(
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

  Widget _buildInputField(String label, TextEditingController controller) {
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

// ─── Notifications ──────────────────────────────────────────────────────────

class NotificationsScreen extends StatefulWidget {
  final bool isDark;
  final VoidCallback onToggle;
  const NotificationsScreen(
      {super.key, required this.isDark, required this.onToggle});
  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool _push = true;
  bool _issueUpdates = true;
  bool _emailDigest = false;

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
            _buildHeader(context, 'Notifications'),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                decoration: BoxDecoration(
                  color: _cardBg,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  children: [
                    _buildToggle(
                      'Push Notifications',
                      'Receive alerts on your device',
                      Icons.notifications_outlined,
                      _push,
                      (v) => setState(() => _push = v),
                    ),
                    _buildDivider(),
                    _buildToggle(
                      'Issue Updates',
                      'When your reports are resolved',
                      Icons.notifications_active_outlined,
                      _issueUpdates,
                      (v) => setState(() => _issueUpdates = v),
                    ),
                    _buildDivider(),
                    _buildToggle(
                      'Email Digest',
                      'Weekly community summary',
                      Icons.chat_bubble_outline,
                      _emailDigest,
                      (v) => setState(() => _emailDigest = v),
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

  Widget _buildToggle(String title, String subtitle, IconData icon, bool value,
      ValueChanged<bool> onChanged) {
    return ListTile(
      leading: Icon(icon, color: _subText, size: 22),
      title: Text(title,
          style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: _textColor)),
      subtitle:
          Text(subtitle, style: TextStyle(fontSize: 12, color: _subText)),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeThumbColor: const Color(0xFF2ECC71),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
        height: 1, thickness: 1, color: _subText.withValues(alpha: 0.1), indent: 56);
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
  bool _twoFactor = false;
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
                    child: Column(
                      children: [
                        ListTile(
                          leading:
                              Icon(Icons.lock_outline, color: _subText, size: 22),
                          title: Text('Change Password',
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: _textColor)),
                          subtitle: Text('Update your account password',
                              style:
                                  TextStyle(fontSize: 12, color: _subText)),
                          trailing: Icon(Icons.chevron_right,
                              color: _subText, size: 20),
                          onTap: () {},
                        ),
                        Divider(
                            height: 1,
                            thickness: 1,
                            color: _subText.withValues(alpha: 0.1),
                            indent: 56),
                        ListTile(
                          leading: Icon(Icons.security_outlined,
                              color: _subText, size: 22),
                          title: Text('Two-Factor Auth',
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: _textColor)),
                          subtitle: Text('Add an extra layer of security',
                              style:
                                  TextStyle(fontSize: 12, color: _subText)),
                          trailing: Switch(
                            value: _twoFactor,
                            onChanged: (v) =>
                                setState(() => _twoFactor = v),
                            activeThumbColor: const Color(0xFF2ECC71),
                          ),
                        ),
                      ],
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
                          onTap: () {},
                        ),
                        Divider(
                            height: 1,
                            thickness: 1,
                            color: _subText.withValues(alpha: 0.1),
                            indent: 56),
                        ListTile(
                          leading: Icon(Icons.notifications_outlined,
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