import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tradeunitec/Basededatos/db_helper.dart';
import 'package:tradeunitec/Basededatos/usuario.dart';
import 'dart:io';

class EditarPerfil extends StatefulWidget {
  final Usuario usuario;

  const EditarPerfil({Key? key, required this.usuario}) : super(key: key);

  @override
  _EditarPerfilState createState() => _EditarPerfilState();
}

class _EditarPerfilState extends State<EditarPerfil> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  File? _imageFile; 

  @override
  void initState() {
    super.initState();
 
    _nameController = TextEditingController(text: widget.usuario.name);
    _phoneController = TextEditingController(text: widget.usuario.phoneNumber);
  }

  @override
  void dispose() {
  
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

 
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path); 
      });
    }
  }

  
  Future<String?> _uploadImage() async {
    if (_imageFile == null) return null;

    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('user_images/${widget.usuario.uid}.jpg');

      await storageRef.putFile(_imageFile!); 
      final imageUrl = await storageRef.getDownloadURL(); 
      return imageUrl;
    } catch (e) {
      print("Error al subir la imagen: $e");
      return null;
    }
  }

  Future<void> _actualizarPerfil() async {
    try {
      String? newLogoUrl = widget.usuario.logo;

     
      if (_imageFile != null) {
        newLogoUrl = await _uploadImage();
      }

      
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(widget.usuario.id)
            .update({
          'name': _nameController.text,
          'phoneNumber': _phoneController.text,
          'logo': newLogoUrl,
        });
      }

      
      await DbHelper().updateUser(
        Usuario(
          id: widget.usuario.id,
          uid: widget.usuario.uid,
          name: _nameController.text,
          email: widget.usuario.email,
          description: widget.usuario.description,
          logo: newLogoUrl ?? widget.usuario.logo,
          phoneNumber: _phoneController.text,
        ),
      );

      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Perfil actualizado correctamente')),
      );

     
      Navigator.pop(context);
    } catch (e) {
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al actualizar el perfil: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Perfil'),
        backgroundColor: const Color(0xFF003366),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            
            GestureDetector(
              onTap: _pickImage, 
              child: CircleAvatar(
                radius: 60,
                backgroundImage: _imageFile != null
                    ? FileImage(_imageFile!) 
                    : NetworkImage(widget.usuario.logo) as ImageProvider,
                child: _imageFile == null
                    ? const Icon(Icons.camera_alt, size: 40) 
                    : null,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nombre',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Número de teléfono',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _actualizarPerfil,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 225, 38, 5),
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text('Guardar cambios'),
            ),
          ],
        ),
      ),
    );
  }
}