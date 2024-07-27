import 'package:dashboard/locator.dart';
import 'package:dashboard/pages/models/user.model.dart';
import 'package:dashboard/pages/profile.dart';
import 'package:dashboard/pages/widgets/app_button.dart';
import 'package:dashboard/pages/widgets/app_text_field.dart';
import 'package:dashboard/services/camera.service.dart';
import 'package:flutter/material.dart';

class SignInSheet extends StatelessWidget {
  SignInSheet({Key? key, required this.user}) : super(key: key);
  final User user;

  final _passwordController = TextEditingController();
  final _cameraService = locator<CameraService>();

  Future _signIn(context, user) async {
    if (user.password == _passwordController.text) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => Profile(
                    user.user,
                    imagePath: _cameraService.imagePath!,
                  )));
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            content: Text('Contraseña incorrecta!'),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Text(
              'Bienvenido de nuevo, ' + user.user + '.',
              style: TextStyle(fontSize: 20),
            ),
          ),
          Container(
            child: Column(
              children: [
                SizedBox(height: 10),
                AppTextField(
                  controller: _passwordController,
                  labelText: "Contraseña",
                  isPassword: true,
                ),
                const SizedBox(height: 10),
                const Divider(),
                const SizedBox(height: 10),
                AppButton(
                  text: 'Inicio de sesión',
                  onPressed: () async {
                    _signIn(context, user);
                  },
                  icon: const Icon(
                    Icons.login,
                    color: Colors.white,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
