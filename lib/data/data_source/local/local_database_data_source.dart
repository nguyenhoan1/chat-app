import 'package:flutter_clean_architecture_bloc_template/core/services/database_services.dart';
import 'package:flutter_clean_architecture_bloc_template/data/models/dummy_model.dart';

abstract class LocalDatabaseDataSource {
  Future<DummyModel> createItem(DummyModel params);
  Future<List<DummyModel>> getAllItems();
  Future<int> deleteItem(int? id);
  Future<void> closeDatabase();
  Future<void> deleteDatabase(String path);
}

class LocalDatabaseDataSourceImpl implements LocalDatabaseDataSource {
  final DatabaseService databaseService;

  LocalDatabaseDataSourceImpl({required this.databaseService});
  @override
  Future<void> closeDatabase() async {
    await databaseService.closeDatabase();
  }

  @override
  Future<DummyModel> createItem(DummyModel params) async {
    return await databaseService.createItem(params);
  }

  @override
  Future<void> deleteDatabase(String path) async {
    return await databaseService.deleteDatabase(path);
  }

  @override
  Future<int> deleteItem(int? id) async {
    return await databaseService.deleteItem(id);
  }

  @override
  Future<List<DummyModel>> getAllItems() async {
    return await databaseService.getAllItem();
  }
}
