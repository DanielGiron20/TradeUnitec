import 'package:flutter/material.dart';
import 'package:tradeunitec/Basededatos/usuario.dart';

class Perfil extends StatelessWidget {
  final Usuario usuario;

  const Perfil({Key? key, required this.usuario}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Perfil',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Perfil de ${usuario.name}'),
        ),
        body: Center(
          child: Text('Bienvenido, ${usuario.name}'),
        ),
      ),
    );
  }
}
