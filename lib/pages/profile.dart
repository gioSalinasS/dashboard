import 'dart:ui';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dashboard/pages/widgets/connection_button.dart';
import 'package:dashboard/pages/widgets/header.dart';
import 'package:dashboard/pages/widgets/navigation_panel.dart';
import 'package:dashboard/pages/widgets/status_panel.dart';
import 'package:dashboard/pages/widgets/signin_button.dart';
import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  const Profile(this.username, {Key? key, required this.imagePath})
      : super(key: key);
  final String username;
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/background_image.jpeg',
            fit: BoxFit.cover,
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: Container(
              color: Colors.black.withOpacity(0), 
            ),
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > constraints.maxHeight) {
                // Horizontal Layout
                return Row(
                  children: [
                    NavigationPanel(isHorizontal: true, imagePath: imagePath),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.all(20.w),
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.all(25.w),
                                child: Column(
                                  children: [
                                    Header(showProfilePicture: false, user: "", imagePath: imagePath),
                                    SizedBox(height: 85.h),
                                    const StatusPanels(isHorizontal: true),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  const FloatingButton(),
                                  SizedBox(width: 28.w),
                                  const LogoutButton(),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              } else {
                // Vertical Layout
                return Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.all(80.w),
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.all(50.w),
                                child: Column(
                                  children: [
                                    Header(showProfilePicture: true, user: username, imagePath: imagePath),
                                    SizedBox(height: 85.h),
                                    const StatusPanels(isHorizontal: false),
                                  ],
                                ),
                              ),
                              SizedBox(height: 20.h),
                              Row(
                                children: [
                                  const FloatingButton(),
                                  SizedBox(width: 28.w),
                                  const LogoutButton(),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    NavigationPanel(isHorizontal: false, imagePath: imagePath),
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
