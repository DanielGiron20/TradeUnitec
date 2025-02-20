import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tradeunitec/widgets/custom_input.dart';
import 'package:tradeunitec/widgets/loading_dialog.dart';

class Logon extends StatefulWidget {
  const Logon({super.key});

  @override
  State<Logon> createState() => _LogonState();
}

class _LogonState extends State<Logon> {
  final _nombreController = TextEditingController();
  final _correoController = TextEditingController();
  final _contrasenaController = TextEditingController();
  final _numeroController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final loadingDialog = LoadingDialog();
  File? _logoFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Registro de Vendedor")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
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
                show: false,
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
                    return 'El número es obligatorio';
                  }
                  if (valor.length != 8) {
                    return 'El número debe tener 8 dígitos';
                  }
                  return null;
                },
                teclado: TextInputType.number,
                hint: 'Ingrese su número',
                nombrelabel: 'Número',
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
              const SizedBox(height: 20),
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: double.infinity,
                  height: 200,
                  color: Colors.grey[300],
                  child: _logoFile == null
                      ? const Center(child: Text('Selecciona una imagen'))
                      : Image.file(_logoFile!),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  textStyle:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                child:
                    Text('Registrarse', style: TextStyle(color: Colors.white)),
                onPressed: () {
                  registerSeller(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    try {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        final croppedFile = await ImageCropper().cropImage(
          sourcePath: pickedFile.path,
          maxWidth: 1000,
          maxHeight: 1000,
          uiSettings: [
            AndroidUiSettings(
              toolbarTitle: 'Recortar imagen',
              toolbarColor: const Color.fromARGB(255, 33, 46, 127),
              toolbarWidgetColor: Colors.white,
              activeControlsWidgetColor: const Color.fromARGB(255, 255, 211, 0),
              aspectRatioPresets: [
                CropAspectRatioPreset.square,
              ],
              lockAspectRatio: true,
            ),
            IOSUiSettings(
              title: 'Recortar imagen',
              aspectRatioLockEnabled: true,
              minimumAspectRatio: 1.0,
            ),
          ],
        );

        if (croppedFile != null) {
          setState(() {
            _logoFile = File(croppedFile.path);
          });
        }
      }
    } catch (e) {
      /*
      Get.snackbar('Error', 'Error al seleccionar o recortar la imagen');
      */
    }
  }

  Future<void> registerSeller(BuildContext context) async {
    if (_formKey.currentState == null || mounted == false) {
      /*
      Get.snackbar('Error', 'Por favor complete los campos correctamente',
          backgroundColor: Colors.red, colorText: Colors.white);
          */
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
      String logoUrl = '';
      if (_logoFile != null) {
        final storageRef = FirebaseStorage.instance.refFromURL(
            'gs://tradeunitec.appspot.com/logos/${DateTime.now().toIso8601String()}');
        final uploadTask = await storageRef.putFile(_logoFile!);
        logoUrl = await uploadTask.ref.getDownloadURL();
      }
      await FirebaseFirestore.instance.collection('users').add({
        'uid': userCredential.user!.uid,
        'name': _nombreController.text.trim(),
        'correo': _correoController.text.trim(),
        'numero': _numeroController.text.trim(),
        'logo': logoUrl
      });

      _formKey.currentState!.reset();
      /*
      Get.snackbar(
        'Confirmación de correo',
        'Se ha enviado un correo de verificación. Revisa tu correo antes de continuar.',
        backgroundColor: const Color.fromARGB(255, 33, 46, 127),
        colorText: Colors.white,
      );
      */
      loadingDialog.hide(context);
      Navigator.pop(context);
    } catch (e) {
      loadingDialog.hide(context);
      /*
      Get.snackbar('Error', 'Error al registrar el vendedor: ${e.toString()}',
          backgroundColor: Colors.red, colorText: Colors.white);
          */
    }
  }
}
