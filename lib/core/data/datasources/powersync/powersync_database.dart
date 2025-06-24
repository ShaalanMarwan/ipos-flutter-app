import 'package:powersync/powersync.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'schema.dart';

class AppPowerSyncDatabase {
  static AppPowerSyncDatabase? _instance;
  static PowerSyncDatabase? _db;

  AppPowerSyncDatabase._();

  static AppPowerSyncDatabase get instance {
    _instance ??= AppPowerSyncDatabase._();
    return _instance!;
  }

  PowerSyncDatabase get db {
    if (_db == null) {
      throw Exception('PowerSync database not initialized');
    }
    return _db!;
  }

  Future<void> initialize() async {
    if (_db != null) return;

    final dir = await getApplicationDocumentsDirectory();
    final path = join(dir.path, 'ipos.db');

    _db = PowerSyncDatabase(
      schema: schema,
      path: path,
    );

    await _db!.initialize();
  }

  Stream<List<T>> watchQuery<T>(
    String sql, {
    List<Object?>? parameters,
    T Function(Map<String, dynamic>)? mapper,
  }) {
    return db.watch(sql, parameters: parameters ?? []).map((results) {
      return results.map((row) {
        final map = Map<String, dynamic>.from(row);
        if (mapper != null) {
          return mapper(map);
        }
        // Default: return raw map as dynamic
        return map as T;
      }).toList();
    });
  }

  Future<List<T>> query<T>(
    String sql, {
    List<Object?>? parameters,
    T Function(Map<String, dynamic>)? mapper,
  }) async {
    final results = await db.execute(sql, parameters ?? []);
    return results.map((row) {
      final map = Map<String, dynamic>.from(row);
      if (mapper != null) {
        return mapper(map);
      }
      return map as T;
    }).toList();
  }

  Future<void> execute(String sql, [List<Object?>? parameters]) async {
    await db.execute(sql, parameters ?? []);
  }

  Future<void> disconnect() async {
    await _db?.disconnect();
    _db = null;
  }

  Future<void> clearDatabase() async {
    await execute('DELETE FROM products');
    await execute('DELETE FROM categories');
    await execute('DELETE FROM orders');
    await execute('DELETE FROM order_items');
    await execute('DELETE FROM inventory');
    await execute('DELETE FROM branches');
    await execute('DELETE FROM users');
  }
}