import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../features/medication_management/domain/entities/adherence_log.dart';
import '../features/medication_management/domain/entities/medicine.dart';

class LocalDbService {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    final String dbPath = await getDatabasesPath();
    final String path = join(dbPath, 'medtrack.db');

    return openDatabase(
      path,
      version: 2,
      onCreate: (Database db, int version) async {
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
            startDate TEXT,
            endDate TEXT,
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
      onUpgrade: (Database db, int oldVersion, int newVersion) async {
        if (oldVersion < 2) {
          await db.execute('ALTER TABLE medicines ADD COLUMN startDate TEXT');
          await db.execute('ALTER TABLE medicines ADD COLUMN endDate TEXT');
        }
      },
    );
  }

  Future<void> insertMedicine(Medicine medicine) async {
    final Database db = await database;
    final Map<String, dynamic> json = medicine.toJson();
    json['scheduleTimes'] = medicine.scheduleTimes.join(',');
    json['isActive'] = medicine.isActive ? 1 : 0;
    
    await db.insert(
      'medicines',
      json,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Medicine>> getMedicines() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('medicines');
    return List<Medicine>.generate(maps.length, (int i) {
      final Map<String, dynamic> map = Map<String, dynamic>.from(maps[i]);
      map['scheduleTimes'] = (map['scheduleTimes'] as String).split(',');
      map['isActive'] = map['isActive'] == 1;
      return Medicine.fromJson(map);
    });
  }

  Future<void> insertAdherenceLog(AdherenceLog log) async {
    final Database db = await database;
    await db.insert(
      'adherence_logs',
      log.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<AdherenceLog>> getAdherenceLogs(String medicineId) async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'adherence_logs',
      where: 'medicineId = ?',
      whereArgs: <Object>[medicineId],
    );
    return maps.map((Map<String, dynamic> json) => AdherenceLog.fromJson(json)).toList();
  }
}
