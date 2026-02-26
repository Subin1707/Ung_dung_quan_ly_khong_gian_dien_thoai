class CongViec {
  final String id;
  String tieuDe;
  bool daHoanThanh;
  DateTime thoiGianTao;
  DateTime? thoiGianHen;

  CongViec({
    required this.id,
    required this.tieuDe,
    this.daHoanThanh = false,
    DateTime? thoiGianTao,
    this.thoiGianHen,
  }) : thoiGianTao = thoiGianTao ?? DateTime.now();

  void toggleHoanThanh() {
    daHoanThanh = !daHoanThanh;
  }

  void capNhatTieuDe(String tieuDeMoi) {
    tieuDe = tieuDeMoi;
  }

  void capNhatHenGio(DateTime? thoiGianMoi) {
    thoiGianHen = thoiGianMoi;
  }
}
