enum LoaiNoiDung { text, image, video, mix }

class GhiChu {
  final String id;
  final String noiDung;

  final List<String> hinhAnhPaths;
  final List<String> videoPaths;

  final DateTime thoiGianTao;
  final DateTime? thoiGianCapNhat;

  GhiChu({
    required this.id,
    required this.noiDung,
    List<String>? hinhAnhPaths,
    List<String>? videoPaths,
    DateTime? thoiGianTao,
    this.thoiGianCapNhat,
  }) : hinhAnhPaths = hinhAnhPaths ?? [],
       videoPaths = videoPaths ?? [],
       thoiGianTao = thoiGianTao ?? DateTime.now();

  bool get coAnh => hinhAnhPaths.isNotEmpty;
  bool get coVideo => videoPaths.isNotEmpty;

  LoaiNoiDung get loaiNoiDung {
    if (coAnh && coVideo) return LoaiNoiDung.mix;
    if (coAnh) return LoaiNoiDung.image;
    if (coVideo) return LoaiNoiDung.video;
    return LoaiNoiDung.text;
  }

  String get thoiGianFormatted {
    return "${thoiGianTao.day}/${thoiGianTao.month}/${thoiGianTao.year} "
        "${thoiGianTao.hour}:${thoiGianTao.minute}";
  }

  GhiChu copyWith({
    String? noiDung,
    List<String>? hinhAnhPaths,
    List<String>? videoPaths,
    DateTime? thoiGianCapNhat,
  }) {
    return GhiChu(
      id: id,
      noiDung: noiDung ?? this.noiDung,
      hinhAnhPaths: hinhAnhPaths ?? this.hinhAnhPaths,
      videoPaths: videoPaths ?? this.videoPaths,
      thoiGianTao: thoiGianTao,
      thoiGianCapNhat: thoiGianCapNhat ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'noiDung': noiDung,
      'hinhAnhPaths': hinhAnhPaths,
      'videoPaths': videoPaths,
      'thoiGianTao': thoiGianTao.toIso8601String(),
      'thoiGianCapNhat': thoiGianCapNhat?.toIso8601String(),
    };
  }

  factory GhiChu.fromMap(Map<String, dynamic> map) {
    return GhiChu(
      id: map['id'],
      noiDung: map['noiDung'],
      hinhAnhPaths: List<String>.from(map['hinhAnhPaths'] ?? []),
      videoPaths: List<String>.from(map['videoPaths'] ?? []),
      thoiGianTao: DateTime.parse(map['thoiGianTao']),
      thoiGianCapNhat: map['thoiGianCapNhat'] != null
          ? DateTime.parse(map['thoiGianCapNhat'])
          : null,
    );
  }
}
