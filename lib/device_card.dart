import 'package:flutter/material.dart';
import 'models.dart';
import 'app_theme.dart';

class DeviceCard extends StatefulWidget {
  final Device device;
  final VoidCallback? onTap;
  final Function(bool)? onToggle;

  const DeviceCard({
    super.key,
    required this.device,
    this.onTap,
    this.onToggle,
  });

  @override
  State<DeviceCard> createState() => _DeviceCardState();
}

class _DeviceCardState extends State<DeviceCard> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isToggling = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _handleToggle() async {
    if (_isToggling) return;

    setState(() {
      _isToggling = true;
    });

    // Call the parent's toggle function
    widget.onToggle?.call(!widget.device.isOn);

    // Add a small delay for better UX
    await Future.delayed(const Duration(milliseconds: 300));

    setState(() {
      _isToggling = false;
    });
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

  @override
  Widget build(BuildContext context) {
    final deviceColor = _getDeviceColor(widget.device.type);
    final deviceIcon = _getDeviceIcon(widget.device.type);

    return GestureDetector(
      onTapDown: (_) => _animationController.forward(),
      onTapUp: (_) => _animationController.reverse(),
      onTapCancel: () => _animationController.reverse(),
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Card(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: widget.device.isOn
                      ? LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      deviceColor.withOpacity(0.1),
                      deviceColor.withOpacity(0.05),
                    ],
                  )
                      : null,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Top row with icon and status indicator
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: widget.device.isOn
                                ? deviceColor.withOpacity(0.2)
                                : AppTheme.textSecondary.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            deviceIcon,
                            color: widget.device.isOn ? deviceColor : AppTheme.textSecondary,
                            size: 20,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: widget.device.isOnline
                                ? (widget.device.isOn ? AppTheme.accentGreen : AppTheme.textSecondary)
                                : AppTheme.accentRed,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Device name
                    Text(
                      widget.device.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),

                    // Room name
                    Text(
                      widget.device.room,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: 11,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 8),

                    // Bottom row with status and toggle button
                    Row(
                      children: [
                        // Status text
                        Text(
                          widget.device.isOn ? 'ON' : 'OFF',
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: widget.device.isOn ? deviceColor : AppTheme.textSecondary,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        const Spacer(),

                        // Power consumption when on
                        if (widget.device.isOn && widget.device.powerConsumption > 0)
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: Text(
                              '${widget.device.powerConsumption.toInt()}W',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: deviceColor,
                                fontSize: 11,
                              ),
                            ),
                          ),

                        // Toggle switch
                        GestureDetector(
                          onTap: _handleToggle,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            width: 40,
                            height: 24,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: widget.device.isOn
                                  ? deviceColor
                                  : AppTheme.textSecondary.withOpacity(0.3),
                            ),
                            child: AnimatedAlign(
                              duration: const Duration(milliseconds: 300),
                              alignment: widget.device.isOn
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: Container(
                                margin: const EdgeInsets.all(2),
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 2,
                                      offset: const Offset(0, 1),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}