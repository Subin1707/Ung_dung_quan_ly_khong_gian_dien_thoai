import 'package:flutter/foundation.dart';
import '../mo_hinh/ghi_chu.dart';

class QuanLyGhiChu extends ChangeNotifier {
  final List<GhiChu> _danhSach = [];

  List<GhiChu> get danhSach => List.unmodifiable(_danhSach);

  String _taoId() => DateTime.now().millisecondsSinceEpoch.toString();

  void themGhiChu({
    required String tieuDe,
    required String noiDung,
    List<String>? hinhAnhPaths,
    List<String>? videoPaths,
  }) {
    final ghiChu = GhiChu(
      id: _taoId(),
      tieuDe: tieuDe,
      noiDung: noiDung,
      hinhAnhPaths: hinhAnhPaths ?? [],
      videoPaths: videoPaths ?? [],
      thoiGianTao: DateTime.now(),
      thoiGianCapNhat: null,
    );

    _danhSach.add(ghiChu);
    sapXepMoiNhat();
    notifyListeners();
  }

  void xoaGhiChu(String id) {
    _danhSach.removeWhere((g) => g.id == id);
    notifyListeners();
  }

  void capNhatGhiChu(
    String id, {
    String? tieuDe,
    String? noiDung,
    List<String>? hinhAnhPaths,
    List<String>? videoPaths,
  }) {
    final index = _danhSach.indexWhere((g) => g.id == id);
    if (index == -1) return;

    final ghiChuCu = _danhSach[index];

    _danhSach[index] = ghiChuCu.copyWith(
      tieuDe: tieuDe,
      noiDung: noiDung,
      hinhAnhPaths: hinhAnhPaths,
      videoPaths: videoPaths,
      thoiGianCapNhat: DateTime.now(),
    );

    sapXepMoiNhat();
    notifyListeners();
  }

  List<GhiChu> timKiem(String tuKhoa) {
    final key = tuKhoa.toLowerCase();
    return _danhSach.where((g) {
      return g.tieuDe.toLowerCase().contains(key) ||
          g.noiDung.toLowerCase().contains(key);
    }).toList();
  }

  List<GhiChu> locTheoLoai(LoaiNoiDung loai) {
    return _danhSach.where((g) => g.loaiNoiDung == loai).toList();
  }

  void sapXepMoiNhat() {
    _danhSach.sort((a, b) => b.thoiGianTao.compareTo(a.thoiGianTao));
  }

  void sapXepCuNhat() {
    _danhSach.sort((a, b) => a.thoiGianTao.compareTo(b.thoiGianTao));
    notifyListeners();
  }

  void xoaTatCa() {
    _danhSach.clear();
    notifyListeners();
  }

  GhiChu? layTheoId(String id) {
    try {
      return _danhSach.firstWhere((g) => g.id == id);
    } catch (_) {
      return null;
    }
  }
}
