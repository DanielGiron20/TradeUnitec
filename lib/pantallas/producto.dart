import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PantallaProducto extends StatefulWidget {
  final String nombre;
  final String descripcion;
  final String imagenUrl;
  final String userid;

  const PantallaProducto({
    super.key,
    required this.nombre,
    required this.descripcion,
    required this.imagenUrl,
    required this.userid, 
  });

  @override
  _PantallaProductoState createState() => _PantallaProductoState();
}

class _PantallaProductoState extends State<PantallaProducto> {
  String nombreVendedor = "Cargando...";
  String? _userPhotoUrl;

  @override
  void initState() {
    super.initState();
    obtenerNombreVendedor();
  }

  void obtenerNombreVendedor() async {
    try {
      var usuario = await FirebaseFirestore.instance
          .collection('users')
          .where('uid', isEqualTo: (widget.userid))
          .get();

      if (usuario.docs.isNotEmpty) {
        setState(() {
          nombreVendedor = usuario.docs.first['name'];
          _userPhotoUrl = usuario.docs.first['logo'];
        });
      } else {
        setState(() {
          nombreVendedor = "Usuario desconocido";
        });
      }
    } catch (e) {
      setState(() {
        nombreVendedor = "Error al obtener vendedor";
      });
    }
  }

  @override
 Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.nombre)),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            widget.imagenUrl,
            width: double.infinity,
            height: 250,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => const Icon(Icons.image_not_supported),
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
          Divider(),
          ListTile(
            leading: _userPhotoUrl != null
                ? CircleAvatar(backgroundImage: NetworkImage(_userPhotoUrl!))
                : const CircleAvatar(child: Icon(Icons.person)),
            title: const Text("Publicado por"),
            subtitle: Text("Usuario: $nombreVendedor"),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(15),
            child: ElevatedButton.icon(
              onPressed: () {
                

                // pantalla para chatear

              },
              icon: const Icon(Icons.message),
              label: const Text("Contactar"),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
