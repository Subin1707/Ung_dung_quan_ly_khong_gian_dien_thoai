import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../mo_hinh/ghi_chu.dart';

class QuanLyDuLieu {
  static const String _tenFile = "ghi_chu_data.json";

  // ================= LẤY ĐƯỜNG DẪN FILE =================

  Future<File> _layFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File("${directory.path}/$_tenFile");
  }

  // ================= LƯU DANH SÁCH =================

  Future<void> luuDanhSach(List<GhiChu> danhSach) async {
    try {
      final file = await _layFile();

      List<Map<String, dynamic>> jsonList = danhSach
          .map((g) => g.toMap())
          .toList();

      String jsonString = jsonEncode(jsonList);

      await file.writeAsString(jsonString);
    } catch (e) {
      print("Lỗi khi lưu dữ liệu: $e");
    }
  }

  // ================= ĐỌC DANH SÁCH =================

  Future<List<GhiChu>> docDanhSach() async {
    try {
      final file = await _layFile();

      if (!await file.exists()) {
        return [];
      }

      String jsonString = await file.readAsString();

      if (jsonString.isEmpty) return [];

      List<dynamic> jsonList = jsonDecode(jsonString);

      return jsonList.map((e) => GhiChu.fromMap(e)).toList();
    } catch (e) {
      print("Lỗi khi đọc dữ liệu: $e");
      return [];
    }
  }

  // ================= XÓA FILE =================

  Future<void> xoaDuLieu() async {
    final file = await _layFile();
    if (await file.exists()) {
      await file.delete();
    }
  }
}
