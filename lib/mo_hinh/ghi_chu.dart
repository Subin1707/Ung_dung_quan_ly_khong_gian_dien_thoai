import 'dart:convert';

enum LoaiNoiDung { text, image, video, mix }

class GhiChu {
  final String id;
  final String tieuDe;
  final String noiDung;

  final List<String> hinhAnhPaths;
  final List<String> videoPaths;

  final DateTime thoiGianTao;
  final DateTime? thoiGianCapNhat;

  GhiChu({
    required this.id,
    required this.tieuDe,
    required this.noiDung,
    List<String>? hinhAnhPaths,
    List<String>? videoPaths,
    DateTime? thoiGianTao,
    this.thoiGianCapNhat,
  }) : hinhAnhPaths = List.unmodifiable(hinhAnhPaths ?? []),
       videoPaths = List.unmodifiable(videoPaths ?? []),
       thoiGianTao = thoiGianTao ?? DateTime.now();

  // ================= CHECK MEDIA =================

  bool get coAnh => hinhAnhPaths.isNotEmpty;
  bool get coVideo => videoPaths.isNotEmpty;

  LoaiNoiDung get loaiNoiDung {
    if (coAnh && coVideo) return LoaiNoiDung.mix;
    if (coAnh) return LoaiNoiDung.image;
    if (coVideo) return LoaiNoiDung.video;
    return LoaiNoiDung.text;
  }

  // ================= FORMAT TIME =================

  String get thoiGianFormatted {
    String p(int n) => n.toString().padLeft(2, '0');

    return "${p(thoiGianTao.day)}/${p(thoiGianTao.month)}/${thoiGianTao.year} "
        "${p(thoiGianTao.hour)}:${p(thoiGianTao.minute)}";
  }

  // ================= COPY WITH (FIX LỖI Ở ĐÂY) =================

  GhiChu copyWith({
    String? tieuDe,
    String? noiDung,
    List<String>? hinhAnhPaths,
    List<String>? videoPaths,
    DateTime? thoiGianCapNhat, // 👈 thêm tham số
  }) {
    return GhiChu(
      id: id,
      tieuDe: tieuDe ?? this.tieuDe,
      noiDung: noiDung ?? this.noiDung,
      hinhAnhPaths: hinhAnhPaths ?? this.hinhAnhPaths,
      videoPaths: videoPaths ?? this.videoPaths,
      thoiGianTao: thoiGianTao,
      thoiGianCapNhat: thoiGianCapNhat ?? this.thoiGianCapNhat,
    );
  }

  // ================= SQLITE MAP =================

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tieuDe': tieuDe,
      'noiDung': noiDung,
      'hinhAnhPaths': jsonEncode(hinhAnhPaths),
      'videoPaths': jsonEncode(videoPaths),
      'thoiGianTao': thoiGianTao.toIso8601String(),
      'thoiGianCapNhat': thoiGianCapNhat?.toIso8601String(),
    };
  }

  factory GhiChu.fromMap(Map<String, dynamic> map) {
    return GhiChu(
      id: map['id'] ?? '',
      tieuDe: map['tieuDe'] ?? '',
      noiDung: map['noiDung'] ?? '',
      hinhAnhPaths:
          map['hinhAnhPaths'] != null &&
              map['hinhAnhPaths'].toString().isNotEmpty
          ? List<String>.from(jsonDecode(map['hinhAnhPaths']))
          : [],
      videoPaths:
          map['videoPaths'] != null && map['videoPaths'].toString().isNotEmpty
          ? List<String>.from(jsonDecode(map['videoPaths']))
          : [],
      thoiGianTao:
          DateTime.tryParse(map['thoiGianTao'] ?? '') ?? DateTime.now(),
      thoiGianCapNhat: map['thoiGianCapNhat'] != null
          ? DateTime.tryParse(map['thoiGianCapNhat'])
          : null,
    );
  }
}
