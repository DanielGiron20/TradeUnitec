import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';


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
  String? _usernumber;

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
          _usernumber = usuario.docs.first['numero'];
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

   Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    launchUrl(uri, mode: LaunchMode.externalApplication);
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
          const Divider(),
          ListTile(
            leading: _userPhotoUrl != null
                ? CircleAvatar(backgroundImage: NetworkImage(_userPhotoUrl!))
                : const CircleAvatar(child: Icon(Icons.person)),
            title: const Text("Publicado por"),
            subtitle: Text("Usuario: $nombreVendedor"),
          ),
          const Spacer(),
         Row(
           mainAxisAlignment: MainAxisAlignment.center,
            children: [
           IconButton(
            icon: const FaIcon(FontAwesomeIcons.whatsapp),
            color: Colors.green,
             iconSize: 60,
              onPressed: () {
                final whatsappUrl =
                 'https://wa.me/+504$_usernumber?text=${Uri.encodeComponent('Vi tu producto ${widget.nombre} en TradeUnitec y me interesó')}';
                  _launchUrl(whatsappUrl);
          },
           )
         ])
        ],
      ),
    );
  }
}
