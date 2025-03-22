import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tradeunitec/Basededatos/db_helper.dart';
import 'package:tradeunitec/Basededatos/usuario.dart';
import 'package:tradeunitec/pantallas/rutas.dart';
import 'package:tradeunitec/widgets/custom_input.dart';

class Login extends StatelessWidget {
  Login({super.key});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> _login(BuildContext context) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text,
      );
      User? user = FirebaseAuth.instance.currentUser;
      await user?.reload();
      if (user != null) {
        String userId = userCredential.user?.uid ?? '';
        final QuerySnapshot userQuery = await FirebaseFirestore.instance
            .collection('users')
            .where('uid', isEqualTo: userId)
            .limit(1)
            .get();

        if (userQuery.docs.isEmpty) {
          Get.snackbar('Error', 'Usuario no encontrado',
              backgroundColor: Colors.red, colorText: Colors.white);
          Navigator.of(context).pop();
          return;
        } else {
          final userData = userQuery.docs.first.data() as Map<String, dynamic>;

          // Crear el objeto Usuario con los datos obtenidos
          Usuario usuario = Usuario(
            id: userQuery.docs.first.id,
            uid: userId,
            name: userData['name'] ?? '',
            email: emailController.text.trim(),
            description: userData['description'] ?? '',
            logo: userData['logo'] ?? '',
            phoneNumber: userData['numero'] ?? '',
            cedula: userData['cedula'] ?? '',
          );

          await DbHelper().insertUser(usuario);

          Get.snackbar('Éxito', 'Inicio de sesión exitoso',
              backgroundColor: Colors.green, colorText: Colors.white);
          Navigator.of(context).pop(usuario);
        }
      } else {
        Get.snackbar('Error', 'Por favor, confirma el correo de verificación.',
            backgroundColor: Colors.red, colorText: Colors.white);
        Navigator.of(context).pop();
      }
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Error', 'Error de inicio de sesión: ${e.message}');
    } catch (e) {
      Get.snackbar('Error', 'Error inesperado: $e',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Iniciar Sesión',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF003366), // Azul Unitec
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF003366), // Azul Unitec
              Color.fromARGB(255, 23, 84, 188),
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo o icono de la aplicación
                  const Icon(
                    Icons.person,
                    size: 80,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 20),
                  // Título
                  const Text(
                    'Bienvenido',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Inicia sesión para continuar',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Campo de correo electrónico
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
                  const SizedBox(height: 20),
                  // Campo de contraseña
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
                  const SizedBox(height: 30),
                  // Botón de inicio de sesión
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color.fromARGB(255, 225, 38, 5), // Rojo
                      foregroundColor: Colors.white, // Texto blanco
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 5,
                    ),
                    onPressed: () => _login(context),
                    child: const Text(
                      'Iniciar Sesión',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Enlace para registrarse
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      textStyle: const TextStyle(
                        fontSize: 16,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, MyRoutes.Logon.name);
                    },
                    child: const Text('¿No tienes una cuenta? Regístrate'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
