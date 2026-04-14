// Developed by Hamas - Medtrack Project [100% Dart Implementation].
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../features/medication_management/domain/entities/medicine.dart';
import '../features/medication_management/domain/entities/adherence_log.dart';

class LocalDbService {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'medtrack.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE medicines (
            id TEXT PRIMARY KEY,
            userId TEXT,
            name TEXT,
            dosage TEXT,
            intervalType TEXT,
            customDayInterval INTEGER,
            scheduleTimes TEXT,
            mealContext TEXT,
            deliveryMethod TEXT,
            isActive INTEGER,
            createdAt TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE adherence_logs (
            id TEXT PRIMARY KEY,
            medicineId TEXT,
            scheduledTime TEXT,
            takenTime TEXT,
            status TEXT,
            mealNotes TEXT
          )
        ''');
      },
    );
  }

  // --- Medication Persistence ---

  Future<void> insertMedicine(Medicine medicine) async {
    final db = await database;
    await db.insert(
      'medicines',
      medicine.toJson()..['scheduleTimes'] = medicine.scheduleTimes.join(','),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Medicine>> getMedicines() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('medicines');
    return List.generate(maps.length, (i) {
      final map = Map<String, dynamic>.from(maps[i]);
      map['scheduleTimes'] = (map['scheduleTimes'] as String).split(',');
      map['isActive'] = map['isActive'] == 1;
      return Medicine.fromJson(map);
    });
  }

  // --- Adherence Persistence ---

  Future<void> insertAdherenceLog(AdherenceLog log) async {
    final db = await database;
    await db.insert(
      'adherence_logs',
      log.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<AdherenceLog>> getAdherenceLogs(String medicineId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'adherence_logs',
      where: 'medicineId = ?',
      whereArgs: [medicineId],
    );
    return maps.map((json) => AdherenceLog.fromJson(json)).toList();
  }
}
