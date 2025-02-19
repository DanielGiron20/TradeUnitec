import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tradeunitec/widgets/custom_input.dart';
import 'package:tradeunitec/widgets/loading_dialog.dart';

class Logon extends StatelessWidget {
  Logon({super.key});
  final _nombreController = TextEditingController();
  final _correoController = TextEditingController();
  final _contrasenaController = TextEditingController();
  final _numeroController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final loadingDialog = LoadingDialog();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title:
              const Text('Regístrate', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.blueAccent,
          centerTitle: true,
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.blueAccent.shade100, Colors.blueAccent.shade400],
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomInputs(
                    controller: _nombreController,
                    validator: (valor) {
                      if (valor == null || valor.isEmpty) {
                        return 'El nombre es obligatorio';
                      }
                      if (valor.length > 20) {
                        return 'El nombre no puede tener más de 20 caracteres';
                      }
                      if (valor.length < 3) {
                        return 'El nombre debe tener al menos 3 caracteres';
                      }
                      return null;
                    },
                    teclado: TextInputType.text,
                    hint: 'Ingrese el nombre de vendedor',
                    nombrelabel: 'Nombre de vendedor',
                    icono: Icons.person,
                    show: false, // No es campo de contraseña
                  ),
                  CustomInputs(
                    controller: _correoController,
                    validator: (valor) {
                      if (valor == null || valor.isEmpty) {
                        return 'El correo es obligatorio';
                      }
                      if (!GetUtils.isEmail(valor.trim())) {
                        return 'El correo no es válido';
                      }
                      if (!valor.trim().endsWith('@unah.hn') &&
                          !valor.trim().endsWith('@unah.edu.hn')) {
                        return 'El correo debe ser un correo institucional de la UNAH';
                      }
                      return null;
                    },
                    teclado: TextInputType.emailAddress,
                    hint: 'Ingrese su correo electrónico',
                    nombrelabel: 'Correo electrónico',
                    icono: Icons.email,
                    show: false,
                  ),
                  CustomInputs(
                    controller: _numeroController,
                    validator: (valor) {
                      if (valor == null || valor.isEmpty) {
                        return 'El numero es obligatorio';
                      }
                      if (valor.length != 8) {
                        return 'El numero debe tener 8 digitos';
                      }
                      return null;
                    },
                    teclado: TextInputType.number,
                    hint: 'Ingrese su numero',
                    nombrelabel: 'Numero',
                    icono: Icons.phone,
                    show: false,
                  ),
                  PasswordInput(
                    controller: _contrasenaController,
                    validator: (valor) {
                      if (valor == null || valor.isEmpty) {
                        return 'La contraseña es obligatoria';
                      }
                      if (valor.length < 6) {
                        return 'La contraseña debe tener al menos 6 caracteres';
                      }
                      return null;
                    },
                    nombrelabel: 'Contraseña',
                    hint: 'Ingrese su contraseña',
                  ),
                  Container(
                    margin: const EdgeInsets.all(20),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 15),
                        textStyle: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      child: const Text('Registrarse',
                          style: TextStyle(color: Colors.white)),
                      onPressed: () {
                        registerSeller(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> registerSeller(BuildContext context) async {
    if (!_formKey.currentState!.validate()) {
      Get.snackbar('Error', 'Por favor complete los campos correctamente',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    loadingDialog.show(context);
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _correoController.text.trim(),
        password: _contrasenaController.text.trim(),
      );
      await userCredential.user!.sendEmailVerification();

      await FirebaseFirestore.instance.collection('sellers').add({
        'uid': userCredential.user!.uid,
        'name': _nombreController.text.trim(),
        'correo': _correoController.text.trim(),
        'numero': _numeroController.text.trim(),
      });

      _formKey.currentState!.reset();

      Get.snackbar(
        'Confirmación de correo',
        'Se ha enviado un correo de verificación. Revisa tu correo antes de continuar.',
        backgroundColor: const Color.fromARGB(255, 33, 46, 127),
        colorText: Colors.white,
      );
      loadingDialog.hide(context);
      Navigator.pop(context);
    } catch (e) {
      loadingDialog.hide(context);
      Get.snackbar('Error', 'Error al registrar el vendedor: ${e.toString()}',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }
}
