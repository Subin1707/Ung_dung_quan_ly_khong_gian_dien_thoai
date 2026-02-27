import 'tieng_viet.dart';
import 'tieng_anh.dart';

enum NgonNgu { vi, en }

class NgonNguQuanLy {
  static NgonNgu current = NgonNgu.vi;

  static void doiNgonNgu(NgonNgu ngonNgu) {
    current = ngonNgu;
  }

  static String text(String key) {
    switch (current) {
      case NgonNgu.en:
        return TiengAnh.data[key] ?? key;
      case NgonNgu.vi:
      default:
        return TiengViet.data[key] ?? key;
    }
  }
}
