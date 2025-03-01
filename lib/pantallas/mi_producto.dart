import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:tradeunitec/pantallas/editar_producto.dart';
import 'package:tradeunitec/pantallas/rutas.dart';
import 'package:tradeunitec/widgets/loading_dialog.dart';
import 'package:get/get.dart';

class PantallaProducto extends StatefulWidget {
  final String nombre;
  final String descripcion;
  final String imagenUrl;
  final String userid;
  final String category;

  const PantallaProducto({
    super.key,
    required this.nombre,
    required this.descripcion,
    required this.imagenUrl,
    required this.userid,
    required this.category
  });

  @override
  _PantallaProductoState createState() => _PantallaProductoState();
}

class _PantallaProductoState extends State<PantallaProducto> {
  @override
  void initState() {
    super.initState();
  }

  Future<void> _deleteProduct() async {
    bool confirmDelete = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Eliminar Producto'),
          content:
              const Text('¿Estás seguro que deseas eliminar este producto?'),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.grey[600],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('No'),
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.grey[600],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Sí'),
            ),
          ],
        );
      },
    );

    if (confirmDelete) {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      try {
        QuerySnapshot productQuery = await firestore
            .collection('products')
            .where('userid', isEqualTo: widget.userid)
            .where('name', isEqualTo: widget.nombre)
            .where('descripcion', isEqualTo: widget.descripcion)
            .get();

        if (productQuery.docs.isNotEmpty) {
          String productDocId = productQuery.docs.first.id;

          await firestore.collection('products').doc(productDocId).delete();

          FirebaseStorage.instance.refFromURL(widget.imagenUrl).delete();
          Get.snackbar('Exito', 'Producto eliminado con exito',
              backgroundColor: Colors.green, colorText: Colors.white);

          Navigator.pop(context);
        } else {
          Get.snackbar('Error', 'Producto no encontrado',
              backgroundColor: Colors.red, colorText: Colors.white);
        }
      } catch (e) {
        Get.snackbar('Error', 'Error al eliminar producto',
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.nombre),
        actions: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.edit),
                tooltip: 'Edit Profile',
                onPressed: () {

              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => EditarProductosPage(
                  nombre: widget.nombre,
                  descripcion: widget.descripcion,
                  category: widget.category,
                  imagenUrl: widget.imagenUrl,
                  userid: widget.userid,
                ),
              ));
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                tooltip: 'Eliminar',
                onPressed: () {
                  _deleteProduct();
                },
              ),
            ],
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            widget.imagenUrl,
            width: double.infinity,
            height: 250,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.image_not_supported),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              widget.nombre,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              widget.descripcion,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
