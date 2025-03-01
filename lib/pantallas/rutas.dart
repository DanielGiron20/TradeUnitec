// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import "package:tradeunitec/pantallas/agregar_producto.dart";
import 'package:tradeunitec/pantallas/editar_producto.dart';
import 'package:tradeunitec/pantallas/login.dart';
import 'package:tradeunitec/pantallas/logon.dart';
import 'package:tradeunitec/pantallas/mi_producto.dart';
import 'package:tradeunitec/pantallas/mis_productos.dart';
import 'package:tradeunitec/pantallas/pantalla_principal.dart';
import 'package:tradeunitec/pantallas/perfil.dart';

enum MyRoutes {
  PantallaPrincipal,
  Login,
  Logon,
  Perfil,
  AgregarProducto,
  MisProductos,
  EditarProductosPage,
  PantallaProducto,

}

final Map<String, Widget Function(BuildContext)> routes = {
  MyRoutes.PantallaPrincipal.name: (context) => const PantallaPrincipal(),
  MyRoutes.Login.name: (context) => Login(),
  MyRoutes.Logon.name: (context) => const Logon(),
  MyRoutes.Perfil.name: (context) => const Perfil(),
  MyRoutes.AgregarProducto.name: (context) => const AgregarProducto(
        uid: '',
      ),
  MyRoutes.MisProductos.name: (context) => const MisProductos(
        uid: '',
      ),
 MyRoutes.EditarProductosPage.name: (context) => const EditarProductosPage(
       userid: '',
       nombre: '',
       descripcion: '',
       category: '',
       imagenUrl: '',
      ),
  MyRoutes.PantallaProducto.name: (context) => const PantallaProducto(
        userid: '',
        nombre: '',
        descripcion: '',
        category: '',
        imagenUrl: '',
      ),
};
