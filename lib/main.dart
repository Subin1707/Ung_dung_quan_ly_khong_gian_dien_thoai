import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'giao_dien/chu_de_ung_dung.dart';
import 'man_hinh/trang_chu.dart';
import 'ngon_ngu/ngon_ngu_quan_ly.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => NgonNguQuanLy(),
      child: const UngDungKhongGian(),
    ),
  );
}

class UngDungKhongGian extends StatelessWidget {
  const UngDungKhongGian({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<NgonNguQuanLy>();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: lang.text("app_title"),

      theme: ChuDeUngDung.sang,
      darkTheme: ChuDeUngDung.toi,
      themeMode: ThemeMode.system,

      // ================= NGÔN NGỮ =================
      locale: lang.locale,

      supportedLocales: const [Locale('vi'), Locale('en')],

      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      home: const TrangChu(),
    );
  }
}
