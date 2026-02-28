class DinhDangThoiGian {
  static String dinhDangNgay(DateTime dateTime) {
    return "${_haiChuSo(dateTime.day)}/"
        "${_haiChuSo(dateTime.month)}/"
        "${dateTime.year}";
  }

  static String dinhDangNgayGio(DateTime dateTime) {
    return "${_haiChuSo(dateTime.hour)}:"
        "${_haiChuSo(dateTime.minute)} "
        "${_haiChuSo(dateTime.day)}/"
        "${_haiChuSo(dateTime.month)}/"
        "${dateTime.year}";
  }

  static String dinhDangNgan(DateTime dateTime) {
    return "${_haiChuSo(dateTime.day)}/"
        "${_haiChuSo(dateTime.month)}";
  }

  static String dinhDangThongMinh(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final inputDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

    final difference = inputDate.difference(today).inDays;

    if (difference == 0) {
      return "Hôm nay";
    } else if (difference == -1) {
      return "Hôm qua";
    } else {
      return dinhDangNgay(dateTime);
    }
  }

  static bool daQuaHan(DateTime? dateTime) {
    if (dateTime == null) return false;
    return dateTime.isBefore(DateTime.now());
  }

  static String _haiChuSo(int so) {
    return so.toString().padLeft(2, '0');
  }
}
