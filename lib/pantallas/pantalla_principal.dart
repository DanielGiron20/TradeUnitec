import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tradeunitec/Basededatos/db_helper.dart';
import 'package:tradeunitec/Basededatos/usuario.dart';
import 'package:tradeunitec/pantallas/producto.dart';
import 'package:tradeunitec/pantallas/rutas.dart';

class PantallaPrincipal extends StatefulWidget {
  const PantallaPrincipal({super.key});

  @override
  _PantallaPrincipalState createState() => _PantallaPrincipalState();
}

class _PantallaPrincipalState extends State<PantallaPrincipal> {
  String categoriaSeleccionada = "Todos";
  late Usuario currentUser;
  bool isLogged = false;
  @override
  void initState() {
    super.initState();
    getUser();
  }

  void getUser() async {
    try {
      final db = await DbHelper().database;
      final List<Map<String, dynamic>> usuarios = await db.query('users');

      if (usuarios.isNotEmpty) {
        setState(() {
          currentUser = Usuario.fromMap(usuarios.first);
          isLogged = true;
        });
        Get.snackbar("Bienvenido", "Bienvenido ${currentUser.name}");
      } else {
        print("No hay usuarios disponibles");
        Get.snackbar("Error", "No hay usuarios disponibles");
      }
    } catch (e) {
      print("Error al obtener el usuario: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Trade Unitec'),
          actions: [
            isLogged
                ? GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, MyRoutes.Perfil.name,
                          arguments: currentUser);
                    },
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(currentUser.logo),
                    ),
                  )
                : IconButton(
                    icon: const Icon(Icons.person),
                    tooltip: 'Iniciar sesión',
                    onPressed: () {
                      Navigator.pushNamed(context, MyRoutes.Login.name)
                          .then((value) {
                        if (value is Usuario) {
                          setState(() {
                            currentUser = value;
                            isLogged = true;
                          });
                        }
                      });
                    },
                  ),
          ],
        ),
        body: Column(
          children: [
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ["Todos", "Electrónica", "Moda", "Hogar", "Deportes"]
                    .map((categoria) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: ChoiceChip(
                            label: Text(categoria),
                            selected: categoriaSeleccionada == categoria,
                            onSelected: (selected) {
                              setState(() {
                                categoriaSeleccionada = categoria;
                              });
                            },
                          ),
                        ))
                    .toList(),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: categoriaSeleccionada == "Todos"
                    ? FirebaseFirestore.instance
                        .collection('products')
                        .snapshots()
                    : FirebaseFirestore.instance
                        .collection('products')
                        .where('category', isEqualTo: categoriaSeleccionada)
                        .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                        child: Text("No hay productos disponibles"));
                  }

                  var productos = snapshot.data!.docs;

                  return GridView.builder(
                    padding: const EdgeInsets.all(10),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.8,
                    ),
                    itemCount: productos.length,
                    itemBuilder: (context, index) {
                      var producto = productos[index];
                      return ProductCard(
                        nombre: producto['name'],
                        descripcion: producto['descripcion'],
                        imagenUrl: producto['imagen'],
                        userId: producto['userid'],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final String nombre;
  final String descripcion;
  final String imagenUrl;
  final String userId;

  const ProductCard({
    super.key,
    required this.nombre,
    required this.descripcion,
    required this.imagenUrl,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PantallaProducto(
              nombre: nombre,
              descripcion: descripcion,
              imagenUrl: imagenUrl,
              userid: userId,
            ),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(10)),
                child: Image.network(
                  imagenUrl,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.image_not_supported),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                nombre,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                descripcion,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.grey),
              ),
            ),
            const SizedBox(height: 5),
          ],
        ),
      ),
    );
  }
}
