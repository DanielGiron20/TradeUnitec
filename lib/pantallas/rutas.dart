// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:tradeunitec/pantallas/login.dart';
import 'package:tradeunitec/pantallas/logon.dart';
import 'package:tradeunitec/pantallas/pantalla_principal.dart';
import 'package:tradeunitec/pantallas/perfil.dart';
import "package:tradeunitec/pantallas/agregar_producto.dart";

enum MyRoutes { PantallaPrincipal, Login, Logon, Perfil, AgregarProducto}

final Map<String, Widget Function(BuildContext)> routes = {
  MyRoutes.PantallaPrincipal.name: (context) => const PantallaPrincipal(),
  MyRoutes.Login.name: (context) => Login(),
 MyRoutes.Logon.name:  (context) => const Logon(),
  MyRoutes.Perfil.name: (context) => const Perfil(),
  MyRoutes.AgregarProducto.name: (context) => const AgregarProducto(uid: '',),
};
