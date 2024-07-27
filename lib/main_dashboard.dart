import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(1080, 1920),
      minTextAdapt: true,
      builder: (context, child) => MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const HomeScreen(),
        theme: ThemeData(
          primarySwatch: Colors.blueGrey,
          textTheme: const TextTheme(
            bodyLarge: TextStyle(color: Colors.black),
            bodyMedium: TextStyle(color: Colors.black),
          ),
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

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
              color: Colors.black.withOpacity(0), // Puedes ajustar la opacidad si quieres un fondo semi-transparente.
            ),
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > constraints.maxHeight) {
                // Horizontal Layout
                return Row(
                  children: [
                    const NavigationPanel(isHorizontal: true),
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
                                    const Header(showProfilePicture: false),
                                    SizedBox(height: 85.h),
                                    const StatusPanels(isHorizontal: true),
                                  ],
                                ),
                              ),
                              SizedBox(height: 60.h),
                              const FloatingButton(),
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
                                    const Header(showProfilePicture: true),
                                    SizedBox(height: 85.h),
                                    const StatusPanels(isHorizontal: false),
                                  ],
                                ),
                              ),
                              SizedBox(height: 20.h),
                              const FloatingButton(),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const NavigationPanel(isHorizontal: false),
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

class NavigationPanel extends StatelessWidget {
  final bool isHorizontal;

  const NavigationPanel({Key? key, required this.isHorizontal}) : super(key: key);

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
              backgroundImage: const AssetImage('assets/avatar.png'), // Agrega tu imagen
            ),
            const NavItem(icon: Icons.kitchen, label: 'Cocina'),
            const NavItem(icon: Icons.weekend, label: 'Sala'),
            const NavItem(icon: Icons.bed, label: 'Habitación'),
            const NavItem(icon: Icons.bathtub, label: 'Baño'),
          ],
        ),
      );
    } else {
      return Container(
        height: 150.h,
        color: const Color.fromARGB(129, 66, 66, 66),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            NavItem(icon: Icons.kitchen, label: 'Cocina'),
            NavItem(icon: Icons.weekend, label: 'Sala'),
            NavItem(icon: Icons.bed, label: 'Habitación'),
            NavItem(icon: Icons.bathtub, label: 'Baño'),
          ],
        ),
      );
    }
  }
}

class NavItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const NavItem({Key? key, required this.icon, required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white, size: 70.r),
        Text(label, style: TextStyle(color: Colors.white, fontSize: 15.sp)),
      ],
    );
  }
}

class Header extends StatelessWidget {
  final bool showProfilePicture;

  const Header({Key? key, this.showProfilePicture = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        if (showProfilePicture) ...[
          const ProfilePicture(),
          SizedBox(width: 50.w),
        ],
        Expanded(
          child: Text(
            '¡Bienvenido, Usuario!',
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
  const ProfilePicture({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 50.w, // Tamaño ajustado
      backgroundImage: const AssetImage('assets/profile_picture.png'),
    );
  }
}

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
            StatusPanel(
              content: 'Bluetooth\nDesconectado',
              icon: Icons.bluetooth,
              width: panelWidth,
              isHorizontal: isHorizontal,
            ),
            StatusPanel(
              content: 'Ambiente\n25 ºC',
              icon: Icons.thermostat,
              width: panelWidth,
              isHorizontal: isHorizontal,
            ),
            StatusPanel(
              content: 'Puertas\nCerrada',
              icon: Icons.door_sliding_rounded,
              width: panelWidth,
              isHorizontal: isHorizontal,
            ),
            StatusPanel(
              content: 'Persianas\nCerrada',
              icon: Icons.blinds,
              width: panelWidth,
              isHorizontal: isHorizontal,
            ),
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 70.h, bottom: 30.h, left: 20.h), // Espacio antes y después del texto
                  child: Align(
                    alignment: Alignment.centerLeft, // Alinea el texto a la izquierda
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
                  content: isHorizontal ? 'Luces\nHabitaciones' : null, // Solo muestra el texto en modo horizontal
                  icon: Icons.light_mode_rounded,
                  width: controlPanelWidth, // Siempre muestra los botones de control
                  isHorizontal: isHorizontal,
                  child: ControlPanel( isHorizontal: isHorizontal),
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
  final String? content; // Modificado para permitir null
  final IconData icon;
  final double width;
  final Widget? child;
  final bool isHorizontal;

  const StatusPanel({
    Key? key,
    this.content, // Modificado para permitir null
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
                        fontSize: isHorizontal ? 20.sp : 30.sp, // Ajusta el tamaño del texto
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (content!.split('\n').length > 1) // Solo muestra la segunda línea si existe
                      TextSpan(
                        text: '\n${content!.split('\n')[1]}',
                        style: TextStyle(
                          fontSize: isHorizontal ? 16.sp : 26.sp, // Ajusta el tamaño del texto
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
            ControlButton(label: 'Cocina', isHorizontal: isHorizontal),
            SizedBox(width: 6.w),
            ControlButton(label: 'Sala de Estar', isHorizontal: isHorizontal),
          ],
        ),
        SizedBox(height: 16.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ControlButton(label: 'Baño', isHorizontal: isHorizontal),
            SizedBox(width: 28.w),
            ControlButton(label: 'Habitación', isHorizontal: isHorizontal),
          ],
        ),
      ],
    );
  }
}

class ControlButton extends StatelessWidget {
  final String label;
  final bool isHorizontal;

  const ControlButton({Key? key, 
  required this.label, 
  required this.isHorizontal
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isHorizontal ? Container(
      padding: EdgeInsets.symmetric(horizontal: 25.w),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 16.sp),
          ),
          SizedBox(width: 8.w),
          Switch(
            value: false,
            onChanged: (value) {},
          ),
        ],
      ),
    ) :
    Container(
      padding: EdgeInsets.symmetric(horizontal: 50.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 16.sp),
              ),
            ],
          ),
          SizedBox(height: 8.w),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Switch(
                value: false,
                onChanged: (value) {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class FloatingButton extends StatelessWidget {
  const FloatingButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16.w),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(115, 0, 0, 0), // Color de fondo del botón
          foregroundColor: Colors.white, // Color del texto
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(33.r), // Bordes redondeados
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
                title: const Text('Ventana Flotante'),
                content: const Text('Este es el contenido de la ventana flotante.'),
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
            Icon(Icons.link, size: 45.r), // Icono al lado del texto
            SizedBox(width: 10.w),
            const Text('Conectar'),
          ],
        ),
      ),
    );
  }
}

