import '../mo_hinh/ghi_chu.dart';

class QuanLyGhiChu {
  final List<GhiChu> _danhSach = [];

  /// Trả về danh sách chỉ đọc
  List<GhiChu> get danhSach => List.unmodifiable(_danhSach);

  String _taoId() => DateTime.now().millisecondsSinceEpoch.toString();

  // ================= THÊM =================

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
      hinhAnhPaths: hinhAnhPaths,
      videoPaths: videoPaths,
    );

    _danhSach.add(ghiChu);
  }

  // ================= XÓA =================

  void xoaGhiChu(String id) {
    _danhSach.removeWhere((g) => g.id == id);
  }

  // ================= CẬP NHẬT =================

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
    );
  }

  // ================= TÌM KIẾM =================

  List<GhiChu> timKiem(String tuKhoa) {
    return _danhSach.where((g) {
      final key = tuKhoa.toLowerCase();
      return g.tieuDe.toLowerCase().contains(key) ||
          g.noiDung.toLowerCase().contains(key);
    }).toList();
  }

  // ================= LỌC THEO LOẠI =================

  List<GhiChu> locTheoLoai(LoaiNoiDung loai) {
    return _danhSach.where((g) => g.loaiNoiDung == loai).toList();
  }

  // ================= SẮP XẾP =================

  void sapXepMoiNhat() {
    _danhSach.sort((a, b) => b.thoiGianTao.compareTo(a.thoiGianTao));
  }

  void sapXepCuNhat() {
    _danhSach.sort((a, b) => a.thoiGianTao.compareTo(b.thoiGianTao));
  }
}