import 'package:get/get.dart';
import 'package:tradeunitec/BaseDeDatos/db_helper.dart';
import 'package:tradeunitec/BaseDeDatos/usuario.dart';

class UsuarioController extends GetxController {
  @override
  void onReady() {
    super.onReady();
    getUsuarios(); // Carga los usuarios cuando el controlador está listo
  }

  var usuarioList = <Usuario>[].obs; // Lista reactiva de usuarios

  // Método para agregar un usuario
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

      // Inserta el usuario en la base de datos
      await DBHelper.insertUsuario(usuario);

      // Actualiza la lista de usuarios
      getUsuarios();
    } catch (e) {
      print("Error al agregar usuario: $e");
    }
  }

  // Método para obtener todos los usuarios
  void getUsuarios() async {
    try {
      List<Usuario> usuarios = await DBHelper.queryUsuarios();
      usuarioList.assignAll(usuarios);
    } catch (e) {
      print("Error al obtener usuarios: $e");
    }
  }

  // Método para eliminar un usuario
  Future<void> deleteUsuario(Usuario usuario) async {
    try {
      await DBHelper.deleteUsuario(usuario);
      getUsuarios();
    } catch (e) {
      print("Error al eliminar usuario: $e");
    }
  }

  // Método para actualizar un usuario
  Future<void> updateUsuario(String id, Map<String, dynamic> updates) async {
    try {
      await DBHelper.updateUsuario(id, updates);
      getUsuarios();
    } catch (e) {
      print("Error al actualizar usuario: $e");
    }
  }
}
