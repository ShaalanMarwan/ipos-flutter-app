import 'package:hive_flutter/hive_flutter.dart';
import '../datasources/powersync/powersync_database.dart';
import '../datasources/remote/api_client.dart';
import 'dart:convert';

abstract class BaseRepository<T> {
  final AppPowerSyncDatabase powerSync;
  final ApiClient apiClient;
  final HiveInterface hive;
  final String cacheBoxName;

  BaseRepository({
    required this.powerSync,
    required this.apiClient,
    required this.hive,
    required this.cacheBoxName,
  });

  // Abstract methods to be implemented by subclasses
  String getWatchQuery();
  String getTableName();
  T fromJson(Map<String, dynamic> json);
  Map<String, dynamic> toJson(T entity);
  int getCacheTTL() => 3600000; // 1 hour default

  // PowerSync as source of truth
  Stream<List<T>> watchAll() {
    return powerSync.watchQuery<T>(
      getWatchQuery(),
      mapper: fromJson,
    );
  }

  Stream<T?> watchById(String id) {
    final query = 'SELECT * FROM ${getTableName()} WHERE id = ?';
    return powerSync.watchQuery<T>(
      query,
      parameters: [id],
      mapper: fromJson,
    ).map((list) => list.isEmpty ? null : list.first);
  }

  Future<List<T>> getAll() async {
    return powerSync.query<T>(
      getWatchQuery(),
      mapper: fromJson,
    );
  }

  Future<T?> getById(String id) async {
    final query = 'SELECT * FROM ${getTableName()} WHERE id = ?';
    final results = await powerSync.query<T>(
      query,
      parameters: [id],
      mapper: fromJson,
    );
    return results.isEmpty ? null : results.first;
  }

  // Hive for API response caching
  Future<T?> getCached(String key) async {
    final box = await hive.openBox<String>(cacheBoxName);
    final cached = box.get(key);

    if (cached != null) {
      final data = jsonDecode(cached);
      final timestamp = data['timestamp'] as int;
      final ttl = getCacheTTL();

      if (DateTime.now().millisecondsSinceEpoch - timestamp < ttl) {
        return fromJson(data['value']);
      }
    }
    return null;
  }

  Future<void> cache(String key, T value) async {
    final box = await hive.openBox<String>(cacheBoxName);
    await box.put(key, jsonEncode({
      'value': toJson(value),
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    }));
  }

  Future<void> clearCache() async {
    final box = await hive.openBox<String>(cacheBoxName);
    await box.clear();
  }

  // API operations with caching
  Future<T?> fetchFromApi(String endpoint, {bool useCache = true}) async {
    if (useCache) {
      final cached = await getCached(endpoint);
      if (cached != null) return cached;
    }

    try {
      final response = await apiClient.get<Map<String, dynamic>>(endpoint);
      final entity = fromJson(response);
      
      if (useCache) {
        await cache(endpoint, entity);
      }
      
      return entity;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<T>> fetchListFromApi(String endpoint, {bool useCache = true}) async {
    final cacheKey = 'list_$endpoint';
    
    if (useCache) {
      final cachedList = await getCachedList(cacheKey);
      if (cachedList != null) return cachedList;
    }

    try {
      final response = await apiClient.get<List<dynamic>>(endpoint);
      final entities = response.map((json) => fromJson(json)).toList();
      
      if (useCache) {
        await cacheList(cacheKey, entities);
      }
      
      return entities;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<T>?> getCachedList(String key) async {
    final box = await hive.openBox<String>(cacheBoxName);
    final cached = box.get(key);

    if (cached != null) {
      final data = jsonDecode(cached);
      final timestamp = data['timestamp'] as int;
      final ttl = getCacheTTL();

      if (DateTime.now().millisecondsSinceEpoch - timestamp < ttl) {
        final list = data['value'] as List;
        return list.map((json) => fromJson(json)).toList();
      }
    }
    return null;
  }

  Future<void> cacheList(String key, List<T> entities) async {
    final box = await hive.openBox<String>(cacheBoxName);
    await box.put(key, jsonEncode({
      'value': entities.map((e) => toJson(e)).toList(),
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    }));
  }
}