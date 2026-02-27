import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../mo_hinh/cong_viec.dart';

class DatabaseHelper {
  // ================= SINGLETON =================

  static final DatabaseHelper instance = DatabaseHelper._internal();
  static Database? _database;

  DatabaseHelper._internal();

  // ================= GET DATABASE =================

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('khong_gian.db');
    return _database!;
  }

  // ================= INIT DB =================

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  // ================= CREATE TABLE =================

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE cong_viec (
        id TEXT PRIMARY KEY,
        tieuDe TEXT NOT NULL,
        daHoanThanh INTEGER NOT NULL,
        thoiGianTao TEXT NOT NULL,
        thoiGianHen TEXT
      )
    ''');
  }

  // ================= INSERT =================

  Future<int> insertCongViec(CongViec congViec) async {
    final db = await instance.database;

    return await db.insert(
      'cong_viec',
      congViec.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // ================= GET ALL =================

  Future<List<CongViec>> getAllCongViec() async {
    final db = await instance.database;

    final result = await db.query('cong_viec', orderBy: 'thoiGianTao DESC');

    return result.map((e) => CongViec.fromMap(e)).toList();
  }

  // ================= GET BY ID =================

  Future<CongViec?> getCongViecById(String id) async {
    final db = await instance.database;

    final result = await db.query(
      'cong_viec',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (result.isNotEmpty) {
      return CongViec.fromMap(result.first);
    }
    return null;
  }

  // ================= UPDATE =================

  Future<int> updateCongViec(CongViec congViec) async {
    final db = await instance.database;

    return await db.update(
      'cong_viec',
      congViec.toMap(),
      where: 'id = ?',
      whereArgs: [congViec.id],
    );
  }

  // ================= DELETE =================

  Future<int> deleteCongViec(String id) async {
    final db = await instance.database;

    return await db.delete('cong_viec', where: 'id = ?', whereArgs: [id]);
  }

  // ================= DELETE ALL =================

  Future<void> deleteAllCongViec() async {
    final db = await instance.database;
    await db.delete('cong_viec');
  }

  // ================= CLOSE DB =================

  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}
