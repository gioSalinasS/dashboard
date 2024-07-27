import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dashboard/pages/widgets/conection.dart';

class FloatingButton extends StatelessWidget {
  const FloatingButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16.w),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
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
        ),
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Conexión Bluetooth'),
                content: const Conection(),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cerrar'),
                  ),
                ],
              );
            },
          );
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.link, size: 55.r), 
            SizedBox(width: 10.w),
            const Text('Conectar'),
          ],
        ),
      ),
    );
  }
}
