class Device {
  final String id;
  final String name;
  final String type;
  final String room;
  final bool isOnline;
  final bool isOn;
  final String iconPath;
  final double powerConsumption; // in Watts
  final Map<String, dynamic> properties;

  Device({
    required this.id,
    required this.name,
    required this.type,
    required this.room,
    required this.isOnline,
    required this.isOn,
    required this.iconPath,
    required this.powerConsumption,
    this.properties = const {},
  });

  Device copyWith({
    String? id,
    String? name,
    String? type,
    String? room,
    bool? isOnline,
    bool? isOn,
    String? iconPath,
    double? powerConsumption,
    Map<String, dynamic>? properties,
  }) {
    return Device(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      room: room ?? this.room,
      isOnline: isOnline ?? this.isOnline,
      isOn: isOn ?? this.isOn,
      iconPath: iconPath ?? this.iconPath,
      powerConsumption: powerConsumption ?? this.powerConsumption,
      properties: properties ?? this.properties,
    );
  }
}

class EnergyData {
  final DateTime timestamp;
  final double solarGeneration; // kWh
  final double gridConsumption; // kWh
  final double batteryLevel; // percentage
  final double totalConsumption; // kWh
  final double cost; // in INR

  EnergyData({
    required this.timestamp,
    required this.solarGeneration,
    required this.gridConsumption,
    required this.batteryLevel,
    required this.totalConsumption,
    required this.cost,
  });
}

class SecurityEvent {
  final String id;
  final String type;
  final String description;
  final DateTime timestamp;
  final String severity; // low, medium, high, critical
  final String? imagePath;
  final bool isRead;

  SecurityEvent({
    required this.id,
    required this.type,
    required this.description,
    required this.timestamp,
    required this.severity,
    this.imagePath,
    this.isRead = false,
  });
}

class AutomationRule {
  final String id;
  final String name;
  final String description;
  final bool isActive;
  final Map<String, dynamic> trigger;
  final Map<String, dynamic> action;
  final DateTime? lastExecuted;

  AutomationRule({
    required this.id,
    required this.name,
    required this.description,
    required this.isActive,
    required this.trigger,
    required this.action,
    this.lastExecuted,
  });
}

class VoiceCommand {
  final String id;
  final String command;
  final String language;
  final DateTime timestamp;
  final bool wasSuccessful;
  final String? response;

  VoiceCommand({
    required this.id,
    required this.command,
    required this.language,
    required this.timestamp,
    required this.wasSuccessful,
    this.response,
  });
}