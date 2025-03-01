import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditarProductosPage extends StatefulWidget {
  final String nombre;
  final String descripcion;
  final String imagenUrl;
  final String userid;
  final String category;

  const EditarProductosPage({
    required this.nombre,
    required this.descripcion,
    required this.imagenUrl,
    required this.userid,
    required this.category,
    super.key,
  });

  @override
  _EditarProductosPageState createState() => _EditarProductosPageState();
}

class _EditarProductosPageState extends State<EditarProductosPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nombreController;
  late TextEditingController _descripcionController;
  String? _selectedCategory;
  File? _imageFile;
  bool _subiendo = false;

  final List<String> _categorias = ['Electrónica', 'Moda', 'Hogar', 'Deportes'];

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(text: widget.nombre);
    _descripcionController = TextEditingController(text: widget.descripcion);
    _selectedCategory = widget.category;
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _descripcionController.dispose();
    super.dispose();
  }

  // Método para seleccionar una nueva imagen
  Future<void> _seleccionarImagen() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  // Método para subir la nueva imagen y borrar la anterior
  Future<String> _subirImagen(File imageFile) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference ref = FirebaseStorage.instance.ref().child('products/$fileName');
    UploadTask uploadTask = ref.putFile(imageFile);

    TaskSnapshot snapshot = await uploadTask;
    String nuevaUrl = await snapshot.ref.getDownloadURL();

    // Borrar imagen anterior solo si se sube una nueva
    if (widget.imagenUrl.isNotEmpty) {
      await FirebaseStorage.instance.refFromURL(widget.imagenUrl).delete();
    }

    return nuevaUrl;
  }

  // Método para actualizar los datos en Firestore
  Future<void> _actualizarProducto() async {
    if (_nombreController.text.isEmpty || _descripcionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Por favor, complete todos los campos.")),
      );
      return;
    }

    setState(() {
      _subiendo = true;
    });

    try {
      String nuevaImagenUrl = widget.imagenUrl;
      if (_imageFile != null) {
        nuevaImagenUrl = await _subirImagen(_imageFile!);
      }

      QuerySnapshot productQuery = await FirebaseFirestore.instance
          .collection('products')
          .where('userid', isEqualTo: widget.userid)
          .where('name', isEqualTo: widget.nombre)
          .where('descripcion', isEqualTo: widget.descripcion)
          .where('category', isEqualTo: widget.category)
          .get();

      if (productQuery.docs.isNotEmpty) {
        String documentId = productQuery.docs.first.id;
        await FirebaseFirestore.instance
            .collection('products')
            .doc(documentId)
            .update({
          'name': _nombreController.text,
          'descripcion': _descripcionController.text,
          'category': _selectedCategory ?? widget.category,
          'imagen': nuevaImagenUrl,
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Producto actualizado exitosamente.")),
        );

        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error al actualizar producto.")),
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
        title: const Text('Editar Producto'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _imageFile != null
                ? Image.file(_imageFile!,
                    height: 150, width: 150, fit: BoxFit.cover)
                : Image.network(widget.imagenUrl,
                    height: 150, width: 150, fit: BoxFit.cover),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _seleccionarImagen,
              child: const Text("Seleccionar Nueva Imagen"),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _nombreController,
              decoration:
                  const InputDecoration(labelText: 'Nombre del Producto'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _descripcionController,
              decoration: const InputDecoration(labelText: 'Descripción'),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              items: _categorias.map((categoria) {
                return DropdownMenuItem<String>(
                  value: categoria,
                  child: Text(categoria),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value!;
                });
              },
              decoration: const InputDecoration(labelText: 'Categoría'),
            ),
            const SizedBox(height: 20),
            _subiendo
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _actualizarProducto,
                    child: const Text("Guardar Cambios"),
                  ),
          ],
        ),
      ),
    );
  }
}
