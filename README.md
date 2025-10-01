# Smart Home AI 🏠📱

<div align="center">
  <!-- <img src="assets/images/app_logo.png" alt="Smart Home AI Logo" width="120" height="120"> --!>
  
  <h3>Intelligent Home Automation at Your Fingertips</h3>
  <p><em>A modern Flutter application for comprehensive smart home management</em></p>
</div>

## 📖 Overview

Smart Home AI is a cutting-edge Flutter application that transforms how you interact with your smart home ecosystem. Built with modern design principles and user-centric approach, the app provides real-time monitoring, intelligent device control, and comprehensive energy management capabilities.

### 🎯 Key Highlights
- **Intuitive Interface**: Clean, responsive design optimized for all devices
- **Real-time Monitoring**: Live updates for all connected devices and systems
- **Energy Intelligence**: Advanced analytics for consumption and generation
- **Security Integration**: Comprehensive monitoring and alert system
- **Cross-platform**: Available on Android and iOS

## ✨ Features

### 🎮 Device Management
- **Quick Controls**: Instant device toggle and management with haptic feedback
- **Room Organization**: Devices grouped by rooms for easy navigation
- **Status Indicators**: Real-time online/offline status with visual indicators
- **Power Monitoring**: Live power consumption tracking for each device

### ⚡ Energy Intelligence
- **Consumption Analytics**: Detailed energy usage patterns and trends
- **Solar Integration**: Real-time solar generation monitoring
- **Battery Management**: Smart battery level tracking and optimization
- **Cost Analysis**: Energy cost breakdown and savings insights

### 🔒 Security & Safety
- **Real-time Alerts**: Instant notifications for security events
- **System Status**: Comprehensive security system monitoring
- **Event History**: Detailed logs of all security activities
- **Emergency Controls**: Quick access to emergency functions

### 📊 Smart Analytics
- **Interactive Charts**: Beautiful data visualization with fl_chart
- **Historical Data**: Trend analysis and historical comparisons
- **Predictive Insights**: AI-powered usage predictions
- **Export Options**: Data export for external analysis

## 📱 Download & Installation

### 📲 Quick Install (Recommended)

**Download the latest APK:**

[![Download APK](https://img.shields.io/badge/Download-APK-brightgreen?style=for-the-badge&logo=android)](https://github.com/Jackjjr24/smart_home_ai_app/raw/main/smart_home_ai.apk)



> **Note**: Enable "Unknown Sources" in your Android settings to install the APK.

### 🛠️ Build from Source

## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/your-username/smart_home_ai.git
   ```
2. Navigate to the project directory:
   ```bash
   cd smart_home_ai
   ```
3. Install dependencies:
   ```bash
   flutter pub get
   ```
4. Run the app:
   ```bash
   flutter run
   ```

## 🏗️ Project Architecture

```
smart_home_ai/
├── lib/
│   ├── models/          
│   │   ├── device.dart  
│   │   ├── energy.dart  
│   │   └── security.dart 
│   ├── pages/            
│   │   ├── home_page.dart     
│   │   ├── devices_page.dart  
│   │   └── settings_page.dart  
│   ├── services/         
│   │   ├── mock_data_service.dart  
│   │   └── api_service.dart        
│   ├── theme/            
│   │   └── app_theme.dart  
│   ├── widgets/          
│   │   ├── device_card.dart    
│   │   ├── energy_chart.dart    
│   │   └── status_cards.dart    
│   └── main.dart         
├── assets/               
│   └── fonts/            
├── android/              
├── ios/                  
└── pubspec.yaml          
```

## 📦 Dependencies

### Core Framework
- **[Flutter](https://flutter.dev/)** - Google's UI toolkit for cross-platform development
- **[Dart](https://dart.dev/)** - Programming language optimized for UI development

### Key Packages
- **[fl_chart](https://pub.dev/packages/fl_chart)** `^0.68.0` - Beautiful and customizable charts
- **[material_design_icons_flutter](https://pub.dev/packages/material_design_icons_flutter)** - Comprehensive icon library
- **[shared_preferences](https://pub.dev/packages/shared_preferences)** - Local data persistence

### Development Tools
- **[flutter_launcher_icons](https://pub.dev/packages/flutter_launcher_icons)** - App icon generation
- **[flutter_native_splash](https://pub.dev/packages/flutter_native_splash)** - Splash screen customization

> For a complete list of dependencies, see [`pubspec.yaml`](pubspec.yaml)

## 🤝 Contributing

We welcome contributions from the community! Whether it's bug fixes, feature enhancements, or documentation improvements, your help is appreciated.

### 🚀 How to Contribute

1. **Fork the repository**
   ```bash
   git fork https://github.com/your-username/smart_home_ai.git
   ```

2. **Clone your fork**
   ```bash
   git clone https://github.com/your-username/smart_home_ai.git
   cd smart_home_ai
   ```

3. **Create a feature branch**
   ```bash
   git checkout -b feature/awesome-new-feature
   ```

4. **Make your changes**
   - Follow the existing code style
   - Add tests for new features
   - Update documentation as needed

5. **Commit your changes**
   ```bash
   git commit -m "feat: add awesome new feature"
   ```

6. **Push to your fork**
   ```bash
   git push origin feature/awesome-new-feature
   ```

7. **Create a Pull Request**
   - Provide a clear description of your changes
   - Reference any related issues
   - Ensure all tests pass

### 📋 Contribution Guidelines

- **Code Style**: Follow Dart/Flutter conventions
- **Commits**: Use conventional commit messages
- **Testing**: Include tests for new features
- **Documentation**: Update README and code comments
- **Issues**: Use issue templates when reporting bugs

---

<div align="center">
  <h3>🌟 Star this repository if you found it helpful! 🌟</h3>
  <p><strong>Smart Home AI</strong> - Making home automation accessible to everyone</p>
  <p>Built with ❤️ using Flutter</p>
</div>
