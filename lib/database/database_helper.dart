import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../mo_hinh/cong_viec.dart';
import '../mo_hinh/ghi_chu.dart';

class DatabaseHelper {
  // ================= SINGLETON =================

  static final DatabaseHelper instance = DatabaseHelper._internal();
  static Database? _database;

  static const String _dbName = 'khong_gian.db';
  static const int _dbVersion = 2;

  DatabaseHelper._internal();

  // ================= GET DATABASE =================

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  // ================= INIT DB =================

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);

    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
    );
  }

  // ================= CREATE TABLE =================

  Future<void> _createDB(Database db, int version) async {
    // ===== Bảng công việc =====
    await db.execute('''
      CREATE TABLE cong_viec (
        id TEXT PRIMARY KEY,
        tieuDe TEXT NOT NULL,
        daHoanThanh INTEGER NOT NULL,
        thoiGianTao TEXT NOT NULL,
        thoiGianHen TEXT
      )
    ''');

    await db.execute(
      'CREATE INDEX idx_cong_viec_tao ON cong_viec(thoiGianTao)',
    );

    // ===== Bảng ghi chú =====
    await db.execute('''
      CREATE TABLE ghi_chu (
        id TEXT PRIMARY KEY,
        tieuDe TEXT NOT NULL,
        noiDung TEXT NOT NULL,
        hinhAnhPaths TEXT,
        videoPaths TEXT,
        thoiGianTao TEXT NOT NULL,
        thoiGianCapNhat TEXT
      )
    ''');

    await db.execute('CREATE INDEX idx_ghi_chu_tao ON ghi_chu(thoiGianTao)');
  }

  // ================= ON UPGRADE =================

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        CREATE TABLE ghi_chu (
          id TEXT PRIMARY KEY,
          tieuDe TEXT NOT NULL,
          noiDung TEXT NOT NULL,
          hinhAnhPaths TEXT,
          videoPaths TEXT,
          thoiGianTao TEXT NOT NULL,
          thoiGianCapNhat TEXT
        )
      ''');
    }
  }

  // ============================================================
  // ===================== CRUD CONG VIEC =======================
  // ============================================================

  Future<int> insertCongViec(CongViec congViec) async {
    final db = await database;
    return await db.insert(
      'cong_viec',
      congViec.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<CongViec>> getAllCongViec() async {
    final db = await database;
    final result = await db.query('cong_viec', orderBy: 'thoiGianTao DESC');
    return result.map((e) => CongViec.fromMap(e)).toList();
  }

  Future<int> updateCongViec(CongViec congViec) async {
    final db = await database;
    return await db.update(
      'cong_viec',
      congViec.toMap(),
      where: 'id = ?',
      whereArgs: [congViec.id],
    );
  }

  Future<int> deleteCongViec(String id) async {
    final db = await database;
    return await db.delete('cong_viec', where: 'id = ?', whereArgs: [id]);
  }

  // ============================================================
  // ======================= CRUD GHI CHU =======================
  // ============================================================

  Future<int> insertGhiChu(GhiChu ghiChu) async {
    final db = await database;
    return await db.insert(
      'ghi_chu',
      ghiChu.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<GhiChu>> getAllGhiChu() async {
    final db = await database;
    final result = await db.query('ghi_chu', orderBy: 'thoiGianTao DESC');
    return result.map((e) => GhiChu.fromMap(e)).toList();
  }

  Future<int> updateGhiChu(GhiChu ghiChu) async {
    final db = await database;
    return await db.update(
      'ghi_chu',
      ghiChu.toMap(),
      where: 'id = ?',
      whereArgs: [ghiChu.id],
    );
  }

  Future<int> deleteGhiChu(String id) async {
    final db = await database;
    return await db.delete('ghi_chu', where: 'id = ?', whereArgs: [id]);
  }

  // ================= DELETE ALL =================

  Future<void> deleteAllData() async {
    final db = await database;
    await db.delete('cong_viec');
    await db.delete('ghi_chu');
  }

  // ================= CLOSE =================

  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
