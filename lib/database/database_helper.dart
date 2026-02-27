import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../mo_hinh/cong_viec.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('khong_gian.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE cong_viec (
        id TEXT PRIMARY KEY,
        tieuDe TEXT,
        daHoanThanh INTEGER,
        thoiGianTao TEXT,
        thoiGianHen TEXT
      )
    ''');
  }

  // ================= CRUD =================

  Future<void> insertCongViec(CongViec congViec) async {
    final db = await instance.database;
    await db.insert('cong_viec', congViec.toMap());
  }

  Future<List<CongViec>> getAllCongViec() async {
    final db = await instance.database;
    final result = await db.query('cong_viec');

    return result.map((e) => CongViec.fromMap(e)).toList();
  }

  Future<void> updateCongViec(CongViec congViec) async {
    final db = await instance.database;
    await db.update(
      'cong_viec',
      congViec.toMap(),
      where: 'id = ?',
      whereArgs: [congViec.id],
    );
  }

  Future<void> deleteCongViec(String id) async {
    final db = await instance.database;
    await db.delete('cong_viec', where: 'id = ?', whereArgs: [id]);
  }
}
