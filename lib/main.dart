import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'giao_dien/chu_de_ung_dung.dart';
import 'man_hinh/trang_chu.dart';

void main() {
  runApp(const UngDungKhongGian());
}

class UngDungKhongGian extends StatefulWidget {
  const UngDungKhongGian({super.key});

  @override
  State<UngDungKhongGian> createState() => _UngDungKhongGianState();
}

class _UngDungKhongGianState extends State<UngDungKhongGian> {
  Locale _locale = const Locale('vi');

  void doiNgonNgu(String ma) {
    setState(() {
      _locale = Locale(ma);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Không Gian Điện Thoại",
      theme: ChuDeUngDung.sang,
      darkTheme: ChuDeUngDung.toi,
      themeMode: ThemeMode.system,

      locale: _locale,
      supportedLocales: const [
        Locale('vi'),
        Locale('en'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      home: TrangChu(onChangeLanguage: doiNgonNgu),
    );
  }
}