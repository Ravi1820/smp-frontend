import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._();
  static Database? _database;

  DatabaseHelper._();

  factory DatabaseHelper() => _instance;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    String path = join(await getDatabasesPath(), 'smp_local_database.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE IF NOT EXISTS AllDeviceIDs(id INTEGER PRIMARY KEY, device_id TEXT)',
        );
      },
    );
  }

  Future<void> storePushNotificationToken(String pushNotificationToken) async {
    final db = await database;
    await db.insert(
      'AllDeviceIDs',
      {'device_id': pushNotificationToken},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteAllPushNotificationTokens() async {
    final db = await database;
    await db.delete('AllDeviceIDs');
  }

  Future<List<String>> getAllPushNotificationTokens() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('AllDeviceIDs');
    List<String> deviceIds = [];
    for (int i = 0; i < maps.length; i++) {
      deviceIds.add(maps[i]['device_id'] as String);
    }
    return deviceIds;
  }
}
