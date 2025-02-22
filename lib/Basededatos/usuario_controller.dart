import 'package:get/get.dart';
import 'package:tradeunitec/BaseDeDatos/db_helper.dart';
import 'package:tradeunitec/BaseDeDatos/usuario.dart';

class UsuarioController extends GetxController {
  @override
  void onReady() {
    super.onReady();
    getUsuarios();
  }

  var usuarioList = <Usuario>[].obs;

  Future<void> addUsuario({
    required String id,
    required String uid,
    required String name,
    required String email,
    required String description,
    required String logo,
    required String phoneNumber,
  }) async {
    try {
      Usuario usuario = Usuario(
        id: id,
        uid: uid,
        name: name,
        email: email,
        description: description,
        logo: logo,
        phoneNumber: phoneNumber,
      );
      await DBHelper.insertUsuario(usuario);
      getUsuarios();
    } catch (e) {
      print("Error al agregar usuario: $e");
    }
  }

  void getUsuarios() async {
    try {
      List<Usuario> usuarios = await DBHelper.queryUsuarios();
      usuarioList.assignAll(usuarios);
    } catch (e) {
      print("Error al obtener usuarios: $e");
    }
  }

  // Método para eliminar un usuario
  Future<void> deleteUsuario(String id) async {
    try {
      await DBHelper.deleteUsuario(
          id); // Elimina el usuario de la base de datos
      getUsuarios(); // Actualiza la lista de usuarios después de eliminar
    } catch (e) {
      print("Error al eliminar usuario: $e");
    }
  }

  // Método para actualizar un usuario
  Future<void> updateUsuario(String id, Map<String, dynamic> updates) async {
    try {
      await DBHelper.updateUsuario(
          id, updates); // Actualiza el usuario con los campos proporcionados
      getUsuarios(); // Actualiza la lista de usuarios después de la actualización
    } catch (e) {
      print("Error al actualizar usuario: $e");
    }
  }
}
