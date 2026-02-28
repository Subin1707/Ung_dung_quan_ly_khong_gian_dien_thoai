enum TrangThaiCongViec { chuaHoanThanh, daHoanThanh }

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

  TrangThaiCongViec get trangThai => daHoanThanh
      ? TrangThaiCongViec.daHoanThanh
      : TrangThaiCongViec.chuaHoanThanh;

  String get thoiGianTaoFormatted {
    String p(int n) => n.toString().padLeft(2, '0');
    return "${p(thoiGianTao.day)}/${p(thoiGianTao.month)}/${thoiGianTao.year} "
        "${p(thoiGianTao.hour)}:${p(thoiGianTao.minute)}";
  }

  String? get thoiGianHenFormatted {
    if (thoiGianHen == null) return null;

    String p(int n) => n.toString().padLeft(2, '0');
    return "${p(thoiGianHen!.day)}/${p(thoiGianHen!.month)}/${thoiGianHen!.year} "
        "${p(thoiGianHen!.hour)}:${p(thoiGianHen!.minute)}";
  }

  CongViec copyWith({
    String? tieuDe,
    bool? daHoanThanh,
    DateTime? thoiGianHen,
  }) {
    return CongViec(
      id: id,
      tieuDe: tieuDe ?? this.tieuDe,
      daHoanThanh: daHoanThanh ?? this.daHoanThanh,
      thoiGianTao: thoiGianTao,
      thoiGianHen: thoiGianHen ?? this.thoiGianHen,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tieuDe': tieuDe,
      'daHoanThanh': daHoanThanh ? 1 : 0,
      'thoiGianTao': thoiGianTao.toIso8601String(),
      'thoiGianHen': thoiGianHen?.toIso8601String(),
    };
  }

  factory CongViec.fromMap(Map<String, dynamic> map) {
    return CongViec(
      id: map['id'] ?? '',
      tieuDe: map['tieuDe'] ?? '',
      daHoanThanh: map['daHoanThanh'] == 1,
      thoiGianTao:
          DateTime.tryParse(map['thoiGianTao'] ?? '') ?? DateTime.now(),
      thoiGianHen: map['thoiGianHen'] != null
          ? DateTime.tryParse(map['thoiGianHen'])
          : null,
    );
  }
}
