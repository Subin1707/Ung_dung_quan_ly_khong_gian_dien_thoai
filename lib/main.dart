import 'package:flutter/material.dart';
import 'giao_dien/chu_de_ung_dung.dart';
import 'man_hinh/trang_chu.dart';

void main() {
  runApp(UngDungKhongGian());
}

class UngDungKhongGian extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Không Gian Điện Thoại",
      theme: ChuDeUngDung.sang,
      darkTheme: ChuDeUngDung.toi,
      themeMode: ThemeMode.system,
      home: TrangChu(),
    );
  }
}
