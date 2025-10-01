import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'app_theme.dart';
import 'mock_data_service.dart';
import 'models.dart';
import 'device_card.dart';

class DevicesPage extends StatefulWidget {
  const DevicesPage({super.key});

  @override
  State<DevicesPage> createState() => _DevicesPageState();
}

class _DevicesPageState extends State<DevicesPage> with TickerProviderStateMixin {
  late List<Device> devices;
  late TabController _tabController;
  String selectedRoom = 'All';
  String selectedType = 'All';

  final List<String> rooms = ['All', 'Living Room', 'Kitchen', 'Bedroom', 'Bathroom', 'Office'];
  final List<String> deviceTypes = ['All', 'lighting', 'climate', 'appliance', 'entertainment', 'security'];

  @override
  void initState() {
    super.initState();
    devices = MockDataService.getDevices();
    _tabController = TabController(length: rooms.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Device> get filteredDevices {
    return devices.where((device) {
      bool roomMatch = selectedRoom == 'All' || device.room == selectedRoom;
      bool typeMatch = selectedType == 'All' || device.type == selectedType;
      return roomMatch && typeMatch;
    }).toList();
  }

  Map<String, List<Device>> get devicesByRoom {
    Map<String, List<Device>> grouped = {};
    for (var device in filteredDevices) {
      if (!grouped.containsKey(device.room)) {
        grouped[device.room] = [];
      }
      grouped[device.room]!.add(device);
    }
    return grouped;
  }

  void _toggleDevice(Device device) {
    setState(() {
      final index = devices.indexWhere((d) => d.id == device.id);
      if (index != -1) {
        devices[index] = devices[index].copyWith(isOn: !devices[index].isOn);

        // Show feedback
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${device.name} turned ${!device.isOn ? 'on' : 'off'}'),
            duration: const Duration(seconds: 1),
            backgroundColor: !device.isOn ? AppTheme.accentGreen : AppTheme.textSecondary,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
          ),
        );
      }
    });
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
                  'Device Control',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                centerTitle: false,
                titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppTheme.accentBlue,
                        AppTheme.accentBlue.withOpacity(0.8),
                        AppTheme.lightBlue.withOpacity(0.6),
                      ],
                    ),
                  ),
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.add_rounded, color: Colors.white),
                  onPressed: () {
                    _showAddDeviceDialog();
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.refresh_rounded, color: Colors.white),
                  onPressed: () {
                    setState(() {
                      devices = MockDataService.getDevices();
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Devices refreshed'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  },
                ),
              ],
            ),

            // Filters and Stats
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildStatsCards(),
                    const SizedBox(height: 20),
                    _buildFilters(),
                  ],
                ),
              ),
            ),

            // Devices List
            if (filteredDevices.isNotEmpty)
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (context, index) {
                      final roomEntry = devicesByRoom.entries.elementAt(index);
                      return _buildRoomSection(roomEntry.key, roomEntry.value);
                    },
                    childCount: devicesByRoom.length,
                  ),
                ),
              )
            else
              SliverFillRemaining(
                child: _buildEmptyState(),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _toggleAllDevices();
        },
        backgroundColor: AppTheme.accentGreen,
        icon: Icon(
          devices.every((d) => d.isOn) ? Icons.power_off_rounded : Icons.power_settings_new_rounded,
        ),
        label: Text(devices.every((d) => d.isOn) ? 'Turn All Off' : 'Turn All On'),
      ),
    );
  }

  Widget _buildStatsCards() {
    final totalDevices = devices.length;
    final activeDevices = devices.where((d) => d.isOn).length;
    final onlineDevices = devices.where((d) => d.isOnline).length;
    final totalPower = devices.where((d) => d.isOn).fold(0.0, (sum, d) => sum + d.powerConsumption);

    return SizedBox(
      height: 90, // Reduced height
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildStatCard(
            'Total Devices',
            totalDevices.toString(),
            Icons.devices_rounded,
            AppTheme.accentBlue,
          ),
          const SizedBox(width: 8), // Reduced spacing
          _buildStatCard(
            'Active Now',
            activeDevices.toString(),
            Icons.power_settings_new_rounded,
            AppTheme.accentGreen,
          ),
          const SizedBox(width: 8), // Reduced spacing
          _buildStatCard(
            'Online',
            onlineDevices.toString(),
            Icons.wifi_rounded,
            AppTheme.accentOrange,
          ),
          const SizedBox(width: 8), // Reduced spacing
          _buildStatCard(
            'Power Usage',
            '${(totalPower / 1000).toStringAsFixed(1)}kW',
            Icons.bolt_rounded,
            AppTheme.accentYellow,
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return SizedBox(
      width: 120, // Reduced width
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(10), // Reduced padding
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min, // Add this
            children: [
              Icon(icon, color: color, size: 18), // Smaller icon
              const SizedBox(height: 6),
              Text(
                value,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                  fontSize: 14, // Smaller font
                ),
              ),
              const SizedBox(height: 2),
              Text(
                title,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.textSecondary,
                  fontSize: 10, // Smaller font
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilters() {
    return Row(
      children: [
        Expanded(
          child: _buildFilterDropdown(
            'Room',
            selectedRoom,
            rooms,
                (value) => setState(() => selectedRoom = value!),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildFilterDropdown(
            'Type',
            selectedType,
            deviceTypes.map((type) => type == 'All' ? 'All' : _capitalize(type)).toList(),
                (value) => setState(() => selectedType = value == 'All' ? 'All' : deviceTypes[deviceTypes.indexWhere((t) => _capitalize(t) == value)]),
          ),
        ),
      ],
    );
  }

  String _capitalize(String text) {
    return text[0].toUpperCase() + text.substring(1);
  }

  Widget _buildFilterDropdown(String label, String value, List<String> items, ValueChanged<String?> onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.cardBlue,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.accentBlue.withOpacity(0.3)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          dropdownColor: AppTheme.cardBlue,
          style: Theme.of(context).textTheme.bodyMedium,
          items: items.map((item) {
            return DropdownMenuItem(
              value: item,
              child: Text(
                item,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            );
          }).toList(),
          onChanged: onChanged,
          hint: Text(label),
        ),
      ),
    );
  }

  Widget _buildRoomSection(String roomName, List<Device> roomDevices) {
    final activeInRoom = roomDevices.where((d) => d.isOn).length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.accentBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _getRoomIcon(roomName),
                  color: AppTheme.accentBlue,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      roomName,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '$activeInRoom/${roomDevices.length} devices active',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => _toggleRoomDevices(roomDevices),
                icon: Icon(
                  roomDevices.every((d) => d.isOn) ? Icons.power_off_rounded : Icons.power_settings_new_rounded,
                  color: roomDevices.every((d) => d.isOn) ? AppTheme.accentRed : AppTheme.accentGreen,
                ),
                tooltip: roomDevices.every((d) => d.isOn) ? 'Turn all off' : 'Turn all on',
              ),
            ],
          ),
        ),

        // StaggeredGrid with proper constraints
        SizedBox(
          height: _calculateStaggeredGridHeight(roomDevices.length), // Calculate proper height
          child: StaggeredGrid.count(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            children: roomDevices.map((device) {
              return StaggeredGridTile.fit(
                crossAxisCellCount: 1,
                child: DeviceCard(
                  device: device,
                  onTap: () => _showDeviceDetails(device),
                  onToggle: (isOn) => _toggleDevice(device),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

// Helper method to calculate staggered grid height
  double _calculateStaggeredGridHeight(int deviceCount) {
    final rows = (deviceCount / 2).ceil();
    const baseCardHeight = 160.0; // Base height for each card
    const spacing = 12.0;
    return (rows * baseCardHeight) + ((rows - 1) * spacing);
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.device_unknown_rounded,
              size: 80,
              color: AppTheme.textSecondary.withOpacity(0.3),
            ),
            const SizedBox(height: 24),
            Text(
              'No devices found',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Try adjusting your filters or add new devices',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () {
                setState(() {
                  selectedRoom = 'All';
                  selectedType = 'All';
                });
              },
              style: FilledButton.styleFrom(
                backgroundColor: AppTheme.accentBlue,
              ),
              child: const Text('Clear Filters'),
            ),
          ],
        ),
      ),
    );
  }

  void _toggleAllDevices() {
    setState(() {
      final shouldTurnOn = devices.any((d) => !d.isOn);
      for (int i = 0; i < devices.length; i++) {
        devices[i] = devices[i].copyWith(isOn: shouldTurnOn);
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(devices.every((d) => d.isOn) ? 'All devices turned on' : 'All devices turned off'),
        backgroundColor: devices.every((d) => d.isOn) ? AppTheme.accentGreen : AppTheme.textSecondary,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _toggleRoomDevices(List<Device> roomDevices) {
    setState(() {
      final shouldTurnOn = roomDevices.any((d) => !d.isOn);
      for (var device in roomDevices) {
        final index = devices.indexWhere((d) => d.id == device.id);
        if (index != -1) {
          devices[index] = devices[index].copyWith(isOn: shouldTurnOn);
        }
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(roomDevices.every((d) => d.isOn) ? 'All devices in room turned on' : 'All devices in room turned off'),
        backgroundColor: roomDevices.every((d) => d.isOn) ? AppTheme.accentGreen : AppTheme.textSecondary,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _showDeviceDetails(Device device) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _buildDeviceDetailsSheet(device),
    );
  }

  Widget _buildDeviceDetailsSheet(Device device) {
    final deviceColor = _getDeviceColor(device.type);

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: AppTheme.surfaceBlue,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppTheme.textSecondary.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: deviceColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    _getDeviceIcon(device.type),
                    color: deviceColor,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        device.name,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        device.room,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: device.isOn,
                  onChanged: (value) {
                    _toggleDevice(device);
                    Navigator.pop(context);
                  },
                  activeColor: deviceColor,
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDeviceInfo(device),
                  const SizedBox(height: 24),
                  _buildDeviceControls(device),
                  const SizedBox(height: 24),
                  _buildDeviceSchedule(device),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeviceInfo(Device device) {
    final deviceColor = _getDeviceColor(device.type);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Device Information',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildInfoItem(
                    'Status',
                    device.isOnline ? 'Online' : 'Offline',
                    device.isOnline ? AppTheme.accentGreen : AppTheme.accentRed,
                    Icons.circle_rounded,
                  ),
                ),
                Expanded(
                  child: _buildInfoItem(
                    'Power',
                    device.isOn ? '${device.powerConsumption.toInt()}W' : '0W',
                    device.isOn ? AppTheme.accentYellow : AppTheme.textSecondary,
                    Icons.bolt_rounded,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildInfoItem(
                    'Type',
                    _capitalize(device.type),
                    deviceColor,
                    _getDeviceIcon(device.type),
                  ),
                ),
                Expanded(
                  child: _buildInfoItem(
                    'Room',
                    device.room,
                    AppTheme.accentBlue,
                    _getRoomIcon(device.room),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(String label, String value, Color color, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 16),
            const SizedBox(width: 6),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildDeviceControls(Device device) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Controls',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            if (device.type == 'climate')
              _buildClimateControls(device)
            else if (device.type == 'lighting')
              _buildLightingControls(device)
            else
              _buildGenericControls(device),
          ],
        ),
      ),
    );
  }

  Widget _buildClimateControls(Device device) {
    final temperature = device.properties['temperature'] ?? 22;
    return Column(
      children: [
        Row(
          children: [
            const Icon(Icons.thermostat_rounded, size: 20),
            const SizedBox(width: 8),
            const Text('Temperature'),
            const Spacer(),
            Text('${temperature}°C', style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 12),
        Slider(
          value: temperature.toDouble(),
          min: 16,
          max: 30,
          divisions: 14,
          activeColor: AppTheme.accentBlue,
          inactiveColor: AppTheme.accentBlue.withOpacity(0.3),
          onChanged: (value) {
            // Update temperature
          },
        ),
      ],
    );
  }

  Widget _buildLightingControls(Device device) {
    final brightness = device.properties['brightness'] ?? 75;
    return Column(
      children: [
        Row(
          children: [
            const Icon(Icons.lightbulb_rounded, size: 20),
            const SizedBox(width: 8),
            const Text('Brightness'),
            const Spacer(),
            Text('$brightness%', style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 12),
        Slider(
          value: brightness.toDouble(),
          min: 0,
          max: 100,
          activeColor: AppTheme.accentYellow,
          inactiveColor: AppTheme.accentYellow.withOpacity(0.3),
          onChanged: (value) {
            // Update brightness
          },
        ),
      ],
    );
  }

  Widget _buildGenericControls(Device device) {
    return const Column(
      children: [
        Row(
          children: [
            Icon(Icons.tune_rounded, size: 20),
            SizedBox(width: 8),
            Text('Device Controls'),
          ],
        ),
        SizedBox(height: 12),
        Text('No specific controls available for this device type.'),
      ],
    );
  }

  Widget _buildDeviceSchedule(Device device) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Schedule',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                FilledButton(
                  onPressed: () {
                    // Add schedule
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: AppTheme.accentBlue,
                  ),
                  child: const Text('Add Schedule'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Row(
              children: [
                Icon(Icons.schedule_rounded, size: 20),
                SizedBox(width: 8),
                Text('No schedules set for this device.'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showAddDeviceDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceBlue,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Add New Device'),
        content: const Text('Device discovery and pairing will be implemented in the full version.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context),
            style: FilledButton.styleFrom(
              backgroundColor: AppTheme.accentBlue,
            ),
            child: const Text('Scan for Devices'),
          ),
        ],
      ),
    );
  }

  IconData _getDeviceIcon(String type) {
    switch (type) {
      case 'lighting':
        return Icons.lightbulb_rounded;
      case 'climate':
        return Icons.ac_unit_rounded;
      case 'entertainment':
        return Icons.tv_rounded;
      case 'appliance':
        return Icons.kitchen_rounded;
      case 'security':
        return Icons.security_rounded;
      default:
        return Icons.device_unknown_rounded;
    }
  }

  IconData _getRoomIcon(String room) {
    switch (room) {
      case 'Living Room':
        return Icons.living_rounded;
      case 'Kitchen':
        return Icons.kitchen_rounded;
      case 'Bedroom':
        return Icons.bed_rounded;
      case 'Bathroom':
        return Icons.bathtub_rounded;
      case 'Office':
        return Icons.work_rounded;
      default:
        return Icons.room_rounded;
    }
  }

  Color _getDeviceColor(String type) {
    switch (type) {
      case 'lighting':
        return AppTheme.accentYellow;
      case 'climate':
        return AppTheme.accentBlue;
      case 'entertainment':
        return AppTheme.accentOrange;
      case 'appliance':
        return AppTheme.accentGreen;
      case 'security':
        return AppTheme.accentRed;
      default:
        return AppTheme.textSecondary;
    }
  }
}