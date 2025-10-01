import 'dart:math';
import 'models.dart';

class MockDataService {
  static final Random _random = Random();

  static List<Device> getDevices() {
    return [
      // Living Room Devices
      Device(
        id: '1',
        name: 'Smart TV',
        type: 'entertainment',
        room: 'Living Room',
        isOnline: true,
        isOn: false,
        iconPath: 'tv',
        powerConsumption: 150.0,
        properties: {'volume': 30, 'channel': 'Netflix'},
      ),
      Device(
        id: '2',
        name: 'AC Unit',
        type: 'climate',
        room: 'Living Room',
        isOnline: true,
        isOn: true,
        iconPath: 'ac',
        powerConsumption: 1800.0,
        properties: {'temperature': 24, 'mode': 'cool'},
      ),
      Device(
        id: '3',
        name: 'Ceiling Fan',
        type: 'climate',
        room: 'Living Room',
        isOnline: true,
        isOn: true,
        iconPath: 'fan',
        powerConsumption: 75.0,
        properties: {'speed': 3},
      ),
      Device(
        id: '4',
        name: 'Smart Lights',
        type: 'lighting',
        room: 'Living Room',
        isOnline: true,
        isOn: true,
        iconPath: 'light',
        powerConsumption: 20.0,
        properties: {'brightness': 80, 'color': 'warm_white'},
      ),

      // Kitchen Devices
      Device(
        id: '5',
        name: 'Refrigerator',
        type: 'appliance',
        room: 'Kitchen',
        isOnline: true,
        isOn: true,
        iconPath: 'fridge',
        powerConsumption: 200.0,
        properties: {'temperature': 4, 'mode': 'normal'},
      ),
      Device(
        id: '6',
        name: 'Microwave',
        type: 'appliance',
        room: 'Kitchen',
        isOnline: true,
        isOn: false,
        iconPath: 'microwave',
        powerConsumption: 1200.0,
        properties: {'timer': 0},
      ),
      Device(
        id: '7',
        name: 'Water Heater',
        type: 'appliance',
        room: 'Kitchen',
        isOnline: true,
        isOn: true,
        iconPath: 'water_heater',
        powerConsumption: 2000.0,
        properties: {'temperature': 45},
      ),

      // Bedroom Devices
      Device(
        id: '8',
        name: 'Bedroom AC',
        type: 'climate',
        room: 'Bedroom',
        isOnline: true,
        isOn: false,
        iconPath: 'ac',
        powerConsumption: 1500.0,
        properties: {'temperature': 26, 'mode': 'sleep'},
      ),
      Device(
        id: '9',
        name: 'Table Lamp',
        type: 'lighting',
        room: 'Bedroom',
        isOnline: true,
        isOn: false,
        iconPath: 'lamp',
        powerConsumption: 15.0,
        properties: {'brightness': 50},
      ),

      // Security Devices
      Device(
        id: '10',
        name: 'Front Door Camera',
        type: 'security',
        room: 'Entrance',
        isOnline: true,
        isOn: true,
        iconPath: 'camera',
        powerConsumption: 10.0,
        properties: {'recording': true, 'night_vision': true},
      ),
      Device(
        id: '11',
        name: 'Motion Sensor',
        type: 'security',
        room: 'Living Room',
        isOnline: true,
        isOn: true,
        iconPath: 'motion',
        powerConsumption: 2.0,
        properties: {'sensitivity': 'medium'},
      ),
    ];
  }

  static List<EnergyData> getEnergyData() {
    List<EnergyData> data = [];
    DateTime now = DateTime.now();

    for (int i = 23; i >= 0; i--) {
      DateTime time = now.subtract(Duration(hours: i));
      data.add(EnergyData(
        timestamp: time,
        solarGeneration: _random.nextDouble() * 5 + 2, // 2-7 kWh
        gridConsumption: _random.nextDouble() * 3 + 1, // 1-4 kWh
        batteryLevel: 60 + _random.nextDouble() * 40, // 60-100%
        totalConsumption: _random.nextDouble() * 4 + 3, // 3-7 kWh
        cost: (_random.nextDouble() * 50 + 20), // ₹20-70
      ));
    }

    return data;
  }

  static List<SecurityEvent> getSecurityEvents() {
    return [
      SecurityEvent(
        id: '1',
        type: 'Motion Detected',
        description: 'Motion detected in Living Room',
        timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
        severity: 'low',
        isRead: false,
      ),
      SecurityEvent(
        id: '2',
        type: 'Door Opened',
        description: 'Front door opened',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        severity: 'medium',
        isRead: true,
      ),
      SecurityEvent(
        id: '3',
        type: 'Security Alert',
        description: 'Unknown person detected at entrance',
        timestamp: DateTime.now().subtract(const Duration(hours: 5)),
        severity: 'high',
        isRead: false,
      ),
    ];
  }

  static List<AutomationRule> getAutomationRules() {
    return [
      AutomationRule(
        id: '1',
        name: 'Evening Routine',
        description: 'Turn on lights and AC when sun sets',
        isActive: true,
        trigger: {'type': 'time', 'value': '18:30'},
        action: {'devices': ['lights', 'ac'], 'action': 'turn_on'},
        lastExecuted: DateTime.now().subtract(const Duration(hours: 1)),
      ),
      AutomationRule(
        id: '2',
        name: 'Energy Saver',
        description: 'Turn off non-essential devices when battery is low',
        isActive: true,
        trigger: {'type': 'battery', 'value': 20},
        action: {'devices': ['tv', 'microwave'], 'action': 'turn_off'},
      ),
      AutomationRule(
        id: '3',
        name: 'Security Mode',
        description: 'Activate all cameras and sensors at night',
        isActive: false,
        trigger: {'type': 'time', 'value': '22:00'},
        action: {'devices': ['cameras', 'sensors'], 'action': 'activate'},
      ),
    ];
  }

  static List<VoiceCommand> getVoiceCommands() {
    return [
      VoiceCommand(
        id: '1',
        command: 'Turn on the living room lights',
        language: 'English',
        timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
        wasSuccessful: true,
        response: 'Living room lights turned on',
      ),
      VoiceCommand(
        id: '2',
        command: 'बेडरूम का एसी चालू करो',
        language: 'Hindi',
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
        wasSuccessful: true,
        response: 'बेडरूम का एसी चालू कर दिया गया',
      ),
      VoiceCommand(
        id: '3',
        command: 'Set temperature to 22 degrees',
        language: 'English',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        wasSuccessful: true,
        response: 'Temperature set to 22 degrees',
      ),
    ];
  }

  static double getCurrentEnergyUsage() {
    return 3.2 + _random.nextDouble() * 1.5; // 3.2-4.7 kW
  }

  static double getSolarGeneration() {
    return 2.8 + _random.nextDouble() * 2.0; // 2.8-4.8 kW
  }

  static double getBatteryLevel() {
    return 75 + _random.nextDouble() * 20; // 75-95%
  }

  static Map<String, int> getDevicesByRoom() {
    return {
      'Living Room': 4,
      'Kitchen': 3,
      'Bedroom': 2,
      'Entrance': 2,
    };
  }

  static Map<String, double> getEnergyByCategory() {
    return {
      'Climate Control': 2.1,
      'Lighting': 0.3,
      'Appliances': 1.8,
      'Entertainment': 0.6,
      'Security': 0.1,
    };
  }
}