import 'package:flutter/material.dart';
import 'tieng_viet.dart';
import 'tieng_anh.dart';

enum NgonNgu { vi, en }

class NgonNguQuanLy extends ChangeNotifier {
  NgonNgu _current = NgonNgu.vi;

  NgonNgu get current => _current;

  /// 🔥 THÊM CÁI NÀY
  Locale get locale {
    switch (_current) {
      case NgonNgu.en:
        return const Locale('en');
      case NgonNgu.vi:
      default:
        return const Locale('vi');
    }
  }

  void doiNgonNgu(NgonNgu ngonNgu) {
    _current = ngonNgu;
    notifyListeners();
  }

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
