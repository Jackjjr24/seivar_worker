import 'package:flutter/material.dart';
import 'work.dart' as data;
import 'data.dart' as dashboard;
import 'main.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: Column(
          children: [
            // Header with gradient
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF2C3E50), Color(0xFF34495E)],
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF2C3E50).withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.person_rounded,
                            size: 32,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Username",
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                "Manage your account",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Scrollable content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Account Section
                      _sectionTitle("Account", Icons.person_outline),
                      const SizedBox(height: 12),
                      _settingsCard([
                        _settingsTile(Icons.edit_rounded, "Edit profile", context),
                        _settingsTile(Icons.shield_outlined, "Security", context),
                        _settingsTile(Icons.notifications_none_rounded, "Notifications", context),
                        _settingsTile(Icons.lock_outline_rounded, "Privacy", context),
                      ]),
                      const SizedBox(height: 20),

                      // Support & About Section
                      _sectionTitle("Support & About", Icons.help_outline_rounded),
                      const SizedBox(height: 12),
                      _settingsCard([
                        _settingsTile(Icons.subscriptions_outlined, "My Subscription", context),
                        _settingsTile(Icons.help_outline_rounded, "Help & Support", context),
                        _settingsTile(Icons.info_outline_rounded, "Terms and Policies", context),
                      ]),
                      const SizedBox(height: 20),

                      // Data and Security Section
                      _sectionTitle("Data and security", Icons.security_rounded),
                      const SizedBox(height: 12),
                      _settingsCard([
                        _settingsTile(Icons.delete_outline_rounded, "Delete my account", context),
                        _settingsTile(Icons.message_rounded, "Whatsapp notifications", context),
                      ]),
                      const SizedBox(height: 20),

                      // Actions Section
                      _sectionTitle("Actions", Icons.settings_suggest_rounded),
                      const SizedBox(height: 12),
                      _settingsCard([
                        _settingsTile(Icons.flag_outlined, "Report a problem", context),
                        _settingsTile(Icons.summarize_outlined, "Account summary", context),
                        ListTile(
                          leading: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.logout_rounded, color: Colors.red, size: 20),
                          ),
                          title: const Text(
                            "Log out",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.red,
                            ),
                          ),
                          trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.red),
                          onTap: () {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => IntroPage()),
                              (Route<dynamic> route) => false,
                            );
                          },
                        ),
                      ]),

                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ],
          ),
      ),
      bottomNavigationBar: _buildFooter(context),
    );
  }

  Widget _sectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF2C3E50), Color(0xFF34495E)],
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: Colors.white, size: 18),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF2C3E50),
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _settingsCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _settingsTile(IconData icon, String text, BuildContext context) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFF5DADE2).withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: const Color(0xFF5DADE2), size: 20),
      ),
      title: Text(
        text,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey),
      onTap: () {},
    );
  }

  Widget _buildFooterIcon({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFF2C3E50).withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          size: 26,
          color: const Color(0xFF2C3E50),
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return BottomAppBar(
      color: Colors.white,
      elevation: 8,
      shape: const CircularNotchedRectangle(),
      notchMargin: 8,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildFooterIcon(
              icon: Icons.calendar_today_rounded,
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => data.TodaysWorkPage()),
                );
              },
            ),
            _buildFooterIcon(
              icon: Icons.home_rounded,
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => dashboard.DashboardScreen()),
                );
              },
            ),
            _buildFooterIcon(
              icon: Icons.settings_rounded,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
