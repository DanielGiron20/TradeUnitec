  import 'dart:io';

  import 'package:cloud_firestore/cloud_firestore.dart';
  import 'package:firebase_auth/firebase_auth.dart';
  import 'package:firebase_storage/firebase_storage.dart';
  import 'package:flutter/material.dart';
  import 'package:get/get.dart';
  import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
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
    final TextEditingController _identidadController = TextEditingController();
    File? _logoFile;
    File? _cedulaFile;
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    final loadingDialog = LoadingDialog();

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Registro de Vendedor",
            style: TextStyle(
              color: Colors.white, // Texto blanco para contraste
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: const Color(0xFF003366),
          centerTitle: true,
          elevation: 0,
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF003366),
                Color.fromARGB(255, 23, 84, 188),
              ],
            ),
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Campo de nombre de vendedor
                  _buildTextInput(
                    controller: _nombreController,
                    label: "Nombre de vendedor",
                    hint: "Ingrese el nombre de vendedor",
                    icon: Icons.person,
                    validator: _validateNombre,
                  ),
                  const SizedBox(height: 20),
                  // Campo de correo electrónico
                  _buildTextInput(
                    controller: _identidadController,
                    label: "Numero de identidad ",
                    hint: "Ingrese su numero de identidad",
                    icon: Icons.person,
                    keyboardType: TextInputType.number,
                    validator: _validateCedula,
                  ),
                  const SizedBox(height: 20),
                  // Campo de correo electrónico
                  _buildTextInput(
                    controller: _correoController,
                    label: "Correo electrónico",
                    hint: "Ingrese su correo institucional",
                    icon: Icons.email,
                    keyboardType: TextInputType.emailAddress,
                    validator: _validateCorreo,
                  ),
                  const SizedBox(height: 20),
                  // Campo de número de teléfono
                  _buildTextInput(
                    controller: _numeroController,
                    label: "Número de teléfono",
                    hint: "Ingrese su número de teléfono",
                    icon: Icons.phone,
                    keyboardType: TextInputType.phone,
                    validator: _validateNumero,
                  ),
                  const SizedBox(height: 20),
                  _buildPasswordInput(),
                  const SizedBox(height: 20),
                  _buildImagePicker(),
                  const SizedBox(height: 20),
                  _buildRegisterButton(context),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      );
    }

    @override
    void initState() {
      super.initState();
      _pickCedula(context);
    }

  void _showTerms(BuildContext context) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                titlePadding: const EdgeInsets.all(0),
                title: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: const BoxDecoration(
                    color:  const Color(0xFF003366),
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(15.0)),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.info, color: Colors.white),
                      SizedBox(width: 10),
                      Text(
                        'Términos y Condiciones',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ],
                  ),
                ),
                content: const SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Términos y Condiciones de uso para traders\n\n'
                        '1. Aceptación de los Términos: Al descargar, registrarse o utilizar la aplicación "Trade Unitec", desarrollada con el fin de facilitar el contacto entre estudiantes que buscan comprar y vender, usted acepta y se compromete a cumplir estos términos y condiciones. Si no está de acuerdo con alguno de los términos, debe abstenerse de utilizar la aplicación.\n\n'
                        '2. Al registrarse, usted acepta que sus datos proporcionados, incluyendo su contacto de teléfono, serán visibles públicamente para todos los usuarios de la aplicación.\n\n'
                        'Esta información es necesaria para facilitar la comunicación entre vendedores y compradores. No nos hacemos responsables del uso que otros usuarios puedan hacer de esta información fuera de la plataforma.\n\n'
                        '3. Contenido Subido por el Usuario: Al subir contenido, como imágenes o descripciones de productos, usted declara ser el propietario legítimo de dicho contenido y que no infringe los derechos de terceros. Nos reservamos el derecho de eliminar cualquier contenido que consideremos inapropiado o que infrinja estos términos.\n\n'
                        '4. Responsabilidad del Usuario: Usted es el único responsable de la información que comparte en la aplicación y de las interacciones que tenga con otros usuarios. No somos responsables de las negociaciones, transacciones o conflictos que puedan surgir entre usuarios.\n\n'
                        '5. Terminación del Servicio: Nos reservamos el derecho de suspender o eliminar su cuenta si se detecta un uso indebido de la plataforma o si incumple estos términos.\n\n'
                        '6. Spam: La subida de un mismo producto repetidas veces sera visto como spam y sera eliminado.\n\n'
                        '7. Aplicacion independiente de la universidad: La plataforma no es una aplicacion oficial de la universidad y es desarrollada por estudiantes de la universidad para facilitar el contacto entre estudiantes de la Universidad UNITEC.\n\n',
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.grey[600],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: const Text('No acepto'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:  const Color(0xFF003366),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: const Text('Si acepto'),
                    onPressed: () {
                      Navigator.pop(context);
                      recursividad();
                    },
                  ),
                ],
              );
            },
          );
        },
      );
    }
    Future<void> _pickCedula(BuildContext context) async {
      Future.delayed(Duration.zero, () async {
        await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Seleccionar método'),
              content: Text(
                  '¿Desea llenar los datos usando la cédula o hacerlo manualmente?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _seleccionarCedula(); // Aquí agregas tu lógica

                    print("Llenar con cédula");
                  },
                  child: Text('Usar cédula'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    print("Llenar manualmente");
                  },
                  child: Text('Manual'),
                ),
              ],
            );
          },
        );
      });
    }

    Future<void> _seleccionarCedula() async {
      try {
        final ImagePicker _picker = ImagePicker();

        final pickedFile = await showDialog<XFile>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Selecciona una fuente de imagen'),
            actions: <Widget>[
              TextButton(
                onPressed: () async {
                  Navigator.pop(context,
                      await _picker.pickImage(source: ImageSource.camera));
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
            _cedulaFile = File(pickedFile.path);
          });

          final inputImage = InputImage.fromFile(_cedulaFile!);
          final recognizedText = await textRecognizer.processImage(inputImage);

          final List<String> lines = recognizedText.text.split('\n');
          print("Texto detectado: $lines");

          final extractedData = _extractCedulaInfo(lines);
          print("Información extraída: $extractedData");
          Get.snackbar(
            'Información Extraída',
            extractedData.toString(),
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: const Duration(seconds: 5),
          );
        }
      } catch (e) {
        Get.snackbar(
          'Error',
          'No se pudo seleccionar la imagen.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    }

    Map<String, String> _extractCedulaInfo(List<String> lines) {
      Map<String, String> data = {
        "Nombre": "No detectado",
        "Apellido": "No detectado",
        "Fecha de Nacimiento": "",
        "Número de Identidad": "",
        "Nacionalidad": "",
        "Lugar de Nacimiento": "",
        "Fecha de Emisión": "",
      };

      for (int i = 0; i < lines.length; i++) {
        String line = lines[i].trim();
        if (line.contains(
                RegExp(r'nombre\s*\/?\s*forename', caseSensitive: false)) &&
            i + 1 < lines.length) {
          data["Nombre"] = lines[i + 1].trim();
        } else if (line.contains(RegExp('apellido', caseSensitive: false)) &&
            i + 1 < lines.length) {
          data["Apellido"] = lines[i + 1].trim();
        } else if (line
            .contains(RegExp('fecha de nacimiento', caseSensitive: false))) {
          if (data["Fecha de Nacimiento"]!.isEmpty) {
            data["Fecha de Nacimiento"] = lines[i + 1].trim();
          } else {
            data["Fecha de Emisión"] = line.trim();
          }
        } else if (line.contains(RegExp(r'\d{4}\s\d{4}\s\d{5}'))) {
          data["Número de Identidad"] = line.trim();
        } else if (line.contains("HND")) {
          data["Nacionalidad"] = "Honduras";
        } else if (line.contains(RegExp(r'lugar de nacimiento|place of birth',
                caseSensitive: false)) &&
            i + 1 < lines.length) {
          data["Lugar de Nacimiento"] = lines[i + 1].trim();
        } else if (line.contains(RegExp(r'fecha de expiración|date of expiry',
                caseSensitive: false)) &&
            i + 1 < lines.length) {
          data["Fecha de Emisión"] = lines[i + 1].trim();
        }
      }
      _nombreController.text = data["Nombre"]!;
      _identidadController.text = data["Número de Identidad"]!;

      return data;
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

void recursividad() {
  _registerSeller(context);
}
    Widget _buildRegisterButton(BuildContext context) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.blueAccent,
      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
      textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    ),
    onPressed: () {
   
      if (_formKey.currentState == null || !_formKey.currentState!.validate()) {
        return;
      }

      
      if (_logoFile == null) {
        Get.snackbar(
          'Error',
          'Debes seleccionar una imagen para el logo.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }
     
      _showTerms(context);
    },
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
      if (_formKey.currentState == null || !_formKey.currentState!.validate()) {
    return;
  }
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
          'logo': logoUrl,
          'cedula': _identidadController.text.trim(),
        });

        Get.snackbar(
            'Registro exitoso', 'Revisa tu correo para verificar la cuenta.');
        Navigator.pop(context);
      } catch (e) {
        Get.snackbar('Error', 'Error al registrar el vendedor: ${e.toString()}');
        print('Error al registrar el vendedor: ${e.toString()}');
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

    String? _validateCedula(String? value) {
      if (value == null || value.isEmpty)
        return 'El numero de identidad es obligaroio';
      if (value.length != 13) return 'Debe tener 13 dígitos';
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
<<<<<<< HEAD

  Future<void> _registerSeller(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;
    loadingDialog.show(context);

    try {
      String correo = _correoController.text.toLowerCase().trim();
      String contrasena = _contrasenaController.text.trim();
      String nombre = _nombreController.text.trim();
      String numero = _numeroController.text.trim();
      String cedula = _identidadController.text.trim();

      // Asegurar que los campos obligatorios no sean nulos ni vacíos
      if (correo.isEmpty || contrasena.isEmpty || nombre.isEmpty || numero.isEmpty) {
        Get.snackbar('Error', 'Todos los campos obligatorios deben estar llenos.');
        loadingDialog.hide(context);
        return;
      }

      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: correo,
        password: contrasena,
      );

      await userCredential.user!.sendEmailVerification();

      // Manejo seguro del logo
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
        'name': nombre,
        'correo': correo,
        'numero': numero,
        'logo': logoUrl,
        'cedula': cedula.isNotEmpty ? cedula : 'Sin cédula', // Evita valores nulos
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

  String? _validateCedula(String? value) {
    if (value == null || value.isEmpty)return 'El numero de identidad es obligaroio';
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
=======
>>>>>>> 0b6ce1dd894f26ffd11959d9f24909acfc25c4ba
