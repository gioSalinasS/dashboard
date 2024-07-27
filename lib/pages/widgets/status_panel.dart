import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:dashboard/services/bluetooth_provider.dart';

class StatusPanels extends StatelessWidget {
  final bool isHorizontal;

  const StatusPanels({Key? key, required this.isHorizontal}) : super(key: key);

  

  @override
  Widget build(BuildContext context) {
    
    return LayoutBuilder(
      builder: (context, constraints) {
        double panelWidth;
        double controlPanelWidth;

        if (isHorizontal) {
          panelWidth = (constraints.maxWidth - 48.w) / 2;
          controlPanelWidth = panelWidth * 2 + 16.w;
        } else {
          panelWidth = constraints.maxWidth;
          controlPanelWidth = constraints.maxWidth;
        }

        return Wrap(
          spacing: 16.w,
          runSpacing: 16.h,
          alignment: WrapAlignment.center,
          children: [
            Consumer<BluetoothProvider>(
              builder: (context, bluetoothProvider, child) {
                return StatusPanel(
                  content: 'Conectado a: \n${bluetoothProvider.deviceConnected?.name ?? "Ninguno"}',
                  icon: Icons.thermostat,
                  width: panelWidth,
                  isHorizontal: isHorizontal,
                );
              },
            ),
            Consumer<BluetoothProvider>(
              builder: (context, bluetoothProvider, child) {
                return StatusPanel(
                  content: 'Ambiente\n${bluetoothProvider.temperature ?? "N/A"} ºC',
                  icon: Icons.thermostat,
                  width: panelWidth,
                  isHorizontal: isHorizontal,
                );
              },
            ),
            Consumer<BluetoothProvider>(
              builder: (context, bluetoothProvider, child) {
                return StatusPanel(
                  content: 'Humedad\n${bluetoothProvider.humedad ?? "N/A"} %',
                  icon: Icons.water,
                  width: panelWidth,
                  isHorizontal: isHorizontal,
                );
              },
            ),
            StatusPanel(
              content: 'Persianas\nCerradas',
              icon: Icons.blinds,
              width: panelWidth,
              isHorizontal: isHorizontal,
            ),
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 70.h, bottom: 30.h, left: 20.h), 
                  child: Align(
                    alignment: Alignment.centerLeft, 
                    child: Text(
                      'Casa',
                      style: TextStyle(
                        fontSize: 26.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                StatusPanel(
                  content: isHorizontal ? 'Luces\nHabitaciones' : null, 
                  icon: Icons.light_mode_rounded,
                  width: controlPanelWidth, 
                  isHorizontal: isHorizontal,
                  child: ControlPanel(isHorizontal: isHorizontal),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class StatusPanel extends StatelessWidget {
  final String? content; 
  final IconData icon;
  final double width;
  final Widget? child;
  final bool isHorizontal;

  const StatusPanel({
    Key? key,
    this.content, 
    required this.icon,
    required this.width,
    this.child,
    required this.isHorizontal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color.fromARGB(134, 207, 216, 220),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        children: [
          isHorizontal ? SizedBox(width: 2.w) : SizedBox(width: 40.w),
          Container(
            width: 85.w,
            height: 85.h,
            decoration: const BoxDecoration(
              color: Color.fromARGB(113, 144, 164, 174),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(icon, size: 60.r, color: Colors.white),
            ),
          ),
          isHorizontal ? SizedBox(width: 16.w) : SizedBox(width: 40.w),
          if (content != null) ...[
            Expanded(
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: content!.split('\n').first,
                      style: TextStyle(
                        fontSize: isHorizontal ? 20.sp : 30.sp, 
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (content!.split('\n').length > 1) 
                      TextSpan(
                        text: '\n${content!.split('\n')[1]}',
                        style: TextStyle(
                          fontSize: isHorizontal ? 16.sp : 26.sp, 
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
          if (child != null) ...[
            SizedBox(width: 16.w),
            child!,
          ],
        ],
      ),
    );
  }
}

class ControlPanel extends StatelessWidget {
  final bool isHorizontal;

  const ControlPanel({Key? key, required this.isHorizontal}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ControlButton(label: 'Cocina', isHorizontal: isHorizontal, led: 1),
            SizedBox(width: 6.w),
            ControlButton(label: 'Sala de Estar', isHorizontal: isHorizontal, led: 2),
          ],
        ),
        SizedBox(height: 16.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ControlButton(label: 'Baño', isHorizontal: isHorizontal, led: 3),
            SizedBox(width: 28.w),
            ControlButton(label: 'Habitación', isHorizontal: isHorizontal, led: 4),
          ],
        ),
      ],
    );
  }
}

class ControlButton extends StatefulWidget {
  final String label;
  final bool isHorizontal;
  final int led;

  const ControlButton({
    Key? key,
    required this.label,
    required this.isHorizontal,
    required this.led,
  }) : super(key: key);

  @override
  ControlButtonState createState() => ControlButtonState();
}

class ControlButtonState extends State<ControlButton> {
  bool _switchValue = false;
  

  @override
  Widget build(BuildContext context) {
    final bluetoothProvider = Provider.of<BluetoothProvider>(context);

    return widget.isHorizontal
        ? Container(
            padding: EdgeInsets.symmetric(horizontal: 25.w),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.label,
                  style: TextStyle(fontSize: 16.sp),
                ),
                SizedBox(width: 8.w),
                Switch(
                  value: _switchValue,
                  onChanged: (value) {
                    setState(() {
                      _switchValue = value;
                    });
                    bluetoothProvider.ledStatus(value, widget.led);
                  },
                ),
              ],
            ),
          )
        : Container(
            padding: EdgeInsets.symmetric(horizontal: 50.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.label,
                      style: TextStyle(fontSize: 16.sp),
                    ),
                  ],
                ),
                SizedBox(height: 8.w),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Switch(
                      value: _switchValue,
                      onChanged: (value) {
                        setState(() {
                          _switchValue = value;
                        });
                        bluetoothProvider.ledStatus(value, widget.led);
                      },
                    ),
                  ],
                ),
              ],
            ),
          );
  }
}
