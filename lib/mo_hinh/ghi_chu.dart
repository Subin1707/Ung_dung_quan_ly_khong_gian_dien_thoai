class GhiChu {
  String id;
  String noiDung;
  String? hinhAnhPath;
  DateTime thoiGianTao;

  GhiChu({
    required this.id,
    required this.noiDung,
    this.hinhAnhPath,
    DateTime? thoiGianTao,
  }) : thoiGianTao = thoiGianTao ?? DateTime.now();
}
