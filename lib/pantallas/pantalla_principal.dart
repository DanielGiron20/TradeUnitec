import 'package:flutter/material.dart';



class PantallaPrincipal extends StatelessWidget {
  const PantallaPrincipal({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Trade Unitec'),
          actions: [
            IconButton(
              icon: const Icon(Icons.person),
              tooltip: 'Iniciar sesión',
              onPressed: () {
                
              }
          )],
        ),
        body: const Center(
          child: Text('Bienvenido a Trade Unitec'),
        ),
      ),
    );
  }
}