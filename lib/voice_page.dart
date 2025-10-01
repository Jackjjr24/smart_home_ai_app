import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'app_theme.dart';
import 'mock_data_service.dart';
import 'models.dart';

class VoicePage extends StatefulWidget {
  const VoicePage({super.key});

  @override
  State<VoicePage> createState() => _VoicePageState();
}

class _VoicePageState extends State<VoicePage> with TickerProviderStateMixin {
  late List<VoiceCommand> recentCommands;
  late AnimationController _pulseController;
  late AnimationController _waveController;

  bool isListening = false;
  bool isProcessing = false;
  String selectedLanguage = 'English';
  String currentCommand = '';
  double speechLevel = 0.0;

  final List<String> supportedLanguages = [
    'English',
    'Hindi (हिंदी)',
    'Tamil (தமிழ்)',
    'Telugu (తెలుగు)',
    'Marathi (मराठी)',
    'Bengali (বাংলা)',
  ];

  final List<String> quickCommands = [
    'Turn on living room lights',
    'Set AC to 24 degrees',
    'Turn off all devices',
    'Show energy usage',
    'Arm security system',
    'Play music in bedroom',
  ];

  @override
  void initState() {
    super.initState();
    recentCommands = MockDataService.getVoiceCommands();

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _waveController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _waveController.dispose();
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
                  'Voice Assistant',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppTheme.accentOrange.withOpacity(0.8),
                        AppTheme.accentYellow.withOpacity(0.6),
                        AppTheme.accentGreen.withOpacity(0.4),
                      ],
                    ),
                  ),
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.language_rounded),
                  onPressed: () {
                    _showLanguageSelector();
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.settings_voice_rounded),
                  onPressed: () {
                    _showVoiceSettings();
                  },
                ),
              ],
            ),

            // Main Content
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // Voice Interface
                  _buildVoiceInterface(),
                  const SizedBox(height: 24),

                  // Language Selection
                  _buildLanguageCard(),
                  const SizedBox(height: 24),

                  // Quick Commands
                  _buildQuickCommands(),
                  const SizedBox(height: 24),

                  // Recent Commands
                  _buildRecentCommands(),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVoiceInterface() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            // Voice Visualizer
            Stack(
              alignment: Alignment.center,
              children: [
                // Outer pulse ring
                AnimatedBuilder(
                  animation: _pulseController,
                  builder: (context, child) {
                    return Container(
                      width: 200 + (_pulseController.value * 50),
                      height: 200 + (_pulseController.value * 50),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppTheme.accentOrange.withOpacity(
                            0.3 * (1 - _pulseController.value),
                          ),
                          width: 2,
                        ),
                      ),
                    );
                  },
                ),

                // Middle wave ring
                AnimatedBuilder(
                  animation: _waveController,
                  builder: (context, child) {
                    return Container(
                      width: 160 + (_waveController.value * 30),
                      height: 160 + (_waveController.value * 30),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppTheme.accentOrange.withOpacity(
                            0.5 * (1 - _waveController.value),
                          ),
                          width: 3,
                        ),
                      ),
                    );
                  },
                ),

                // Main button
                GestureDetector(
                  onTap: _toggleListening,
                  onLongPress: _startContinuousListening,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: isListening
                            ? [AppTheme.accentRed, AppTheme.accentOrange]
                            : [AppTheme.accentOrange, AppTheme.accentYellow],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: (isListening ? AppTheme.accentRed : AppTheme.accentOrange).withOpacity(0.4),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Icon(
                      isListening ? Icons.mic_rounded : Icons.mic_none_rounded,
                      size: 48,
                      color: Colors.white,
                    ),
                  ),
                ).animate().scale(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Status Text
            Text(
              _getStatusText(),
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: isListening ? AppTheme.accentOrange : AppTheme.textPrimary,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 8),

            Text(
              _getSubtitleText(),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 24),

            // Command display
            if (currentCommand.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.accentOrange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text(
                      'Recognized Command:',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      currentCommand,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppTheme.accentOrange,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 16),

            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActionButton(
                  Icons.help_rounded,
                  'Help',
                      () => _showVoiceHelp(),
                ),
                _buildActionButton(
                  Icons.history_rounded,
                  'History',
                      () => _showCommandHistory(),
                ),
                _buildActionButton(
                  Icons.tune_rounded,
                  'Settings',
                      () => _showVoiceSettings(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.accentOrange.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppTheme.accentOrange),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.language_rounded, color: AppTheme.accentGreen),
                const SizedBox(width: 12),
                Text(
                  'Language Settings',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Current Language: $selectedLanguage',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Supported: ${supportedLanguages.length} languages',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _showLanguageSelector,
              icon: const Icon(Icons.swap_horiz_rounded),
              label: const Text('Change Language'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.accentGreen,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickCommands() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Commands',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 2.5,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: quickCommands.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () => _executeQuickCommand(quickCommands[index]),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Icon(
                        _getCommandIcon(quickCommands[index]),
                        color: AppTheme.accentBlue,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          quickCommands[index],
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildRecentCommands() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Recent Commands',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const Spacer(),
            TextButton(
              onPressed: () {
                setState(() {
                  recentCommands.clear();
                });
              },
              child: const Text('Clear All'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        recentCommands.isEmpty
            ? _buildEmptyCommandsView()
            : ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: recentCommands.length,
          itemBuilder: (context, index) {
            return _buildCommandCard(recentCommands[index]);
          },
        ),
      ],
    );
  }

  Widget _buildEmptyCommandsView() {
    return Center(
      child: Column(
        children: [
          Icon(
            Icons.mic_off_rounded,
            size: 64,
            color: AppTheme.textSecondary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No recent commands',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start speaking to see your commands here',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget _buildCommandCard(VoiceCommand command) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: (command.wasSuccessful ? AppTheme.accentGreen : AppTheme.accentRed).withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                command.wasSuccessful ? Icons.check_rounded : Icons.error_rounded,
                color: command.wasSuccessful ? AppTheme.accentGreen : AppTheme.accentRed,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    command.command,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppTheme.accentBlue.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          command.language,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.accentBlue,
                            fontSize: 10,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _formatCommandTime(command.timestamp),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  if (command.response != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Response: ${command.response}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondary,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            IconButton(
              onPressed: () => _repeatCommand(command.command),
              icon: const Icon(Icons.replay_rounded, size: 18),
            ),
          ],
        ),
      ),
    );
  }

  String _getStatusText() {
    if (isProcessing) return 'Processing...';
    if (isListening) return 'Listening...';
    return 'Tap to speak';
  }

  String _getSubtitleText() {
    if (isProcessing) return 'Understanding your command';
    if (isListening) return 'Say your command now';
    return 'Long press for continuous listening';
  }

  IconData _getCommandIcon(String command) {
    if (command.contains('light')) return Icons.lightbulb_rounded;
    if (command.contains('AC') || command.contains('temperature')) return Icons.ac_unit_rounded;
    if (command.contains('device')) return Icons.power_settings_new_rounded;
    if (command.contains('energy')) return Icons.bolt_rounded;
    if (command.contains('security')) return Icons.security_rounded;
    if (command.contains('music')) return Icons.music_note_rounded;
    return Icons.mic_rounded;
  }

  String _formatCommandTime(DateTime timestamp) {
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

  void _toggleListening() {
    setState(() {
      isListening = !isListening;
    });

    if (isListening) {
      _pulseController.repeat();
      _waveController.repeat();
      _startListening();
    } else {
      _pulseController.stop();
      _waveController.stop();
      _stopListening();
    }
  }

  void _startContinuousListening() {
    // Implement continuous listening mode
    _toggleListening();
  }

  void _startListening() {
    // Simulate voice recognition
    Future.delayed(const Duration(seconds: 2), () {
      if (isListening) {
        setState(() {
          isListening = false;
          isProcessing = true;
          currentCommand = 'Turn on the living room lights';
        });

        _pulseController.stop();
        _waveController.stop();

        Future.delayed(const Duration(seconds: 1), () {
          setState(() {
            isProcessing = false;
          });

          _addToRecentCommands();
          _showCommandResult();
        });
      }
    });
  }

  void _stopListening() {
    // Stop voice recognition
  }

  void _addToRecentCommands() {
    final newCommand = VoiceCommand(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      command: currentCommand,
      language: selectedLanguage,
      timestamp: DateTime.now(),
      wasSuccessful: true,
      response: 'Living room lights turned on',
    );

    setState(() {
      recentCommands.insert(0, newCommand);
      if (recentCommands.length > 10) {
        recentCommands.removeLast();
      }
    });
  }

  void _executeQuickCommand(String command) {
    setState(() {
      currentCommand = command;
      isProcessing = true;
    });

    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        isProcessing = false;
      });

      _addToRecentCommands();
      _showCommandResult();
    });
  }

  void _repeatCommand(String command) {
    _executeQuickCommand(command);
  }

  void _showCommandResult() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Command executed: $currentCommand'),
        backgroundColor: AppTheme.accentGreen,
        action: SnackBarAction(
          label: 'Undo',
          textColor: Colors.white,
          onPressed: () {
            // Implement undo functionality
          },
        ),
      ),
    );

    setState(() {
      currentCommand = '';
    });
  }

  void _showLanguageSelector() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: AppTheme.surfaceBlue,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
                    'Select Language',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 20),
                  ...supportedLanguages.map((language) =>
                      ListTile(
                        title: Text(language),
                        trailing: selectedLanguage == language
                            ? const Icon(Icons.check_rounded, color: AppTheme.accentGreen)
                            : null,
                        onTap: () {
                          setState(() {
                            selectedLanguage = language;
                          });
                          Navigator.pop(context);
                        },
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

  void _showVoiceSettings() {
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
                'Voice Settings',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 24),

              // Voice settings options
              _buildVoiceSettingItem('Wake Word Detection', 'Listen for "Hey Smart Home"', true),
              _buildVoiceSettingItem('Continuous Listening', 'Keep microphone active', false),
              _buildVoiceSettingItem('Voice Feedback', 'Provide audio responses', true),
              _buildVoiceSettingItem('Noise Cancellation', 'Filter background noise', true),
              _buildVoiceSettingItem('Auto Language Detection', 'Detect language automatically', false),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVoiceSettingItem(String title, String subtitle, bool value) {
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

  void _showVoiceHelp() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceBlue,
        title: const Text('Voice Commands Help'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Device Control:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('• "Turn on/off [device name]"'),
              Text('• "Set AC to [temperature] degrees"'),
              Text('• "Dim the lights to [percentage]"'),
              SizedBox(height: 16),
              Text('Information:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('• "Show energy usage"'),
              Text('• "What\'s the temperature?"'),
              Text('• "Security status"'),
              SizedBox(height: 16),
              Text('Navigation:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('• "Go to [page name]"'),
              Text('• "Show device controls"'),
              Text('• "Open energy management"'),
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

  void _showCommandHistory() {
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
              child: Row(
                children: [
                  Text(
                    'Command History',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        recentCommands.clear();
                      });
                      Navigator.pop(context);
                    },
                    child: const Text('Clear All'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: recentCommands.length,
                itemBuilder: (context, index) {
                  return _buildCommandCard(recentCommands[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}