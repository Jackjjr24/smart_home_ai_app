import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'app_theme.dart';
import 'home_page.dart';
import 'devices_page.dart';
import 'energy_page.dart';
import 'security_page.dart';
import 'voice_page.dart';
import 'automation_page.dart';
import 'settings_page.dart';
import 'mock_data_service.dart';
import 'voice_fab.dart'; // Add this import

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AppTheme.surfaceBlue,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  runApp(const SmartHomeApp());
}

class SmartHomeApp extends StatelessWidget {
  const SmartHomeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Smart Home AI',
      theme: AppTheme.darkTheme,
      home: const MainNavigationPage(),
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
    );
  }
}

// Navigation Controller for FAB
class MainNavigationController extends GetxController {
  final PageController pageController = PageController();
  final RxInt currentIndex = 0.obs;

  void changePage(int index) {
    currentIndex.value = index;
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
}

class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _currentIndex = 0;
  late PageController _pageController;

  // Remove VoicePage from pages list - now accessible via FAB
  final List<Widget> _pages = [
    const HomePage(),
    const DevicesPage(),
    const EnergyPage(),
    const SecurityPage(),
    const AutomationPage(),
    const SettingsPage(),
  ];

  // Remove Voice from navigation items (reduced from 7 to 6 items)
  final List<NavigationItem> _navigationItems = [
    NavigationItem(
      icon: Icons.home_rounded,
      label: 'Home',
      color: AppTheme.accentGreen,
    ),
    NavigationItem(
      icon: Icons.devices_rounded,
      label: 'Devices',
      color: AppTheme.accentBlue,
    ),
    NavigationItem(
      icon: Icons.bolt_rounded,
      label: 'Energy',
      color: AppTheme.accentYellow,
    ),
    NavigationItem(
      icon: Icons.security_rounded,
      label: 'Security',
      color: AppTheme.accentRed,
    ),
    NavigationItem(
      icon: Icons.auto_awesome_rounded,
      label: 'AI',
      color: AppTheme.lightBlue,
    ),
    NavigationItem(
      icon: Icons.settings_rounded,
      label: 'Settings',
      color: AppTheme.textSecondary,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    // Initialize the navigation controller
    Get.put(MainNavigationController());
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    // Update the controller
    Get.find<MainNavigationController>().currentIndex.value = index;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
          // Update the controller
          Get.find<MainNavigationController>().currentIndex.value = index;
        },
        children: _pages,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppTheme.surfaceBlue,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(
                _navigationItems.length,
                    (index) => _buildNavItem(index),
              ),
            ),
          ),
        ),
      ),
      // Add the universal floating action button
      floatingActionButton: const VoiceFAB(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildNavItem(int index) {
    final item = _navigationItems[index];
    final isSelected = _currentIndex == index;

    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? item.color.withOpacity(0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                item.icon,
                color: isSelected ? item.color : AppTheme.textSecondary,
                size: isSelected ? 26 : 22,
              ),
            ),
            const SizedBox(height: 4),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                color: isSelected ? item.color : AppTheme.textSecondary,
                fontSize: isSelected ? 11 : 10,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
              child: Text(item.label),
            ),
          ],
        ),
      ),
    );
  }
}

class NavigationItem {
  final IconData icon;
  final String label;
  final Color color;

  NavigationItem({
    required this.icon,
    required this.label,
    required this.color,
  });
}