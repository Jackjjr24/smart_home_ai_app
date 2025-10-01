import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'app_theme.dart';
import 'mock_data_service.dart';
import 'models.dart';
import 'device_card.dart';
import 'energy_overview_card.dart';
import 'security_status_card.dart';
import 'voice_fab.dart'; // Add this import

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<Device> devices;
  late List<EnergyData> energyData;
  late List<SecurityEvent> securityEvents;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    devices = MockDataService.getDevices();
    energyData = MockDataService.getEnergyData();
    securityEvents = MockDataService.getSecurityEvents();
  }

  @override
  Widget build(BuildContext context) {
    final activeDevices = devices.where((d) => d.isOn).length;
    final totalDevices = devices.length;
    final currentEnergy = MockDataService.getCurrentEnergyUsage();
    final solarGeneration = MockDataService.getSolarGeneration();
    final batteryLevel = MockDataService.getBatteryLevel();

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
                  'Smart Home AI',
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
                        AppTheme.primaryBlue,
                        AppTheme.secondaryBlue,
                        AppTheme.accentBlue.withOpacity(0.8),
                      ],
                    ),
                  ),
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.notifications_rounded, color: Colors.white),
                  onPressed: () {
                    // Show notifications
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.person_rounded, color: Colors.white),
                  onPressed: () {
                    // Profile
                  },
                ),
              ],
            ),

            // Main Content
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // Welcome Section
                  _buildWelcomeSection(),
                  const SizedBox(height: 20),

                  // Quick Stats
                  _buildQuickStats(activeDevices, totalDevices, currentEnergy, solarGeneration, batteryLevel),
                  const SizedBox(height: 20),

                  // Energy Overview
                  _buildEnergyOverview(),
                  const SizedBox(height: 20),

                  // Device Control Section
                  _buildDeviceControlSection(),
                  const SizedBox(height: 20),

                  // Security Status
                  _buildSecurityStatus(),
                  const SizedBox(height: 20),

                  // Recent Activity
                  _buildRecentActivity(),
                  const SizedBox(height: 100), // Extra padding for FAB
                ]),
              ),
            ),
          ],
        ),
      ),
      // Add the Voice FAB here
      floatingActionButton: const VoiceFAB(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildWelcomeSection() {
    final hour = DateTime.now().hour;
    String greeting;
    if (hour < 12) {
      greeting = 'Good Morning';
    } else if (hour < 17) {
      greeting = 'Good Afternoon';
    } else {
      greeting = 'Good Evening';
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$greeting!',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: AppTheme.accentGreen,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Your home is running smoothly',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'All systems operational',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.accentGreen.withOpacity(0.15),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.home_rounded,
                color: AppTheme.accentGreen,
                size: 32,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStats(int activeDevices, int totalDevices, double currentEnergy, double solarGeneration, double batteryLevel) {
    return SizedBox(
      height: 90, // Reduced height
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildStatCard(
            'Active Devices',
            '$activeDevices/$totalDevices',
            Icons.devices_rounded,
            AppTheme.accentBlue,
          ),
          const SizedBox(width: 8), // Reduced spacing
          _buildStatCard(
            'Energy Usage',
            '${currentEnergy.toStringAsFixed(1)} kW',
            Icons.bolt_rounded,
            AppTheme.accentYellow,
          ),
          const SizedBox(width: 8), // Reduced spacing
          _buildStatCard(
            'Solar Gen.',
            '${solarGeneration.toStringAsFixed(1)} kW',
            Icons.wb_sunny_rounded,
            AppTheme.accentOrange,
          ),
          const SizedBox(width: 8), // Reduced spacing
          _buildStatCard(
            'Battery',
            '${batteryLevel.toStringAsFixed(0)}%',
            Icons.battery_std_rounded,
            AppTheme.accentGreen,
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
          padding: const EdgeInsets.all(10), // Further reduced padding
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Icon(icon, color: color, size: 14), // Smaller icon
                  const Spacer(),
                  Container(
                    width: 4, // Smaller indicator
                    height: 4,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                value,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 14, // Smaller font
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                title,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.textSecondary,
                  fontSize: 10, // Smaller font
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEnergyOverview() {
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
                  'Energy Overview',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    // Navigate to energy page
                  },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                  ),
                  child: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 2,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: AppTheme.accentBlue.withOpacity(0.2),
                        strokeWidth: 1,
                      );
                    },
                  ),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 22,
                        interval: 4,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          const style = TextStyle(
                            color: AppTheme.textSecondary,
                            fontSize: 10,
                          );
                          String text;
                          if (value.toInt() == 0) {
                            text = '12AM';
                          } else if (value.toInt() == 12) {
                            text = '12PM';
                          } else if (value.toInt() > 12) {
                            text = '${value.toInt() - 12}PM';
                          } else {
                            text = '${value.toInt()}AM';
                          }
                          return SideTitleWidget(
                            axisSide: meta.axisSide,
                            space: 4,
                            child: Text(text, style: style),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 32,
                        interval: 2,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          const style = TextStyle(
                            color: AppTheme.textSecondary,
                            fontSize: 10,
                          );
                          return Text('${value.toInt()}kW', style: style);
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: false),
                  minX: 0,
                  maxX: 23,
                  minY: 0,
                  maxY: 8,
                  lineBarsData: [
                    // Solar Generation Line
                    LineChartBarData(
                      spots: energyData.asMap().entries.map((entry) {
                        return FlSpot(entry.key.toDouble(), entry.value.solarGeneration);
                      }).toList(),
                      isCurved: true,
                      color: AppTheme.accentOrange,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        color: AppTheme.accentOrange.withOpacity(0.08),
                      ),
                    ),
                    // Energy Consumption Line
                    LineChartBarData(
                      spots: energyData.asMap().entries.map((entry) {
                        return FlSpot(entry.key.toDouble(), entry.value.totalConsumption);
                      }).toList(),
                      isCurved: true,
                      color: AppTheme.accentBlue,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        color: AppTheme.accentBlue.withOpacity(0.08),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLegendItem('Solar Generation', AppTheme.accentOrange),
                const SizedBox(width: 20),
                _buildLegendItem('Energy Usage', AppTheme.accentBlue),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppTheme.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildDeviceControlSection() {
    final priorityDevices = devices.take(4).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min, // Add this
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            children: [
              Text(
                'Quick Controls',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  // Navigate to devices page
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text('View All'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 15),

        // Use a fixed height container instead of ConstrainedBox
        SizedBox(
          height: 350, // Fixed height that provides enough space
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.1, // Further reduced for more vertical space
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: priorityDevices.length,
            itemBuilder: (context, index) {
              return DeviceCard(
                device: priorityDevices[index],
                onToggle: (isOn) {
                  setState(() {
                    // Update device state
                    final device = priorityDevices[index];
                    final deviceIndex = devices.indexWhere((d) => d.id == device.id);
                    if (deviceIndex != -1) {
                      devices[deviceIndex] = devices[deviceIndex].copyWith(isOn: isOn);
                    }
                  });
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSecurityStatus() {
    final unreadEvents = securityEvents.where((e) => !e.isRead).length;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: unreadEvents > 0 ? AppTheme.accentRed.withOpacity(0.15) : AppTheme.accentGreen.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                unreadEvents > 0 ? Icons.warning_rounded : Icons.shield_rounded,
                color: unreadEvents > 0 ? AppTheme.accentRed : AppTheme.accentGreen,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min, // Added to prevent overflow
                children: [
                  Text(
                    'Security Status',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    unreadEvents > 0 ? '$unreadEvents new alerts' : 'All systems secure',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: unreadEvents > 0 ? AppTheme.accentRed : AppTheme.accentGreen,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {
                // Navigate to security page
              },
              icon: Icon(
                Icons.arrow_forward_ios_rounded,
                color: AppTheme.textSecondary,
                size: 18,
              ),
              padding: EdgeInsets.zero, // Reduced padding
              constraints: const BoxConstraints(maxWidth: 40), // Constrained size
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivity() {
    final recentEvents = securityEvents.take(3).toList();

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min, // Added to prevent overflow
          children: [
            Text(
              'Recent Activity',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            if (recentEvents.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Center(
                  child: Text(
                    'No recent activity',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ),
              )
            else
              Column(
                mainAxisSize: MainAxisSize.min, // Added to prevent overflow
                children: recentEvents.map((event) => _buildActivityItem(event)).toList(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem(SecurityEvent event) {
    Color statusColor;
    IconData statusIcon;

    switch (event.severity) {
      case 'high':
      case 'critical':
        statusColor = AppTheme.accentRed;
        statusIcon = Icons.error_rounded;
        break;
      case 'medium':
        statusColor = AppTheme.accentYellow;
        statusIcon = Icons.warning_rounded;
        break;
      default:
        statusColor = AppTheme.accentGreen;
        statusIcon = Icons.info_rounded;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(statusIcon, color: statusColor, size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min, // Added to prevent overflow
              children: [
                Text(
                  event.description,
                  style: Theme.of(context).textTheme.bodyMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  _formatTime(event.timestamp),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}