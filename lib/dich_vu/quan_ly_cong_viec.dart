import '../mo_hinh/cong_viec.dart';

class QuanLyCongViec {
  final List<CongViec> _danhSach = [];

  List<CongViec> get danhSach => List.unmodifiable(_danhSach);

  String _taoId() => DateTime.now().millisecondsSinceEpoch.toString();

  void themCongViec(String tieuDe, {DateTime? thoiGianHen}) {
    _danhSach.add(
      CongViec(id: _taoId(), tieuDe: tieuDe, thoiGianHen: thoiGianHen),
    );
  }

  void xoaCongViec(String id) {
    _danhSach.removeWhere((cv) => cv.id == id);
  }

  void toggleHoanThanh(String id) {
    final cv = _danhSach.firstWhere((e) => e.id == id);
    cv.toggleHoanThanh();
  }

  void capNhatCongViec(String id, {String? tieuDe, DateTime? thoiGianHen}) {
    final cv = _danhSach.firstWhere((e) => e.id == id);

    if (tieuDe != null) {
      cv.capNhatTieuDe(tieuDe);
    }

    cv.capNhatHenGio(thoiGianHen);
  }
}
