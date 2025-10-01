import 'package:flutter/material.dart';
import 'app_theme.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool darkModeEnabled = true;
  bool notificationsEnabled = true;
  bool locationEnabled = true;
  bool voiceEnabled = true;
  bool biometricEnabled = false;
  bool autoBackupEnabled = true;
  String selectedTheme = 'Dark Blue';
  String selectedLanguage = 'English';

  final List<String> themes = ['Dark Blue', 'Dark Green', 'Dark Purple', 'Classic Dark'];
  final List<String> languages = ['English', 'Hindi', 'Tamil', 'Telugu', 'Marathi', 'Bengali'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // App Bar
            SliverAppBar(
              expandedHeight: 120,
              floating: false,
              pinned: true,
              backgroundColor: AppTheme.backgroundBlue,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  'Settings',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppTheme.textSecondary.withOpacity(0.8),
                        AppTheme.accentBlue.withOpacity(0.6),
                        AppTheme.primaryBlue.withOpacity(0.4),
                      ],
                    ),
                  ),
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.help_outline_rounded),
                  onPressed: () {
                    _showHelpDialog();
                  },
                ),
              ],
            ),

            // Main Content
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // Profile Section
                  _buildProfileSection(),
                  const SizedBox(height: 24),

                  // App Settings
                  _buildSettingsSection(
                    'App Settings',
                    Icons.settings_rounded,
                    [
                      _buildSwitchSetting(
                        'Dark Mode',
                        'Use dark theme for better battery life',
                        Icons.dark_mode_rounded,
                        darkModeEnabled,
                            (value) => setState(() => darkModeEnabled = value),
                      ),
                      _buildDropdownSetting(
                        'Theme Color',
                        'Choose your preferred color scheme',
                        Icons.palette_rounded,
                        selectedTheme,
                        themes,
                            (value) => setState(() => selectedTheme = value!),
                      ),
                      _buildDropdownSetting(
                        'Language',
                        'Select your preferred language',
                        Icons.language_rounded,
                        selectedLanguage,
                        languages,
                            (value) => setState(() => selectedLanguage = value!),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Device Settings
                  _buildSettingsSection(
                    'Device Settings',
                    Icons.devices_rounded,
                    [
                      _buildSwitchSetting(
                        'Auto Discovery',
                        'Automatically discover new devices',
                        Icons.radar_rounded,
                        true,
                            (value) {},
                      ),
                      _buildSwitchSetting(
                        'Device Sync',
                        'Sync device states across all platforms',
                        Icons.sync_rounded,
                        true,
                            (value) {},
                      ),
                      _buildActionSetting(
                        'Device Management',
                        'Add, remove, and configure devices',
                        Icons.device_hub_rounded,
                            () => _showDeviceManagement(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Privacy & Security
                  _buildSettingsSection(
                    'Privacy & Security',
                    Icons.security_rounded,
                    [
                      _buildSwitchSetting(
                        'Biometric Lock',
                        'Use fingerprint or face unlock',
                        Icons.fingerprint_rounded,
                        biometricEnabled,
                            (value) => setState(() => biometricEnabled = value),
                      ),
                      _buildSwitchSetting(
                        'Location Services',
                        'Allow location access for automation',
                        Icons.location_on_rounded,
                        locationEnabled,
                            (value) => setState(() => locationEnabled = value),
                      ),
                      _buildActionSetting(
                        'Privacy Policy',
                        'View our privacy policy',
                        Icons.privacy_tip_rounded,
                            () => _showPrivacyPolicy(),
                      ),
                      _buildActionSetting(
                        'Data Export',
                        'Export your data',
                        Icons.download_rounded,
                            () => _exportData(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Notifications
                  _buildSettingsSection(
                    'Notifications',
                    Icons.notifications_rounded,
                    [
                      _buildSwitchSetting(
                        'Push Notifications',
                        'Receive device and security alerts',
                        Icons.notifications_active_rounded,
                        notificationsEnabled,
                            (value) => setState(() => notificationsEnabled = value),
                      ),
                      _buildSwitchSetting(
                        'Energy Alerts',
                        'Get notified about energy usage',
                        Icons.bolt_rounded,
                        true,
                            (value) {},
                      ),
                      _buildSwitchSetting(
                        'Security Alerts',
                        'Immediate security notifications',
                        Icons.warning_rounded,
                        true,
                            (value) {},
                      ),
                      _buildActionSetting(
                        'Notification Settings',
                        'Customize notification preferences',
                        Icons.tune_rounded,
                            () => _showNotificationSettings(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Voice & AI
                  _buildSettingsSection(
                    'Voice & AI',
                    Icons.mic_rounded,
                    [
                      _buildSwitchSetting(
                        'Voice Assistant',
                        'Enable voice commands',
                        Icons.record_voice_over_rounded,
                        voiceEnabled,
                            (value) => setState(() => voiceEnabled = value),
                      ),
                      _buildSwitchSetting(
                        'AI Learning',
                        'Allow AI to learn your patterns',
                        Icons.psychology_rounded,
                        true,
                            (value) {},
                      ),
                      _buildActionSetting(
                        'Voice Training',
                        'Improve voice recognition',
                        Icons.school_rounded,
                            () => _showVoiceTraining(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Backup & Sync
                  _buildSettingsSection(
                    'Backup & Sync',
                    Icons.cloud_rounded,
                    [
                      _buildSwitchSetting(
                        'Auto Backup',
                        'Automatically backup settings',
                        Icons.backup_rounded,
                        autoBackupEnabled,
                            (value) => setState(() => autoBackupEnabled = value),
                      ),
                      _buildActionSetting(
                        'Backup Now',
                        'Create manual backup',
                        Icons.cloud_upload_rounded,
                            () => _createBackup(),
                      ),
                      _buildActionSetting(
                        'Restore Backup',
                        'Restore from previous backup',
                        Icons.cloud_download_rounded,
                            () => _restoreBackup(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Support & Info
                  _buildSettingsSection(
                    'Support & Information',
                    Icons.help_rounded,
                    [
                      _buildActionSetting(
                        'Help Center',
                        'Get help and tutorials',
                        Icons.help_center_rounded,
                            () => _showHelpCenter(),
                      ),
                      _buildActionSetting(
                        'Contact Support',
                        'Get technical support',
                        Icons.support_agent_rounded,
                            () => _contactSupport(),
                      ),
                      _buildActionSetting(
                        'Rate App',
                        'Rate us on the app store',
                        Icons.star_rounded,
                            () => _rateApp(),
                      ),
                      _buildActionSetting(
                        'About',
                        'App version and information',
                        Icons.info_rounded,
                            () => _showAbout(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Advanced Settings
                  _buildSettingsSection(
                    'Advanced',
                    Icons.admin_panel_settings_rounded,
                    [
                      _buildActionSetting(
                        'Developer Options',
                        'Advanced debugging options',
                        Icons.developer_mode_rounded,
                            () => _showDeveloperOptions(),
                      ),
                      _buildActionSetting(
                        'Network Settings',
                        'Configure network preferences',
                        Icons.network_check_rounded,
                            () => _showNetworkSettings(),
                      ),
                      _buildActionSetting(
                        'Reset App',
                        'Reset all settings to default',
                        Icons.restore_rounded,
                            () => _showResetDialog(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 100), // Extra space for FAB
                ]),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showUserProfile();
        },
        backgroundColor: AppTheme.accentGreen,
        icon: const Icon(Icons.person_rounded),
        label: const Text('Profile'),
      ),
    );
  }

  Widget _buildProfileSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: AppTheme.accentGreen.withOpacity(0.2),
              child: const Icon(
                Icons.person_rounded,
                size: 32,
                color: AppTheme.accentGreen,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Smart Home User',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'smarthome@example.com',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.accentGreen.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Premium Member',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.accentGreen,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () => _showUserProfile(),
              icon: const Icon(Icons.edit_rounded),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsSection(String title, IconData icon, List<Widget> children) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: AppTheme.accentBlue, size: 24),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchSetting(
      String title,
      String subtitle,
      IconData icon,
      bool value,
      ValueChanged<bool> onChanged,
      ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.accentBlue.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppTheme.accentBlue, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppTheme.accentGreen,
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownSetting(
      String title,
      String subtitle,
      IconData icon,
      String value,
      List<String> options,
      ValueChanged<String?> onChanged,
      ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.accentBlue.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppTheme.accentBlue, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: AppTheme.cardBlue,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppTheme.accentBlue.withOpacity(0.3)),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: value,
                dropdownColor: AppTheme.cardBlue,
                style: Theme.of(context).textTheme.bodyMedium,
                items: options.map((option) {
                  return DropdownMenuItem(
                    value: option,
                    child: Text(option),
                  );
                }).toList(),
                onChanged: onChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionSetting(
      String title,
      String subtitle,
      IconData icon,
      VoidCallback onTap,
      ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.accentBlue.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: AppTheme.accentBlue, size: 20),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: AppTheme.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Action Methods
  void _showUserProfile() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: AppTheme.surfaceBlue,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'User Profile',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 24),
              const Text('Profile management will be implemented in the full version.'),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeviceManagement() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const DeviceManagementPage(),
      ),
    );
  }

  void _showNotificationSettings() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceBlue,
        title: const Text('Notification Settings'),
        content: const Text('Detailed notification settings will be available in the full version.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showVoiceTraining() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceBlue,
        title: const Text('Voice Training'),
        content: const Text('Voice training module will be available in the full version.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _createBackup() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Backup created successfully'),
        backgroundColor: AppTheme.accentGreen,
      ),
    );
  }

  void _restoreBackup() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceBlue,
        title: const Text('Restore Backup'),
        content: const Text('Are you sure you want to restore from backup? This will overwrite current settings.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Backup restored successfully'),
                  backgroundColor: AppTheme.accentGreen,
                ),
              );
            },
            child: const Text('Restore'),
          ),
        ],
      ),
    );
  }

  void _showHelpCenter() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceBlue,
        title: const Text('Help Center'),
        content: const Text('Help center with tutorials and FAQs will be available in the full version.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _contactSupport() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceBlue,
        title: const Text('Contact Support'),
        content: const Text('Support contact options will be available in the full version.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _rateApp() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceBlue,
        title: const Text('Rate Our App'),
        content: const Text('Thank you for using Smart Home AI! Rating functionality will be available in the published version.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showAbout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceBlue,
        title: const Text('About Smart Home AI'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Version: 1.0.0'),
            Text('Build: Demo'),
            Text(''),
            Text('Smart Home AI is an intelligent home automation platform designed specifically for Indian households.'),
            Text(''),
            Text('Features:'),
            Text('• Device Control & Automation'),
            Text('• Energy Management & Solar Integration'),
            Text('• Security Monitoring'),
            Text('• Multilingual Voice Assistant'),
            Text('• AI-Powered Learning'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showDeveloperOptions() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceBlue,
        title: const Text('Developer Options'),
        content: const Text('Developer options and debugging tools will be available in the full version.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showNetworkSettings() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceBlue,
        title: const Text('Network Settings'),
        content: const Text('Network configuration options will be available in the full version.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showResetDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceBlue,
        title: const Text('Reset App'),
        content: const Text('Are you sure you want to reset all settings to default? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('App settings reset to default'),
                  backgroundColor: AppTheme.accentRed,
                ),
              );
            },
            style: TextButton.styleFrom(foregroundColor: AppTheme.accentRed),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceBlue,
        title: const Text('Help'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Settings Help:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('• Use switches to enable/disable features'),
              Text('• Tap dropdown menus to change options'),
              Text('• Tap action items to access sub-menus'),
              SizedBox(height: 16),
              Text('Tips:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('• Enable biometric lock for better security'),
              Text('• Turn on auto backup to protect your settings'),
              Text('• Use voice assistant for hands-free control'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showPrivacyPolicy() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceBlue,
        title: const Text('Privacy Policy'),
        content: const SingleChildScrollView(
          child: Text(
            'Privacy Policy for Smart Home AI\n\n'
                'We are committed to protecting your privacy. This app:\n\n'
                '• Stores all data locally on your device\n'
                '• Does not send personal data to external servers\n'
                '• Uses device permissions only for intended features\n'
                '• Allows you to control data sharing preferences\n\n'
                'For the complete privacy policy, visit our website.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _exportData() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceBlue,
        title: const Text('Export Data'),
        content: const Text('Your data will be exported in JSON format. This includes device settings, automation rules, and preferences.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Data exported successfully'),
                  backgroundColor: AppTheme.accentGreen,
                ),
              );
            },
            child: const Text('Export'),
          ),
        ],
      ),
    );
  }
}

// Device Management Page (placeholder)
class DeviceManagementPage extends StatelessWidget {
  const DeviceManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Device Management'),
        backgroundColor: AppTheme.surfaceBlue,
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'Device Management interface will be implemented in the full version.\n\n'
                'Features will include:\n'
                '• Add new devices\n'
                '• Remove devices\n'
                '• Configure device settings\n'
                '• Update device firmware\n'
                '• Device grouping and rooms',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}