import 'package:flutter/material.dart';
import 'package:tradeunitec/Basededatos/db_helper.dart';
import 'package:tradeunitec/Basededatos/usuario.dart';
import 'package:tradeunitec/pantallas/agregar_producto.dart';
import 'package:tradeunitec/pantallas/mis_productos.dart';
import 'package:tradeunitec/pantallas/editar_perfil.dart';

class Perfil extends StatefulWidget {
  const Perfil({Key? key}) : super(key: key);

  @override
  State<Perfil> createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
  late Usuario usuario;
  bool isLoading = true;

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
          usuario = Usuario.fromMap(usuarios.first);
          isLoading = false;
        });
      } else {
        print("No hay usuarios disponibles");
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error al obtener el usuario: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Perfil',
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Perfil de Usuario',
            style: TextStyle(
              color: Colors.white, // Texto blanco para contraste
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: const Color(0xFF003366),
          elevation: 0,
        ),
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                      Color(0xFF003366)), // Azul Unitec
                ),
              )
            : Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      const Color(0xFF003366),
                      const Color.fromARGB(255, 23, 84, 188),
                    ],
                  ),
                ),
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundImage: NetworkImage(usuario.logo),
                          backgroundColor: Colors.white,
                        ),
                        const SizedBox(height: 20),
                        // Nombre del usuario
                        Text(
                          usuario.name,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 10),
                        // Correo electrónico
                        Text(
                          usuario.email,
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Card(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                ListTile(
                                  leading: const Icon(
                                    Icons.phone,
                                    color: Color.fromARGB(255, 225, 38, 5),
                                  ),
                                  title: const Text(
                                    'Teléfono',
                                    style: TextStyle(color: Color(0xFF003366)),
                                  ),
                                  subtitle: Text(
                                    usuario.phoneNumber,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                                const Divider(),
                                ListTile(
                                  leading: const Icon(
                                    Icons.person,
                                    color: Color.fromARGB(255, 225, 38, 5),
                                  ),
                                  title: const Text(
                                    'Cedula',
                                    style: TextStyle(color: Color(0xFF003366)),
                                  ),
                                  subtitle: Text(
                                    usuario.cedula,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Botón para editar perfil
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditarPerfil(usuario: usuario),
                              ),
                            ).then((_) => getUser()); // Recargar usuario después de editar
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 225, 38, 5),
                            foregroundColor: const Color(0xFF003366),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text('Editar Perfil'),
                        ),
                        const SizedBox(height: 20),
                        // Botón para agregar producto
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    AgregarProducto(uid: usuario.uid),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 225, 38, 5),
                            foregroundColor: const Color(0xFF003366),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text('Agregar producto'),
                        ),
                        const SizedBox(height: 20),
                        // Botón para ver mis productos
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    MisProductos(uid: usuario.uid),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 225, 38, 5),
                            foregroundColor: const Color(0xFF003366),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text('Ver mis productos'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
