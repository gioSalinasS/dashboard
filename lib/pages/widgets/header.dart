import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Header extends StatelessWidget {
  final bool showProfilePicture;
  final String user;
  final String imagePath;

  const Header({Key? key,   
    this.showProfilePicture = false, 
    required this.user, 
    required this.imagePath
    }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        if (showProfilePicture) ...[
          ProfilePicture(image: imagePath),
          SizedBox(width: 50.w),
        ],
        Expanded(
          child: Text(
            '¡Bienvenido, $user !',
            style: TextStyle(fontSize: 28.sp, fontWeight: FontWeight.bold),
          ),
        ),
        Text(
          'Viernes\n19 de julio 2024',
          textAlign: TextAlign.right,
          style: TextStyle(fontSize: 16.sp),
        ),
      ],
    );
  }
}

class ProfilePicture extends StatelessWidget {
  final String image;

  const ProfilePicture({Key? key, required this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 50.w,
      backgroundImage: FileImage(File(image)),
    );
  }
}
