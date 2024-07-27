import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:dashboard/services/bluetooth_provider.dart';

class NavigationPanel extends StatelessWidget {
  final bool isHorizontal;
  final String imagePath;

  const NavigationPanel({Key? key, 
    required this.isHorizontal,
    required this.imagePath,
    }) : super(key: key);

  void _showModal(BuildContext context, String room) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final bluetoothProvider = Provider.of<BluetoothProvider>(context);
        final ButtonStyle commonButtonStyle = ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(115, 0, 0, 0), 
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(33.r), 
          ),
          padding: EdgeInsets.symmetric(horizontal: 36.w, vertical: 39.h),
          shadowColor: Colors.black.withOpacity(0.2),
          elevation: 10,
          textStyle: TextStyle(
            fontSize: 25.sp,
            fontWeight: FontWeight.bold,
          ),
        );

        return AlertDialog(
          contentPadding: EdgeInsets.all(30.w),
          content: Row(
            children: [
              Expanded(
                child: Image.asset('assets/$room.jpg'), 
              ),
              SizedBox(width: 20.w),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      style: commonButtonStyle,
                      onPressed: () => bluetoothProvider.servoStatus(5),
                      child: Text('Persianas', style: TextStyle(fontSize: 20.sp)),
                    ),
                    SizedBox(height: 10.h),
                    ElevatedButton(
                      style: commonButtonStyle,
                      onPressed: () => bluetoothProvider.servoStatus(6),
                      child: Text('Puerta', style: TextStyle(fontSize: 20.sp)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isHorizontal) {
      return Container(
        width: 150.w,
        color: const Color.fromARGB(129, 66, 66, 66),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            CircleAvatar(
              radius: 60.r,
              backgroundImage: FileImage(File(imagePath)), 
            ),
            NavItem(icon: Icons.kitchen, label: 'Cocina', onPressed: () { _showModal(context, 'kitchen'); }),
            NavItem(icon: Icons.weekend, label: 'Sala', onPressed: () { _showModal(context, 'livingRoom'); }),
            NavItem(icon: Icons.bed, label: 'Habitación', onPressed: () { _showModal(context, 'room'); }),
            NavItem(icon: Icons.bathtub, label: 'Baño', onPressed: () { _showModal(context, 'bathtub'); }),
          ],
        ),
      );
    } else {
      return Container(
        height: 150.h,
        color: const Color.fromARGB(129, 66, 66, 66),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            NavItem(icon: Icons.kitchen, label: 'Cocina', onPressed: () { _showModal(context, 'kitchen'); }),
            NavItem(icon: Icons.weekend, label: 'Sala', onPressed: () { _showModal(context, 'livingRoom'); }),
            NavItem(icon: Icons.bed, label: 'Habitación', onPressed: () { _showModal(context, 'room'); }),
            NavItem(icon: Icons.bathtub, label: 'Baño', onPressed: () { _showModal(context, 'bathtub'); }),
          ],
        ),
      );
    }
  }
}

class NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const NavItem({Key? key, required this.icon, required this.label, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 70.r),
          Text(label, style: TextStyle(color: Colors.white, fontSize: 15.sp)),
        ],
      ),
    );
  }
}
