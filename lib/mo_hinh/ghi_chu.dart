class GhiChu {
  String id;
  String noiDung;

  String? hinhAnhPath;
  String? videoPath;

  DateTime thoiGianTao;

  GhiChu({
    required this.id,
    required this.noiDung,
    this.hinhAnhPath,
    this.videoPath,
    DateTime? thoiGianTao,
  }) : thoiGianTao = thoiGianTao ?? DateTime.now();

  // Kiểm tra loại nội dung
  bool get coAnh => hinhAnhPath != null;
  bool get coVideo => videoPath != null;
}
