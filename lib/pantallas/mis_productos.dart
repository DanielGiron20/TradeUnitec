import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tradeunitec/pantallas/mi_producto.dart';
import 'package:tradeunitec/widgets/product_card.dart';

class MisProductos extends StatelessWidget {
  final String uid;

  const MisProductos({Key? key, required this.uid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Mis Productos',
          style: TextStyle(
            color: Colors.white, // Texto blanco para contraste
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF003366), // Azul Unitec
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
          ),
          const SizedBox(height: 10),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('products')
                  .where('userid', isEqualTo: uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Color(0xFF003366)), // Azul Unitec
                    ),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text(
                      "No hay productos disponibles",
                      style: TextStyle(
                        fontSize: 18,
                        color: Color(0xFF003366), // Azul Unitec
                      ),
                    ),
                  );
                }

                var productos = snapshot.data!.docs;

                return GridView.builder(
                  padding: const EdgeInsets.all(10),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                      category: producto['category'],
                      ontap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PantallaProducto(
                              nombre: producto['name'],
                              descripcion: producto['descripcion'],
                              imagenUrl: producto['imagen'],
                              userid: producto['userid'],
                              category: producto['category'],
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
