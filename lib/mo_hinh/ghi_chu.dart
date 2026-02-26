class GhiChu {
  final String id;
  String noiDung;
  String? duongDanAnh;
  String? duongDanVideo;
  DateTime thoiGianTao;

  GhiChu({
    required this.id,
    required this.noiDung,
    this.duongDanAnh,
    this.duongDanVideo,
    DateTime? thoiGianTao,
  }) : thoiGianTao = thoiGianTao ?? DateTime.now();

  void capNhatNoiDung(String noiDungMoi) {
    noiDung = noiDungMoi;
  }

  void capNhatAnh(String? duongDanMoi) {
    duongDanAnh = duongDanMoi;
  }

  void capNhatVideo(String? duongDanMoi) {
    duongDanVideo = duongDanMoi;
  }
}
