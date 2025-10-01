import 'package:flutter/material.dart';
import 'app_theme.dart';
import 'mock_data_service.dart';
import 'models.dart';

class SecurityPage extends StatefulWidget {
  const SecurityPage({super.key});

  @override
  State<SecurityPage> createState() => _SecurityPageState();
}

class _SecurityPageState extends State<SecurityPage> with TickerProviderStateMixin {
  late List<SecurityEvent> securityEvents;
  late List<Device> securityDevices;
  late TabController _tabController;
  bool isArmed = true;
  String selectedFilter = 'All';

  final List<String> severityFilters = ['All', 'Critical', 'High', 'Medium', 'Low'];

  @override
  void initState() {
    super.initState();
    securityEvents = MockDataService.getSecurityEvents();
    securityDevices = MockDataService.getDevices().where((d) => d.type == 'security').toList();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<SecurityEvent> get filteredEvents {
    if (selectedFilter == 'All') return securityEvents;
    return securityEvents.where((event) =>
    event.severity.toLowerCase() == selectedFilter.toLowerCase()).toList();
  }

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
                  'Security Monitoring',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppTheme.accentRed.withOpacity(0.8),
                        AppTheme.accentOrange.withOpacity(0.6),
                        AppTheme.accentYellow.withOpacity(0.4),
                      ],
                    ),
                  ),
                ),
              ),
              actions: [
                IconButton(
                  icon: Icon(
                    isArmed ? Icons.shield_rounded : Icons.shield_outlined,
                    color: isArmed ? AppTheme.accentGreen : AppTheme.accentRed,
                  ),
                  onPressed: () {
                    _toggleSecuritySystem();
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.settings_rounded),
                  onPressed: () {
                    _showSecuritySettings();
                  },
                ),
              ],
            ),

            // Main Content
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // Security Status Card
                  _buildSecurityStatusCard(),
                  const SizedBox(height: 24),

                  // Tab Bar
                  _buildTabBar(),
                  const SizedBox(height: 16),

                  // Tab Content
                  _buildTabContent(),
                ]),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showEmergencyDialog();
        },
        backgroundColor: AppTheme.accentRed,
        icon: const Icon(Icons.emergency_rounded),
        label: const Text('Emergency'),
      ),
    );
  }

  Widget _buildSecurityStatusCard() {
    final unreadEvents = securityEvents.where((e) => !e.isRead).length;
    final onlineDevices = securityDevices.where((d) => d.isOnline).length;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Main Status
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: (isArmed ? AppTheme.accentGreen : AppTheme.accentRed).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    isArmed ? Icons.shield_rounded : Icons.shield_outlined,
                    color: isArmed ? AppTheme.accentGreen : AppTheme.accentRed,
                    size: 40,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isArmed ? 'System Armed' : 'System Disarmed',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: isArmed ? AppTheme.accentGreen : AppTheme.accentRed,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        isArmed ? 'Home protection is active' : 'Security system is offline',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Last updated: ${DateTime.now().toString().substring(11, 16)}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Quick Stats
            Row(
              children: [
                Expanded(
                  child: _buildQuickStatCard(
                    'Active Alerts',
                    unreadEvents.toString(),
                    Icons.warning_rounded,
                    unreadEvents > 0 ? AppTheme.accentRed : AppTheme.accentGreen,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildQuickStatCard(
                    'Devices Online',
                    '$onlineDevices/${securityDevices.length}',
                    Icons.devices_rounded,
                    onlineDevices == securityDevices.length ? AppTheme.accentGreen : AppTheme.accentYellow,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildQuickStatCard(
                    'System Status',
                    isArmed ? 'Armed' : 'Disarmed',
                    Icons.security_rounded,
                    isArmed ? AppTheme.accentGreen : AppTheme.accentRed,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.cardBlue,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: AppTheme.accentRed,
          borderRadius: BorderRadius.circular(8),
        ),
        indicatorPadding: const EdgeInsets.all(4),
        dividerColor: Colors.transparent,
        labelColor: AppTheme.textPrimary,
        unselectedLabelColor: AppTheme.textSecondary,
        tabs: const [
          Tab(text: 'Alerts'),
          Tab(text: 'Cameras'),
          Tab(text: 'Devices'),
        ],
      ),
    );
  }

  Widget _buildTabContent() {
    return SizedBox(
      height: 500,
      child: TabBarView(
        controller: _tabController,
        children: [
          _buildAlertsTab(),
          _buildCamerasTab(),
          _buildDevicesTab(),
        ],
      ),
    );
  }

  Widget _buildAlertsTab() {
    return Column(
      children: [
        // Filter bar
        Row(
          children: [
            Text(
              'Filter by severity:',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: severityFilters.map((filter) {
                    final isSelected = selectedFilter == filter;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: GestureDetector(
                        onTap: () => setState(() => selectedFilter = filter),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: isSelected ? AppTheme.accentRed : AppTheme.cardBlue,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            filter,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: isSelected ? AppTheme.textPrimary : AppTheme.textSecondary,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Alerts list
        Expanded(
          child: filteredEvents.isEmpty
              ? _buildNoAlertsView()
              : ListView.builder(
            itemCount: filteredEvents.length,
            itemBuilder: (context, index) {
              return _buildAlertCard(filteredEvents[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildNoAlertsView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.security_rounded,
            size: 64,
            color: AppTheme.accentGreen.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No alerts found',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your home is secure',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget _buildAlertCard(SecurityEvent event) {
    Color severityColor = _getSeverityColor(event.severity);
    IconData severityIcon = _getSeverityIcon(event.severity);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: severityColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(severityIcon, color: severityColor, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        event.type,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      if (!event.isRead)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppTheme.accentRed,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    event.description,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: severityColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          event.severity.toUpperCase(),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: severityColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        _formatTimestamp(event.timestamp),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            IconButton(
              onPressed: () => _showAlertDetails(event),
              icon: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCamerasTab() {
    return Column(
      children: [
        // Camera grid
        Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: 4, // Mock camera count
            itemBuilder: (context, index) {
              return _buildCameraCard(index);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCameraCard(int index) {
    final cameraNames = ['Front Door', 'Living Room', 'Backyard', 'Kitchen'];
    final isRecording = index % 2 == 0; // Mock recording status

    return Card(
      child: Stack(
        children: [
          // Camera feed placeholder
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppTheme.accentBlue.withOpacity(0.3),
                  AppTheme.lightBlue.withOpacity(0.1),
                ],
              ),
            ),
            child: const Icon(
              Icons.videocam_rounded,
              size: 48,
              color: AppTheme.textSecondary,
            ),
          ),

          // Camera info overlay
          Positioned(
            top: 12,
            left: 12,
            right: 12,
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: isRecording ? AppTheme.accentRed : AppTheme.textSecondary,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        isRecording ? 'REC' : 'OFF',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => _showCameraControls(index),
                  icon: const Icon(Icons.more_vert_rounded, color: Colors.white),
                  iconSize: 16,
                ),
              ],
            ),
          ),

          // Camera name
          Positioned(
            bottom: 12,
            left: 12,
            right: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                cameraNames[index],
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDevicesTab() {
    return ListView.builder(
      itemCount: securityDevices.length,
      itemBuilder: (context, index) {
        return _buildSecurityDeviceCard(securityDevices[index]);
      },
    );
  }

  Widget _buildSecurityDeviceCard(Device device) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: (device.isOnline ? AppTheme.accentGreen : AppTheme.accentRed).withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                device.name.contains('Camera') ? Icons.videocam_rounded : Icons.sensors_rounded,
                color: device.isOnline ? AppTheme.accentGreen : AppTheme.accentRed,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    device.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    device.room,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: (device.isOnline ? AppTheme.accentGreen : AppTheme.accentRed).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          device.isOnline ? 'Online' : 'Offline',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: device.isOnline ? AppTheme.accentGreen : AppTheme.accentRed,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: (device.isOn ? AppTheme.accentBlue : AppTheme.textSecondary).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          device.isOn ? 'Active' : 'Inactive',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: device.isOn ? AppTheme.accentBlue : AppTheme.textSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Switch(
              value: device.isOn,
              onChanged: device.isOnline ? (value) {
                // Toggle device
              } : null,
              activeColor: AppTheme.accentGreen,
            ),
          ],
        ),
      ),
    );
  }

  Color _getSeverityColor(String severity) {
    switch (severity.toLowerCase()) {
      case 'critical':
        return AppTheme.accentRed;
      case 'high':
        return AppTheme.accentRed.withOpacity(0.8);
      case 'medium':
        return AppTheme.accentYellow;
      case 'low':
        return AppTheme.accentGreen;
      default:
        return AppTheme.textSecondary;
    }
  }

  IconData _getSeverityIcon(String severity) {
    switch (severity.toLowerCase()) {
      case 'critical':
        return Icons.error_rounded;
      case 'high':
        return Icons.warning_rounded;
      case 'medium':
        return Icons.info_rounded;
      case 'low':
        return Icons.check_circle_rounded;
      default:
        return Icons.help_rounded;
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  void _toggleSecuritySystem() {
    setState(() {
      isArmed = !isArmed;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isArmed ? 'Security system armed' : 'Security system disarmed'),
        backgroundColor: isArmed ? AppTheme.accentGreen : AppTheme.accentRed,
      ),
    );
  }

  void _showAlertDetails(SecurityEvent event) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.6,
        decoration: const BoxDecoration(
          color: AppTheme.surfaceBlue,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppTheme.textSecondary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Alert Details',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 24),

                    // Alert info
                    Text('Event: ${event.type}'),
                    Text('Severity: ${event.severity}'),
                    Text('Time: ${event.timestamp}'),
                    Text('Description: ${event.description}'),

                    const SizedBox(height: 24),

                    // Actions
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Mark as Read'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.accentRed,
                            ),
                            child: const Text('Dismiss'),
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

  void _showCameraControls(int cameraIndex) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: AppTheme.surfaceBlue,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Camera Controls',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 20),

              // Camera control options
              ListTile(
                leading: const Icon(Icons.play_arrow_rounded),
                title: const Text('Start Recording'),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: const Icon(Icons.stop_rounded),
                title: const Text('Stop Recording'),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt_rounded),
                title: const Text('Take Snapshot'),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: const Icon(Icons.settings_rounded),
                title: const Text('Camera Settings'),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSecuritySettings() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.6,
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
                'Security Settings',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 24),

              // Settings options
              _buildSettingItem('Motion Detection', 'Detect movement in monitored areas', true),
              _buildSettingItem('Night Vision', 'Enable night vision on cameras', true),
              _buildSettingItem('Audio Recording', 'Record audio with video', false),
              _buildSettingItem('Smart Alerts', 'AI-powered threat detection', true),
              _buildSettingItem('Mobile Notifications', 'Send alerts to mobile devices', true),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingItem(String title, String subtitle, bool value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
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
            onChanged: (newValue) {},
            activeColor: AppTheme.accentGreen,
          ),
        ],
      ),
    );
  }

  void _showEmergencyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceBlue,
        title: const Text('Emergency Mode'),
        content: const Text(
          'Are you sure you want to activate emergency mode? This will:\n\n'
              '• Send alerts to all emergency contacts\n'
              '• Activate all security devices\n'
              '• Start recording on all cameras\n'
              '• Lock all smart locks',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Emergency mode activated'),
                  backgroundColor: AppTheme.accentRed,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.accentRed,
            ),
            child: const Text('Activate'),
          ),
        ],
      ),
    );
  }
}