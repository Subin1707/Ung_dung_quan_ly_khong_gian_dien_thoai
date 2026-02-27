import '../mo_hinh/cong_viec.dart';
import '../database/database_helper.dart';

class QuanLyCongViec {
  final List<CongViec> _danhSach = [];

  List<CongViec> get danhSach => List.unmodifiable(_danhSach);

  // ================= LOAD DATABASE =================

  Future<void> loadDuLieu() async {
    final data = await DatabaseHelper.instance.getAllCongViec();
    _danhSach
      ..clear()
      ..addAll(data);
  }

  // ================= THÊM =================

  Future<void> themCongViec(String tieuDe, {DateTime? thoiGianHen}) async {
    final congViec = CongViec(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      tieuDe: tieuDe,
      thoiGianHen: thoiGianHen,
    );

    await DatabaseHelper.instance.insertCongViec(congViec);
    _danhSach.add(congViec);
  }

  // ================= XÓA =================

  Future<void> xoaCongViec(String id) async {
    await DatabaseHelper.instance.deleteCongViec(id);
    _danhSach.removeWhere((cv) => cv.id == id);
  }

  // ================= TOGGLE =================

  Future<void> toggleHoanThanh(String id) async {
    final index = _danhSach.indexWhere((e) => e.id == id);
    if (index == -1) return;

    final cv = _danhSach[index];
    cv.toggleHoanThanh();

    await DatabaseHelper.instance.updateCongViec(cv);
  }

  // ================= CẬP NHẬT =================

  Future<void> capNhatCongViec(
    String id, {
    String? tieuDe,
    DateTime? thoiGianHen,
  }) async {
    final index = _danhSach.indexWhere((e) => e.id == id);
    if (index == -1) return;

    final cv = _danhSach[index];

    if (tieuDe != null) {
      cv.capNhatTieuDe(tieuDe);
    }

    cv.capNhatHenGio(thoiGianHen);

    await DatabaseHelper.instance.updateCongViec(cv);
  }

  // ================= TÌM KIẾM =================

  List<CongViec> timKiem(String tuKhoa) {
    return _danhSach
        .where((cv) => cv.tieuDe.toLowerCase().contains(tuKhoa.toLowerCase()))
        .toList();
  }

  // ================= LỌC =================

  List<CongViec> chiChuaHoanThanh() {
    return _danhSach.where((cv) => !cv.daHoanThanh).toList();
  }

  List<CongViec> chiDaHoanThanh() {
    return _danhSach.where((cv) => cv.daHoanThanh).toList();
  }

  // ================= SẮP XẾP =================

  void sapXepMoiNhat() {
    _danhSach.sort((a, b) => b.thoiGianTao.compareTo(a.thoiGianTao));
  }

  void sapXepCuNhat() {
    _danhSach.sort((a, b) => a.thoiGianTao.compareTo(b.thoiGianTao));
  }

  void sapXepTheoHenSomNhat() {
    _danhSach.sort((a, b) {
      if (a.thoiGianHen == null) return 1;
      if (b.thoiGianHen == null) return -1;
      return a.thoiGianHen!.compareTo(b.thoiGianHen!);
    });
  }
}
