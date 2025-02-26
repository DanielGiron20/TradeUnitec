import 'package:flutter/material.dart';
import 'package:tradeunitec/Basededatos/db_helper.dart';
import 'package:tradeunitec/Basededatos/usuario.dart';
import 'package:tradeunitec/pantallas/agregar_producto.dart';

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
          title: const Text('Perfil de Usuario'),
          backgroundColor: const Color.fromARGB(255, 0, 94, 255),
          foregroundColor: Colors.black,
          elevation: 0,
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      const Color.fromARGB(255, 0, 94, 255),
                      const Color.fromARGB(255, 14, 54, 125)
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
                          backgroundColor:
                              const Color.fromRGBO(255, 255, 255, 1),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          usuario.name,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 10),
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
                                  leading: const Icon(Icons.phone,
                                      color: Colors.deepPurple),
                                  title: const Text('Teléfono'),
                                  subtitle: Text(
                                    usuario.phoneNumber,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ),
                                const Divider(),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            // Acción para editar perfil
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.deepPurple,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text('Editar Perfil'),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AgregarProducto(uid: usuario.uid),
      ),
    );
  },
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.white,
    foregroundColor: Colors.deepPurple,
    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30),
    ),
  ),
  child: const Text('Agregar producto'),
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
