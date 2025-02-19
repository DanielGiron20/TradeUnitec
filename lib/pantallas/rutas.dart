import 'package:flutter/material.dart';
import 'package:tradeunitec/pantallas/login.dart';
import 'package:tradeunitec/pantallas/logon.dart';
import 'package:tradeunitec/pantallas/pantalla_principal.dart';

enum MyRoutes {
  // ignore: constant_identifier_names
  PantallaPrincipal,
  Login,
  Logon
}

final Map<String, Widget Function(BuildContext)> routes = {
  MyRoutes.PantallaPrincipal.name: (context) => const PantallaPrincipal(),
  MyRoutes.Login.name: (context) => Login(),
  MyRoutes.Logon.name: (context) => Logon(),
};
