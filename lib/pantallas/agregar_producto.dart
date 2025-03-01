import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AgregarProducto extends StatefulWidget {
  final String uid;

  const AgregarProducto({Key? key, required this.uid}) : super(key: key);

  @override
  _AgregarProductoState createState() => _AgregarProductoState();
}

class _AgregarProductoState extends State<AgregarProducto> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  String _categoria = 'Electrónica';
  File? _imagen;
  bool _subiendo = false;

  final List<String> _categorias = ['Electrónica', 'Moda', 'Hogar', 'Deportes'];

  Future<void> _seleccionarImagen() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imagen = File(pickedFile.path);
      });
    }
  }

  Future<String> _subirImagen(File imageFile) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference ref = FirebaseStorage.instance.ref().child('products/$fileName');
    UploadTask uploadTask = ref.putFile(imageFile);

    TaskSnapshot snapshot = await uploadTask;
    return await snapshot.ref.getDownloadURL();
  }

  Future<void> _guardarProducto() async {
    if (_nombreController.text.isEmpty ||
        _descripcionController.text.isEmpty ||
        _imagen == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                "Por favor, complete todos los campos y seleccione una imagen.")),
      );
      return;
    }

    setState(() {
      _subiendo = true;
    });

    try {
      String imageUrl = await _subirImagen(_imagen!);
      await FirebaseFirestore.instance.collection('products').add({
        'name': _nombreController.text,
        'descripcion': _descripcionController.text,
        'category': _categoria,
        'imagen': imageUrl,
        'userid': widget.uid,
        'createdAt': FieldValue.serverTimestamp(),
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Producto agregado exitosamente.")),
      );

      Navigator.pop(context);
    } catch (e) {
      print("Error al guardar producto: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error al agregar producto.")),
      );
    }

    setState(() {
      _subiendo = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Agregar Producto',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF003366), // Azul Unitec
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Sección de la imagen
            _imagen != null
                ? Image.file(
                    _imagen!,
                    height: 150,
                    width: 150,
                    fit: BoxFit.cover,
                  )
                : const Icon(
                    Icons.image,
                    size: 150,
                    color: Colors.grey,
                  ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _seleccionarImagen,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFCC00),
                foregroundColor: const Color(0xFF003366),
              ),
              child: const Text("Seleccionar Imagen"),
            ),
            const SizedBox(height: 20),

            // Campo de texto para el nombre del producto
            TextField(
              controller: _nombreController,
              decoration: InputDecoration(
                labelText: 'Nombre del Producto',
                labelStyle: const TextStyle(color: Color(0xFF003366)),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF003366)),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF003366)),
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _descripcionController,
              decoration: InputDecoration(
                labelText: 'Descripción',
                labelStyle: const TextStyle(color: Color(0xFF003366)),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF003366)),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF003366)),
                ),
              ),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: _categoria,
              items: _categorias.map((categoria) {
                return DropdownMenuItem<String>(
                  value: categoria,
                  child: Text(
                    categoria,
                    style: const TextStyle(color: Color(0xFF003366)),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _categoria = value!;
                });
              },
              decoration: InputDecoration(
                labelText: 'Categoría',
                labelStyle: const TextStyle(color: Color(0xFF003366)),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF003366)),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF003366)),
                ),
              ),
            ),
            const SizedBox(height: 20),
            _subiendo
                ? const CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Color(0xFF003366)),
                  )
                : ElevatedButton(
                    onPressed: _guardarProducto,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color(0xFFFFCC00),
                      foregroundColor: const Color(0xFF003366),
                    ),
                    child: const Text("Guardar Producto"),
                  ),
          ],
        ),
      ),
    );
  }
}
