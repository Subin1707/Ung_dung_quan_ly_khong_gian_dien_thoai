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
  }) : hinhAnhPaths = List.unmodifiable(hinhAnhPaths ?? []),
       videoPaths = List.unmodifiable(videoPaths ?? []),
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
    String p(int n) => n.toString().padLeft(2, '0');

    return "${p(thoiGianTao.day)}/${p(thoiGianTao.month)}/${thoiGianTao.year} "
        "${p(thoiGianTao.hour)}:${p(thoiGianTao.minute)}";
  }

  GhiChu copyWith({
    String? noiDung,
    List<String>? hinhAnhPaths,
    List<String>? videoPaths,
  }) {
    return GhiChu(
      id: id,
      noiDung: noiDung ?? this.noiDung,
      hinhAnhPaths: hinhAnhPaths ?? this.hinhAnhPaths,
      videoPaths: videoPaths ?? this.videoPaths,
      thoiGianTao: thoiGianTao,
      thoiGianCapNhat: DateTime.now(),
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
      id: map['id'] ?? '',
      noiDung: map['noiDung'] ?? '',
      hinhAnhPaths: List<String>.from(map['hinhAnhPaths'] ?? []),
      videoPaths: List<String>.from(map['videoPaths'] ?? []),
      thoiGianTao:
          DateTime.tryParse(map['thoiGianTao'] ?? '') ?? DateTime.now(),
      thoiGianCapNhat: map['thoiGianCapNhat'] != null
          ? DateTime.tryParse(map['thoiGianCapNhat'])
          : null,
    );
  }
}
