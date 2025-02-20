import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tradeunitec/pantallas/rutas.dart';
import 'package:tradeunitec/widgets/custom_input.dart';

class Login extends StatelessWidget {
  Login({super.key});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> _login(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      Get.snackbar("Éxito", "Inicio de sesión exitoso",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white);
      Navigator.pop(context);
    } catch (e) {
      Get.snackbar("Error", "Correo o contraseña incorrectos",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login', style: TextStyle(color: Colors.white)),
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
                  controller: emailController,
                  validator: (valor) {
                    if (valor == null || valor.isEmpty) {
                      return 'El correo es obligatorio';
                    }
                    return null;
                  },
                  teclado: TextInputType.emailAddress,
                  hint: 'Ingrese su correo electrónico',
                  nombrelabel: 'Correo electrónico',
                  icono: Icons.email,
                  show: false,
                ),
                const SizedBox(height: 15),
                PasswordInput(
                  controller: passwordController,
                  validator: (valor) {
                    if (valor == null || valor.isEmpty) {
                      return 'La contraseña es obligatoria';
                    }
                    return null;
                  },
                  nombrelabel: 'Contraseña',
                  hint: 'Ingrese su contraseña',
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 15),
                    textStyle: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  child: const Text('Login',
                      style: TextStyle(color: Colors.white)),
                  onPressed: () => _login(context),
                ),
                const SizedBox(height: 20),
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: const Color.fromARGB(255, 0, 0, 0),
                    textStyle: const TextStyle(
                        fontSize: 16, decoration: TextDecoration.underline),
                  ),
                  child: const Text('No tienes una cuenta? Regístrate'),
                  onPressed: () {
                    Navigator.pushNamed(context, MyRoutes.Logon.name);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
