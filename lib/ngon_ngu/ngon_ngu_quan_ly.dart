import 'package:flutter/material.dart';
import 'tieng_viet.dart';
import 'tieng_anh.dart';

enum NgonNgu { vi, en }

class NgonNguQuanLy extends ChangeNotifier {
  NgonNgu _current = NgonNgu.vi;

  NgonNgu get current => _current;

  /// Locale dùng cho MaterialApp
  Locale get locale {
    switch (_current) {
      case NgonNgu.en:
        return const Locale('en');
      case NgonNgu.vi:
      default:
        return const Locale('vi');
    }
  }

  /// ĐỔI NGÔN NGỮ (DÙNG ENUM – KHÔNG DÙNG STRING)
  void doiNgonNgu(NgonNgu ngonNgu) {
    _current = ngonNgu;
    notifyListeners();
  }

  /// LẤY TEXT THEO KEY
  String text(String key) {
    switch (_current) {
      case NgonNgu.en:
        return TiengAnh.data[key] ?? key;
      case NgonNgu.vi:
      default:
        return TiengViet.data[key] ?? key;
    }
  }
}
