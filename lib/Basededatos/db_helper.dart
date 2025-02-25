import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tradeunitec/Basededatos/usuario.dart';

class DbHelper {
  static final DbHelper _instance = DbHelper._internal();
  static Database? _database;

  factory DbHelper() {
    return _instance;
  }

  DbHelper._internal();

  // Abrir o crear la base de datos
  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'trade_unitec.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  // Crear la tabla
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id TEXT PRIMARY KEY,
        uid TEXT,
        name TEXT,
        email TEXT,
        description TEXT,
        logo TEXT,
        phoneNumber TEXT
      )
    ''');
  }

  // Insertar un nuevo usuario
  Future<void> insertUser(Usuario user) async {
    final db = await database;
    await db.insert(
      'users',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Obtener todos los usuarios
  Future<List<Usuario>> getUsers() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('users');

    return List.generate(maps.length, (i) {
      return Usuario.fromMap(maps[i]);
    });
  }

  // Actualizar un usuario
  Future<void> updateUser(Usuario user) async {
    final db = await database;
    await db.update(
      'users',
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  // Eliminar un usuario
  Future<void> deleteUser(String id) async {
    final db = await database;
    await db.delete(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
