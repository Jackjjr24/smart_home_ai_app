import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'app_theme.dart';
import 'mock_data_service.dart';
import 'models.dart';

class EnergyPage extends StatefulWidget {
  const EnergyPage({super.key});

  @override
  State<EnergyPage> createState() => _EnergyPageState();
}

class _EnergyPageState extends State<EnergyPage> with TickerProviderStateMixin {
  late List<EnergyData> energyData;
  late TabController _tabController;
  String selectedPeriod = 'Today';

  final List<String> periods = ['Today', 'Week', 'Month', 'Year'];

  @override
  void initState() {
    super.initState();
    energyData = MockDataService.getEnergyData();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
                  'Energy Management',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppTheme.accentYellow.withOpacity(0.8),
                        AppTheme.accentOrange.withOpacity(0.6),
                        AppTheme.accentRed.withOpacity(0.4),
                      ],
                    ),
                  ),
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.settings_rounded),
                  onPressed: () {
                    _showEnergySettings();
                  },
                ),
              ],
            ),

            // Main Content
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // Energy Overview Cards
                  _buildEnergyOverviewCards(),
                  const SizedBox(height: 24),

                  // Period Selector
                  _buildPeriodSelector(),
                  const SizedBox(height: 24),

                  // Tab Bar for different views
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
    );
  }

  Widget _buildEnergyOverviewCards() {
    final currentUsage = MockDataService.getCurrentEnergyUsage();
    final solarGeneration = MockDataService.getSolarGeneration();
    final batteryLevel = MockDataService.getBatteryLevel();
    final gridConsumption = currentUsage - solarGeneration;

    return Column(
      children: [
        // Top row - Main metrics
        Row(
          children: [
            Expanded(
              child: _buildEnergyCard(
                'Solar Generation',
                '${solarGeneration.toStringAsFixed(1)} kW',
                '↗ +12% today',
                Icons.wb_sunny_rounded,
                AppTheme.accentOrange,
                isPositive: true,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildEnergyCard(
                'Grid Usage',
                '${gridConsumption.toStringAsFixed(1)} kW',
                '↘ -8% today',
                Icons.electrical_services_rounded,
                AppTheme.accentBlue,
                isPositive: true,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Bottom row - Battery and Cost
        Row(
          children: [
            Expanded(
              child: _buildBatteryCard(batteryLevel),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildEnergyCard(
                'Today\'s Cost',
                '₹${(energyData.fold(0.0, (sum, data) => sum + data.cost) / energyData.length * 24).toStringAsFixed(0)}',
                '↘ ₹45 saved',
                Icons.currency_rupee_rounded,
                AppTheme.accentGreen,
                isPositive: true,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEnergyCard(String title, String value, String change, IconData icon, Color color, {bool isPositive = true}) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
                const Spacer(),
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: isPositive ? AppTheme.accentGreen : AppTheme.accentRed,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            Text(
              change,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: isPositive ? AppTheme.accentGreen : AppTheme.accentRed,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBatteryCard(double batteryLevel) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.accentGreen.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.battery_charging_full_rounded,
                      color: AppTheme.accentGreen, size: 20),
                ),
                const Spacer(),
                Text(
                  '${batteryLevel.toStringAsFixed(0)}%',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.accentGreen,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Battery Level',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: batteryLevel / 100,
              backgroundColor: AppTheme.cardBlue,
              valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.accentGreen),
              minHeight: 6,
            ),
            const SizedBox(height: 8),
            Text(
              batteryLevel > 80 ? 'Excellent' : batteryLevel > 50 ? 'Good' : 'Low',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: batteryLevel > 80 ? AppTheme.accentGreen :
                batteryLevel > 50 ? AppTheme.accentYellow : AppTheme.accentRed,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPeriodSelector() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: periods.map((period) {
            final isSelected = selectedPeriod == period;
            return Expanded(
              child: GestureDetector(
                onTap: () => setState(() => selectedPeriod = period),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: isSelected ? AppTheme.accentBlue : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    period,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
          color: AppTheme.accentBlue,
          borderRadius: BorderRadius.circular(8),
        ),
        indicatorPadding: const EdgeInsets.all(4),
        dividerColor: Colors.transparent,
        labelColor: AppTheme.textPrimary,
        unselectedLabelColor: AppTheme.textSecondary,
        tabs: const [
          Tab(text: 'Usage'),
          Tab(text: 'Solar'),
          Tab(text: 'Cost'),
        ],
      ),
    );
  }

  Widget _buildTabContent() {
    return SizedBox(
      height: 400,
      child: TabBarView(
        controller: _tabController,
        children: [
          _buildUsageChart(),
          _buildSolarChart(),
          _buildCostAnalysis(),
        ],
      ),
    );
  }

  Widget _buildUsageChart() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Energy Usage Breakdown',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.info_outline_rounded),
                  onPressed: () {
                    _showUsageInfo();
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Row(
                children: [
                  // Pie Chart
                  Expanded(
                    flex: 2,
                    child: PieChart(
                      PieChartData(
                        sectionsSpace: 2,
                        centerSpaceRadius: 40,
                        sections: _buildPieChartSections(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  // Legend
                  Expanded(
                    flex: 1,
                    child: _buildUsageLegend(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> _buildPieChartSections() {
    final categoryData = MockDataService.getEnergyByCategory();
    final colors = [
      AppTheme.accentBlue,
      AppTheme.accentYellow,
      AppTheme.accentGreen,
      AppTheme.accentOrange,
      AppTheme.accentRed,
    ];

    return categoryData.entries.toList().asMap().entries.map((entry) {
      final index = entry.key;
      final category = entry.value;
      final color = colors[index % colors.length];

      return PieChartSectionData(
        value: category.value,
        color: color,
        title: '${(category.value / categoryData.values.fold(0.0, (a, b) => a + b) * 100).toStringAsFixed(0)}%',
        radius: 50,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: AppTheme.textPrimary,
        ),
      );
    }).toList();
  }

  Widget _buildUsageLegend() {
    final categoryData = MockDataService.getEnergyByCategory();
    final colors = [
      AppTheme.accentBlue,
      AppTheme.accentYellow,
      AppTheme.accentGreen,
      AppTheme.accentOrange,
      AppTheme.accentRed,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: categoryData.entries.toList().asMap().entries.map((entry) {
        final index = entry.key;
        final category = entry.value;
        final color = colors[index % colors.length];

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category.key,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '${category.value.toStringAsFixed(1)} kW',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: color,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSolarChart() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Solar Generation Performance',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 1,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: AppTheme.accentBlue.withOpacity(0.3),
                        strokeWidth: 1,
                      );
                    },
                  ),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        interval: 4,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          const style = TextStyle(
                            color: AppTheme.textSecondary,
                            fontSize: 12,
                          );
                          return SideTitleWidget(
                            axisSide: meta.axisSide,
                            child: Text('${value.toInt()}:00', style: style),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          const style = TextStyle(
                            color: AppTheme.textSecondary,
                            fontSize: 12,
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
                  maxY: 6,
                  lineBarsData: [
                    LineChartBarData(
                      spots: energyData.asMap().entries.map((entry) {
                        return FlSpot(entry.key.toDouble(), entry.value.solarGeneration);
                      }).toList(),
                      isCurved: true,
                      color: AppTheme.accentOrange,
                      barWidth: 4,
                      isStrokeCapRound: true,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            AppTheme.accentOrange.withOpacity(0.3),
                            AppTheme.accentOrange.withOpacity(0.1),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildSolarStats(),
          ],
        ),
      ),
    );
  }

  Widget _buildSolarStats() {
    return Row(
      children: [
        Expanded(
          child: _buildStatItem(
            'Peak Generation',
            '4.8 kW',
            '12:30 PM',
          ),
        ),
        Expanded(
          child: _buildStatItem(
            'Total Today',
            '28.5 kWh',
            '85% efficiency',
          ),
        ),
        Expanded(
          child: _buildStatItem(
            'This Month',
            '845 kWh',
            '₹4,225 saved',
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem(String title, String value, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.accentOrange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppTheme.accentOrange,
            ),
          ),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCostAnalysis() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Cost Analysis & Savings',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Column(
                children: [
                  // Cost breakdown cards
                  Row(
                    children: [
                      Expanded(
                        child: _buildCostCard(
                          'Grid Cost',
                          '₹180',
                          'This month',
                          AppTheme.accentRed,
                          Icons.electrical_services_rounded,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildCostCard(
                          'Solar Savings',
                          '₹420',
                          'This month',
                          AppTheme.accentGreen,
                          Icons.savings_rounded,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Monthly comparison chart
                  Expanded(
                    child: BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        maxY: 500,
                        barTouchData: BarTouchData(enabled: false),
                        titlesData: FlTitlesData(
                          show: true,
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (double value, TitleMeta meta) {
                                const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'];
                                return Text(
                                  months[value.toInt() % months.length],
                                  style: const TextStyle(
                                    color: AppTheme.textSecondary,
                                    fontSize: 12,
                                  ),
                                );
                              },
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 40,
                              getTitlesWidget: (double value, TitleMeta meta) {
                                return Text(
                                  '₹${value.toInt()}',
                                  style: const TextStyle(
                                    color: AppTheme.textSecondary,
                                    fontSize: 10,
                                  ),
                                );
                              },
                            ),
                          ),
                          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        ),
                        borderData: FlBorderData(show: false),
                        barGroups: List.generate(6, (index) {
                          return BarChartGroupData(
                            x: index,
                            barRods: [
                              BarChartRodData(
                                toY: 200 + (index * 30),
                                color: AppTheme.accentRed,
                                width: 16,
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                              ),
                              BarChartRodData(
                                toY: 150 + (index * 25),
                                color: AppTheme.accentGreen,
                                width: 16,
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                              ),
                            ],
                          );
                        }),
                      ),
                    ),
                  ),

                  // Legend
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildChartLegend('Grid Cost', AppTheme.accentRed),
                      const SizedBox(width: 24),
                      _buildChartLegend('Solar Savings', AppTheme.accentGreen),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCostCard(String title, String amount, String period, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const Spacer(),
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            amount,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Text(
            period,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartLegend(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  void _showUsageInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceBlue,
        title: const Text('Energy Usage Info'),
        content: const Text(
          'This chart shows how your energy is distributed across different categories. '
              'Use this information to identify areas where you can optimize energy consumption.',
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

  void _showEnergySettings() {
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
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Energy Settings',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 24),

                  // Settings options
                  _buildSettingItem(
                    'Energy Optimization',
                    'Automatically optimize energy usage',
                    true,
                        (value) {},
                  ),
                  _buildSettingItem(
                    'Peak Hour Alerts',
                    'Notify during high-cost periods',
                    true,
                        (value) {},
                  ),
                  _buildSettingItem(
                    'Battery Priority',
                    'Prioritize battery over grid',
                    false,
                        (value) {},
                  ),
                  _buildSettingItem(
                    'Export Surplus',
                    'Sell excess solar to grid',
                    true,
                        (value) {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingItem(String title, String subtitle, bool value, ValueChanged<bool> onChanged) {
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
            onChanged: onChanged,
            activeColor: AppTheme.accentGreen,
          ),
        ],
      ),
    );
  }
}