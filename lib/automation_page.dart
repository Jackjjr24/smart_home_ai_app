import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'app_theme.dart';
import 'mock_data_service.dart';
import 'models.dart';

class AutomationPage extends StatefulWidget {
  const AutomationPage({super.key});

  @override
  State<AutomationPage> createState() => _AutomationPageState();
}

class _AutomationPageState extends State<AutomationPage> with TickerProviderStateMixin {
  late List<AutomationRule> automationRules;
  late TabController _tabController;

  String selectedCategory = 'All';
  final List<String> categories = ['All', 'Energy', 'Security', 'Comfort', 'Schedule'];

  @override
  void initState() {
    super.initState();
    automationRules = MockDataService.getAutomationRules();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<AutomationRule> get filteredRules {
    if (selectedCategory == 'All') return automationRules;
    return automationRules.where((rule) =>
        rule.description.toLowerCase().contains(selectedCategory.toLowerCase())).toList();
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
                  'AI Automation',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppTheme.lightBlue.withOpacity(0.8),
                        AppTheme.accentBlue.withOpacity(0.6),
                        AppTheme.accentGreen.withOpacity(0.4),
                      ],
                    ),
                  ),
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.add_rounded),
                  onPressed: () {
                    _showCreateRuleDialog();
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.auto_awesome_rounded),
                  onPressed: () {
                    _showAIInsights();
                  },
                ),
              ],
            ),

            // Main Content
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // AI Overview Card
                  _buildAIOverviewCard(),
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
          _showCreateRuleDialog();
        },
        backgroundColor: AppTheme.lightBlue,
        icon: const Icon(Icons.auto_awesome_rounded),
        label: const Text('Create Rule'),
      ),
    );
  }

  Widget _buildAIOverviewCard() {
    final activeRules = automationRules.where((r) => r.isActive).length;
    final totalRules = automationRules.length;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.lightBlue.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.auto_awesome_rounded,
                    color: AppTheme.lightBlue,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'AI Learning System',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Adapting to your daily routines',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Stats Row
            Row(
              children: [
                Expanded(
                  child: _buildAIStatCard(
                    'Active Rules',
                    '$activeRules/$totalRules',
                    Icons.rule_rounded,
                    AppTheme.accentGreen,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildAIStatCard(
                    'Energy Saved',
                    '₹420/month',
                    Icons.savings_rounded,
                    AppTheme.accentYellow,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildAIStatCard(
                    'Learning Score',
                    '85%',
                    Icons.psychology_rounded,
                    AppTheme.lightBlue,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Learning Progress
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.trending_up_rounded, color: AppTheme.lightBlue, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Learning Progress',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const Spacer(),
                    Text(
                      '85%',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppTheme.lightBlue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: 0.85,
                  backgroundColor: AppTheme.cardBlue,
                  valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.lightBlue),
                  minHeight: 6,
                ),
                const SizedBox(height: 8),
                Text(
                  'AI is learning your habits to create better automations',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAIStatCard(String title, String value, IconData icon, Color color) {
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
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
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
          color: AppTheme.lightBlue,
          borderRadius: BorderRadius.circular(8),
        ),
        indicatorPadding: const EdgeInsets.all(4),
        dividerColor: Colors.transparent,
        labelColor: AppTheme.textPrimary,
        unselectedLabelColor: AppTheme.textSecondary,
        tabs: const [
          Tab(text: 'Rules'),
          Tab(text: 'Insights'),
          Tab(text: 'Routines'),
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
          _buildRulesTab(),
          _buildInsightsTab(),
          _buildRoutinesTab(),
        ],
      ),
    );
  }

  Widget _buildRulesTab() {
    return Column(
      children: [
        // Category Filter
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: categories.map((category) {
              final isSelected = selectedCategory == category;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: GestureDetector(
                  onTap: () => setState(() => selectedCategory = category),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? AppTheme.lightBlue : AppTheme.cardBlue,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      category,
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
        const SizedBox(height: 16),

        // Rules List
        Expanded(
          child: filteredRules.isEmpty
              ? _buildNoRulesView()
              : ListView.builder(
            itemCount: filteredRules.length,
            itemBuilder: (context, index) {
              return _buildRuleCard(filteredRules[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildNoRulesView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.auto_awesome_outlined,
            size: 64,
            color: AppTheme.textSecondary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No automation rules',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Create your first automation rule',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _showCreateRuleDialog,
            icon: const Icon(Icons.add_rounded),
            label: const Text('Create Rule'),
          ),
        ],
      ),
    );
  }

  Widget _buildRuleCard(AutomationRule rule) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: (rule.isActive ? AppTheme.accentGreen : AppTheme.textSecondary).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _getRuleIcon(rule.name),
                    color: rule.isActive ? AppTheme.accentGreen : AppTheme.textSecondary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        rule.name,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        rule.description,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: rule.isActive,
                  onChanged: (value) => _toggleRule(rule, value),
                  activeColor: AppTheme.accentGreen,
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Rule details
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.cardBlue.withOpacity(0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.schedule_rounded, size: 16, color: AppTheme.textSecondary),
                      const SizedBox(width: 8),
                      Text(
                        'Trigger: ${_formatTrigger(rule.trigger)}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.flash_on_rounded, size: 16, color: AppTheme.textSecondary),
                      const SizedBox(width: 8),
                      Text(
                        'Action: ${_formatAction(rule.action)}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                  if (rule.lastExecuted != null) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.history_rounded, size: 16, color: AppTheme.textSecondary),
                        const SizedBox(width: 8),
                        Text(
                          'Last executed: ${_formatLastExecuted(rule.lastExecuted!)}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Action buttons
            Row(
              children: [
                TextButton.icon(
                  onPressed: () => _editRule(rule),
                  icon: const Icon(Icons.edit_rounded, size: 16),
                  label: const Text('Edit'),
                ),
                TextButton.icon(
                  onPressed: () => _testRule(rule),
                  icon: const Icon(Icons.play_arrow_rounded, size: 16),
                  label: const Text('Test'),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => _deleteRule(rule),
                  icon: const Icon(Icons.delete_rounded, size: 16),
                  color: AppTheme.accentRed,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInsightsTab() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Energy Savings Chart
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Energy Savings from Automation',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 200,
                    child: LineChart(
                      LineChartData(
                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: false,
                          horizontalInterval: 50,
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
                        minX: 0,
                        maxX: 5,
                        minY: 0,
                        maxY: 500,
                        lineBarsData: [
                          LineChartBarData(
                            spots: [
                              const FlSpot(0, 150),
                              const FlSpot(1, 200),
                              const FlSpot(2, 280),
                              const FlSpot(3, 350),
                              const FlSpot(4, 400),
                              const FlSpot(5, 420),
                            ],
                            isCurved: true,
                            color: AppTheme.accentGreen,
                            barWidth: 3,
                            isStrokeCapRound: true,
                            dotData: const FlDotData(show: false),
                            belowBarData: BarAreaData(
                              show: true,
                              color: AppTheme.accentGreen.withOpacity(0.1),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // AI Recommendations
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'AI Recommendations',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  ..._getAIRecommendations().map((recommendation) =>
                      _buildRecommendationCard(recommendation)),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Usage Patterns
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Learned Usage Patterns',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  ..._getUsagePatterns().map((pattern) =>
                      _buildPatternCard(pattern)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoutinesTab() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Daily Routine Overview
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.schedule_rounded, color: AppTheme.lightBlue),
                      const SizedBox(width: 12),
                      Text(
                        'Today\'s Routine',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ..._getTodayRoutine().map((routine) =>
                      _buildRoutineItem(routine)),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Routine Analytics
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Routine Analytics',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildRoutineStatCard(
                          'Consistency',
                          '92%',
                          Icons.check_circle_rounded,
                          AppTheme.accentGreen,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildRoutineStatCard(
                          'Efficiency',
                          '88%',
                          Icons.speed_rounded,
                          AppTheme.accentBlue,
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
    );
  }

  Widget _buildRecommendationCard(Map<String, String> recommendation) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.lightBlue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.lightBlue.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.lightbulb_rounded,
            color: AppTheme.lightBlue,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  recommendation['title']!,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  recommendation['description']!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {},
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }

  Widget _buildPatternCard(Map<String, String> pattern) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.accentGreen.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            Icons.analytics_rounded,
            color: AppTheme.accentGreen,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pattern['pattern']!,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  pattern['details']!,
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

  Widget _buildRoutineItem(Map<String, dynamic> routine) {
    final isCompleted = routine['completed'] as bool;
    final time = routine['time'] as String;
    final activity = routine['activity'] as String;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isCompleted ? AppTheme.accentGreen.withOpacity(0.1) : AppTheme.cardBlue,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: isCompleted ? AppTheme.accentGreen : AppTheme.textSecondary,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            time,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              activity,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                decoration: isCompleted ? TextDecoration.lineThrough : null,
                color: isCompleted ? AppTheme.textSecondary : AppTheme.textPrimary,
              ),
            ),
          ),
          if (isCompleted)
            const Icon(
              Icons.check_rounded,
              color: AppTheme.accentGreen,
              size: 16,
            ),
        ],
      ),
    );
  }

  Widget _buildRoutineStatCard(String title, String value, IconData icon, Color color) {
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
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  IconData _getRuleIcon(String ruleName) {
    if (ruleName.contains('Evening')) return Icons.wb_twilight_rounded;
    if (ruleName.contains('Energy')) return Icons.battery_saver_rounded;
    if (ruleName.contains('Security')) return Icons.security_rounded;
    return Icons.auto_awesome_rounded;
  }

  String _formatTrigger(Map<String, dynamic> trigger) {
    final type = trigger['type'];
    final value = trigger['value'];

    switch (type) {
      case 'time':
        return 'At $value';
      case 'battery':
        return 'Battery below $value%';
      case 'motion':
        return 'Motion detected';
      default:
        return 'Unknown trigger';
    }
  }

  String _formatAction(Map<String, dynamic> action) {
    final devices = action['devices'] as List?;
    final actionType = action['action'];

    if (devices != null) {
      return '${actionType.toString().replaceAll('_', ' ')} ${devices.join(', ')}';
    }
    return actionType.toString();
  }

  String _formatLastExecuted(DateTime lastExecuted) {
    final now = DateTime.now();
    final difference = now.difference(lastExecuted);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  List<Map<String, String>> _getAIRecommendations() {
    return [
      {
        'title': 'Create Morning Routine',
        'description': 'AI detected you turn on lights and AC every morning at 7 AM. Create an automation?',
      },
      {
        'title': 'Optimize AC Usage',
        'description': 'Save ₹150/month by automatically adjusting AC temperature when you\'re away',
      },
      {
        'title': 'Night Security Mode',
        'description': 'Enable automatic security mode activation at 10 PM based on your sleep pattern',
      },
    ];
  }

  List<Map<String, String>> _getUsagePatterns() {
    return [
      {
        'pattern': 'Morning Routine (7:00-8:30 AM)',
        'details': 'Lights on → Coffee maker → AC adjustment → Music',
      },
      {
        'pattern': 'Evening Winddown (6:30-7:30 PM)',
        'details': 'Lights dimmed → AC cooled → TV on → Kitchen appliances',
      },
      {
        'pattern': 'Sleep Preparation (9:30-10:30 PM)',
        'details': 'Lights off → AC sleep mode → Security armed',
      },
    ];
  }

  List<Map<String, dynamic>> _getTodayRoutine() {
    return [
      {'time': '07:00', 'activity': 'Turn on morning lights', 'completed': true},
      {'time': '07:15', 'activity': 'Start coffee maker', 'completed': true},
      {'time': '07:30', 'activity': 'Adjust AC to 24°C', 'completed': true},
      {'time': '18:30', 'activity': 'Evening routine activation', 'completed': false},
      {'time': '22:00', 'activity': 'Night security mode', 'completed': false},
    ];
  }

  void _toggleRule(AutomationRule rule, bool value) {
    setState(() {
      final index = automationRules.indexWhere((r) => r.id == rule.id);
      if (index != -1) {
        automationRules[index] = AutomationRule(
          id: rule.id,
          name: rule.name,
          description: rule.description,
          isActive: value,
          trigger: rule.trigger,
          action: rule.action,
          lastExecuted: rule.lastExecuted,
        );
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(value ? 'Rule activated' : 'Rule deactivated'),
        backgroundColor: value ? AppTheme.accentGreen : AppTheme.accentRed,
      ),
    );
  }

  void _editRule(AutomationRule rule) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceBlue,
        title: const Text('Edit Rule'),
        content: Text('Edit functionality for "${rule.name}" will be implemented in full version.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _testRule(AutomationRule rule) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Testing rule: ${rule.name}'),
        backgroundColor: AppTheme.accentBlue,
      ),
    );
  }

  void _deleteRule(AutomationRule rule) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceBlue,
        title: const Text('Delete Rule'),
        content: Text('Are you sure you want to delete "${rule.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                automationRules.removeWhere((r) => r.id == rule.id);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Rule deleted'),
                  backgroundColor: AppTheme.accentRed,
                ),
              );
            },
            style: TextButton.styleFrom(foregroundColor: AppTheme.accentRed),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showCreateRuleDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceBlue,
        title: const Text('Create New Rule'),
        content: const Text('Rule creation wizard will be implemented in the full version.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showAIInsights() {
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
                'AI Insights',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 20),
              const Text('• Your energy usage peaks at 7-9 PM'),
              const Text('• Potential savings of ₹200/month with optimized AC usage'),
              const Text('• Morning routine is 85% consistent'),
              const Text('• Security system is most active during weekends'),
            ],
          ),
        ),
      ),
    );
  }
}