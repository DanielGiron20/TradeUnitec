import 'package:sqflite/sqflite.dart';
import 'package:tradeunitec/BaseDeDatos/usuario.dart';

class DBHelper {
  static Database? _db;
  static const int _version = 1;
  static const String _tableNameUsuarios = "usuarios";

  // Inicializa la base de datos
  static Future<void> initDB() async {
    if (_db != null) return;

    try {
      String path = '${await getDatabasesPath()}pumitas.db';
      _db = await openDatabase(
        path,
        version: _version,
        onCreate: (db, version) {
          db.execute("CREATE TABLE $_tableNameUsuarios("
              "id TEXT PRIMARY KEY,"
              "uid TEXT,"
              "name TEXT,"
              "email TEXT,"
              "description TEXT,"
              "logo TEXT)");
        },
      );
    } catch (e) {
      print("Error al inicializar la base de datos: $e");
    }
  }

  // Inserta un nuevo usuario
  static Future<int> insertUsuario(Usuario usuario) async {
    try {
      return await _db?.insert(_tableNameUsuarios, usuario.toJson()) ?? 0;
    } catch (e) {
      print("Error al insertar usuario: $e");
      return 0;
    }
  }

  // Consulta todos los usuarios
  static Future<List<Usuario>> queryUsuarios() async {
    try {
      final List<Map<String, dynamic>> usuariosMapList =
          await _db!.query(_tableNameUsuarios);
      return usuariosMapList
          .map((usuarioMap) => Usuario.fromJson(usuarioMap))
          .toList();
    } catch (e) {
      print("Error al consultar usuarios: $e");
      return [];
    }
  }

  // Elimina un usuario
  static Future<int> deleteUsuario(String id) async {
    try {
      return await _db!.delete(
        _tableNameUsuarios,
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      print("Error al eliminar usuario: $e");
      return 0;
    }
  }

  // Actualiza un usuario
  static Future<int> updateUsuario(
      String id, Map<String, dynamic> updates) async {
    try {
      return await _db!.update(
        _tableNameUsuarios,
        updates,
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      print("Error al actualizar usuario: $e");
      return 0;
    }
  }
}
