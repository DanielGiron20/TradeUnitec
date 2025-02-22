import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tradeunitec/widgets/custom_input.dart';
import 'package:tradeunitec/widgets/loading_dialog.dart';

class Logon extends StatefulWidget {
  const Logon({super.key});

  @override
  State<Logon> createState() => _LogonState();
}

class _LogonState extends State<Logon> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _correoController = TextEditingController();
  final TextEditingController _contrasenaController = TextEditingController();
  final TextEditingController _numeroController = TextEditingController();
  File? _logoFile;
  final loadingDialog = LoadingDialog();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Registro de Vendedor")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildTextInput(
                controller: _nombreController,
                label: "Nombre de vendedor",
                hint: "Ingrese el nombre de vendedor",
                icon: Icons.person,
                validator: _validateNombre,
              ),
              _buildTextInput(
                controller: _correoController,
                label: "Correo electrónico",
                hint: "Ingrese su correo institucional",
                icon: Icons.email,
                keyboardType: TextInputType.emailAddress,
                validator: _validateCorreo,
              ),
              _buildTextInput(
                controller: _numeroController,
                label: "Número",
                hint: "Ingrese su número de teléfono",
                icon: Icons.phone,
                keyboardType: TextInputType.number,
                validator: _validateNumero,
              ),
              _buildPasswordInput(),
              const SizedBox(height: 20),
              _buildImagePicker(),
              const SizedBox(height: 20),
              _buildRegisterButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextInput({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return CustomInputs(
      controller: controller,
      nombrelabel: label,
      hint: hint,
      icono: icon,
      teclado: keyboardType,
      validator: validator,
      show: false,
    );
  }

  Widget _buildPasswordInput() {
    return PasswordInput(
      controller: _contrasenaController,
      nombrelabel: 'Contraseña',
      hint: 'Ingrese su contraseña',
      validator: _validateContrasena,
    );
  }

  Widget _buildImagePicker() {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        width: double.infinity,
        height: 200,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(10),
        ),
        child: _logoFile == null
            ? const Center(child: Text('Selecciona una imagen'))
            : Image.file(_logoFile!, fit: BoxFit.cover),
      ),
    );
  }

  Widget _buildRegisterButton(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blueAccent,
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      onPressed: () => _registerSeller(context),
      child: const Text('Registrarse', style: TextStyle(color: Colors.white)),
    );
  }

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();

    final pickedFile = await showDialog<XFile>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Selecciona una fuente de imagen'),
        actions: <Widget>[
          TextButton(
            onPressed: () async {
              Navigator.pop(
                  context, await _picker.pickImage(source: ImageSource.camera));
            },
            child: const Text('Cámara'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context,
                  await _picker.pickImage(source: ImageSource.gallery));
            },
            child: const Text('Galería'),
          ),
        ],
      ),
    );

    if (pickedFile != null) {
      setState(() {
        _logoFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _registerSeller(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;
    loadingDialog.show(context);

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _correoController.text.toLowerCase().trim(),
        password: _contrasenaController.text.trim(),
      );
      await userCredential.user!.sendEmailVerification();

      String logoUrl = '';
      if (_logoFile != null) {
        final storageRef = FirebaseStorage.instance.refFromURL(
            'gs://pumitasemprendedores.appspot.com/logos/${DateTime.now().toIso8601String()}');
        await storageRef.putFile(_logoFile!);
        logoUrl = await storageRef.getDownloadURL();
      }

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'uid': userCredential.user!.uid,
        'name': _nombreController.text.trim(),
        'correo': _correoController.text.trim(),
        'numero': _numeroController.text.trim(),
        'logo': logoUrl
      });

      Get.snackbar(
          'Registro exitoso', 'Revisa tu correo para verificar la cuenta.');
      Navigator.pop(context);
    } catch (e) {
      Get.snackbar('Error', 'Error al registrar el vendedor: ${e.toString()}');
    } finally {
      loadingDialog.hide(context);
    }
  }

  String? _validateNombre(String? value) {
    if (value == null || value.isEmpty) return 'El nombre es obligatorio';
    if (value.length < 3 || value.length > 20)
      return 'Debe tener entre 3 y 20 caracteres';
    return null;
  }

  String? _validateCorreo(String? value) {
    if (value == null || value.isEmpty) return 'El correo es obligatorio';
    return null;
  }

  String? _validateNumero(String? value) {
    if (value == null || value.isEmpty || value.length != 8)
      return 'Debe tener 8 dígitos';
    return null;
  }

  String? _validateContrasena(String? value) {
    if (value == null || value.isEmpty || value.length < 6)
      return 'Debe tener al menos 6 caracteres';
    return null;
  }
}
