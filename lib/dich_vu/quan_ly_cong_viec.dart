import '../mo_hinh/cong_viec.dart';

class QuanLyCongViec {
  final List<CongViec> _danhSach = [];

  // ================= GET LIST =================

  List<CongViec> get danhSach => List.unmodifiable(_danhSach);

  String _taoId() => DateTime.now().millisecondsSinceEpoch.toString();

  // ================= THÊM =================

  void themCongViec(String tieuDe, {DateTime? thoiGianHen}) {
    _danhSach.add(
      CongViec(id: _taoId(), tieuDe: tieuDe, thoiGianHen: thoiGianHen),
    );
  }

  // ================= XÓA =================

  void xoaCongViec(String id) {
    _danhSach.removeWhere((cv) => cv.id == id);
  }

  // ================= TOGGLE =================

  void toggleHoanThanh(String id) {
    final index = _danhSach.indexWhere((e) => e.id == id);
    if (index == -1) return;

    _danhSach[index].toggleHoanThanh();
  }

  // ================= CẬP NHẬT =================

  void capNhatCongViec(String id, {String? tieuDe, DateTime? thoiGianHen}) {
    final index = _danhSach.indexWhere((e) => e.id == id);
    if (index == -1) return;

    final cv = _danhSach[index];

    if (tieuDe != null) {
      cv.capNhatTieuDe(tieuDe);
    }

    cv.capNhatHenGio(thoiGianHen);
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
