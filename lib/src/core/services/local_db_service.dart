import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../../features/medication_management/domain/entities/adherence_log.dart';
import '../../features/medication_management/domain/entities/medicine.dart';

class LocalDbService {
  factory LocalDbService() => _instance;
  LocalDbService._internal();
  static final LocalDbService _instance = LocalDbService._internal();

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
      version: 5,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE medicines (
            id TEXT PRIMARY KEY,
            userId TEXT,
            name TEXT,
            dosage TEXT,
            intervalType TEXT,
            intervalCount INTEGER,
            intervalUnit TEXT,
            scheduleTimes TEXT,
            mealContext TEXT,
            deliveryMethod TEXT,
            startDate TEXT,
            endDate TEXT,
            durationDays INTEGER,
            isActive INTEGER,
            initialQuantity INTEGER,
            remainingQuantity INTEGER,
            lowStockThreshold INTEGER,
            isPrn INTEGER DEFAULT 0,
            minCooldownHours INTEGER DEFAULT 4,
            createdAt TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE adherence_logs (
            id TEXT PRIMARY KEY,
            medicineId TEXT,
            userId TEXT,
            scheduledTime TEXT,
            takenTime TEXT,
            status TEXT,
            mealNotes TEXT
          )
        ''');
      },
      onUpgrade: (Database db, int oldVersion, int newVersion) async {
        if (oldVersion < 3) {
          final List<String> columns = <String>[
            'intervalCount',
            'intervalUnit',
            'durationDays',
            'initialQuantity',
            'remainingQuantity',
            'lowStockThreshold',
          ];

          for (final String column in columns) {
            try {
              if (column == 'intervalUnit') {
                await db.execute(
                  'ALTER TABLE medicines ADD COLUMN $column TEXT DEFAULT "days"',
                );
              } else if (column.contains('Quantity') ||
                  column == 'intervalCount' ||
                  column == 'lowStockThreshold' ||
                  column == 'durationDays') {
                await db.execute(
                  'ALTER TABLE medicines ADD COLUMN $column INTEGER DEFAULT 0',
                );
              } else {
                await db.execute(
                  'ALTER TABLE medicines ADD COLUMN $column TEXT',
                );
              }
            } catch (e) {
              // Column might already exist
            }
          }
        }
        if (oldVersion < 4) {
          try {
            await db.execute(
              'ALTER TABLE adherence_logs ADD COLUMN userId TEXT DEFAULT ""',
            );
          } catch (e) {
            // Column may already exist
          }
        }
        if (oldVersion < 5) {
          try {
            await db.execute(
              'ALTER TABLE medicines ADD COLUMN isPrn INTEGER DEFAULT 0',
            );
            await db.execute(
              'ALTER TABLE medicines ADD COLUMN minCooldownHours INTEGER DEFAULT 4',
            );
          } catch (e) {
            // Column may already exist
          }
        }
      },
    );
  }

  Future<void> insertMedicine(Medicine medicine) async {
    final Database db = await database;
    final Map<String, dynamic> json = medicine.toJson();
    json['scheduleTimes'] = medicine.scheduleTimes.join(',');
    json['isActive'] = medicine.isActive ? 1 : 0;
    json['isPrn'] = medicine.isPrn ? 1 : 0;
    json['minCooldownHours'] = medicine.minCooldownHours;

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
      final String scheduleStr = (map['scheduleTimes'] as String?) ?? '';
      map['scheduleTimes'] = scheduleStr
          .split(',')
          .map((String s) => s.trim())
          .where((String s) => s.isNotEmpty)
          .toList();
      map['isActive'] = map['isActive'] == 1;
      map['isPrn'] = (map['isPrn'] ?? 0) == 1;
      map['minCooldownHours'] = (map['minCooldownHours'] as num?)?.toInt() ?? 4;
      return Medicine.fromJson(map);
    });
  }

  Future<void> updateMedicineQuantity(String id, int remainingQuantity) async {
    final Database db = await database;
    await db.update(
      'medicines',
      <String, dynamic>{'remainingQuantity': remainingQuantity},
      where: 'id = ?',
      whereArgs: <Object>[id],
    );
  }

  Future<void> toggleMedicineActive(String id, bool isActive) async {
    final Database db = await database;
    await db.update(
      'medicines',
      <String, dynamic>{'isActive': isActive ? 1 : 0},
      where: 'id = ?',
      whereArgs: <Object>[id],
    );
  }

  Future<void> deleteMedicine(String medicineId) async {
    final Database db = await database;
    await db.delete(
      'medicines',
      where: 'id = ?',
      whereArgs: <Object>[medicineId],
    );
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
    return maps
        .map((Map<String, dynamic> json) => AdherenceLog.fromJson(json))
        .toList();
  }

  Future<List<AdherenceLog>> getAllAdherenceLogs() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('adherence_logs');
    return maps
        .map((Map<String, dynamic> json) => AdherenceLog.fromJson(json))
        .toList();
  }

  Future<void> clearAllData() async {
    final Database db = await database;
    await db.delete('medicines');
    await db.delete('adherence_logs');
  }
}
