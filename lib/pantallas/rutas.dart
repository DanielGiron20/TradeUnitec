// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:tradeunitec/Basededatos/usuario.dart';
import 'package:tradeunitec/pantallas/login.dart';
import 'package:tradeunitec/pantallas/logon.dart';
import 'package:tradeunitec/pantallas/pantalla_principal.dart';
import 'package:tradeunitec/pantallas/perfil.dart';

enum MyRoutes { PantallaPrincipal, Login, Logon, Perfil }

final Map<String, Widget Function(BuildContext)> routes = {
  MyRoutes.PantallaPrincipal.name: (context) => const PantallaPrincipal(),
  MyRoutes.Login.name: (context) => Login(),
  MyRoutes.Logon.name: (context) => Logon(),
  MyRoutes.Perfil.name: (context) => Perfil(
        usuario: Usuario(
          id: '',
          uid: '',
          name: '',
          email: '',
          description: '',
          logo: '',
          phoneNumber: '',
        ),
      ),
};
