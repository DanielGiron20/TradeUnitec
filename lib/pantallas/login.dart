import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tradeunitec/Basededatos/usuario.dart';
import 'package:tradeunitec/Basededatos/usuario_controller.dart';
import 'package:tradeunitec/pantallas/rutas.dart';
import 'package:tradeunitec/widgets/custom_input.dart';

class Login extends StatelessWidget {
  Login({super.key});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> _login(BuildContext context) async {
    try {
      // Tomando los valores de la clase Logon

      // Autenticación mediante Firebase
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text,
      );
      User? user = FirebaseAuth.instance.currentUser;
      await user?.reload();
      if (user != null) {
        String userId = userCredential.user?.uid ?? '';
        print('ID del usuario: $userId');
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

          // Aquí extraemos los campos que existen en la colección Firestore
          String name = userData['name'] ?? '';
          String description = userData['description'] ?? '';
          String logo = userData['logo'] ?? '';
          String number = userData['numero'] ?? '';

          Get.snackbar('Éxito', 'Inicio de sesión exitoso',
              backgroundColor: Colors.green, colorText: Colors.white);

          // Creamos el objeto Usuario con los datos obtenidos
          Usuario usuario = Usuario(
            id: userQuery.docs.first.id,
            uid: userId,
            name: name,
            email: emailController.text.trim(),
            description: description,
            logo: logo,
            phoneNumber: number,
          );
          final UsuarioController usuarioController =
              Get.put(UsuarioController());

          await usuarioController.addUsuario(
            id: usuario.id,
            uid: usuario.uid,
            name: usuario.name,
            email: usuario.email,
            phoneNumber: usuario.phoneNumber,
            description: usuario.description,
            logo: usuario.logo,
          );
        }
      } else {
        Get.snackbar('Error', 'Por favor, confirma el correo de verificación.',
            backgroundColor: Colors.red, colorText: Colors.white);
        Navigator.of(context).pop();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Get.snackbar('Error', 'Usuario no encontrado',
            backgroundColor: Colors.red, colorText: Colors.white);
      } else if (e.code == 'wrong-password') {
        Get.snackbar('Error', 'Contraseña incorrecta',
            backgroundColor: Colors.red, colorText: Colors.white);
      } else {
        Get.snackbar('Error', 'Error en la autenticación: ${e.message}',
            backgroundColor: Colors.red, colorText: Colors.white);
      }
      print(
          'Error en la autenticación: aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa ${e.message}');
    } catch (e) {
      Get.snackbar('Error', 'Error inesperado: $e',
          backgroundColor: Colors.red, colorText: Colors.white);
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
