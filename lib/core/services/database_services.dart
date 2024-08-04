// ignore_for_file: depend_on_referenced_packages

import 'package:flutter_clean_architecture_bloc_template/core/constants/constants.dart';
import 'package:flutter_clean_architecture_bloc_template/data/models/dummy_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._init();

  static Database? _database;

  DatabaseService._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB(Constants.databaseName);
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';

    await db.execute('''
      CREATE TABLE ${Constants.tableName} (
      ${DummyItem.id} $idType UNIQUE,
      ${DummyItem.name} $textType,
      )
      ''');
  }

  Future<DummyModel> createItem(DummyModel params) async {
    final db = await instance.database;

    final existingItem = await db.query(
      Constants.tableName,
      where: '${DummyItem.id} = ?',
      whereArgs: [params.id],
    );

    if (existingItem.isEmpty) {
      final item = await db.insert(
        Constants.tableName,
        params.toJson(),
        conflictAlgorithm: ConflictAlgorithm.fail,
      );
      return params.copy(id: item);
    } else {
      throw Exception('An item with id ${params.id} already exists.');
    }
  }

  Future<List<DummyModel>> getAllItem() async {
    final db = await instance.database;
    final result = await db.query(Constants.tableName);
    return result.map((json) => DummyModel.fromJson(json)).toList();
  }

  Future<int> deleteItem(int? id) async {
    final db = await instance.database;
    return await db.delete(Constants.tableName,
        where: '${DummyItem.id} = ?', whereArgs: [id]);
  }

  Future closeDatabase() async {
    final db = await instance.database;
    db.close();
  }

  Future<void> deleteDatabase(String path) async {
    final database = await instance.database;
    database.delete(Constants.tableName);
  }
}
