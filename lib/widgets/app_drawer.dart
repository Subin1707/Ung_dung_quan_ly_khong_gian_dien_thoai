import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../ngon_ngu/ngon_ngu_quan_ly.dart';
import '../man_hinh/trang_chu.dart';
import '../man_hinh/khong_gian_lam_viec.dart';
import '../man_hinh/khong_gian_thu_gian.dart';
import '../man_hinh/khong_gian_ca_nhan.dart';
import '../man_hinh/thong_tin_nhom.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<NgonNguQuanLy>();

    return Drawer(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF667eea), Color(0xFF764ba2)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 20),
              const CircleAvatar(
                radius: 40,
                backgroundColor: Colors.white,
                child: Icon(Icons.apps, size: 40, color: Colors.deepPurple),
              ),
              const SizedBox(height: 15),

              Text(
                lang.text("drawer_title"),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const Divider(color: Colors.white54, height: 40),

              _item(
                context,
                icon: Icons.home,
                title: lang.text("home"),
                page: const TrangChu(),
              ),
              _item(
                context,
                icon: Icons.work,
                title: lang.text("work"),
                page: const KhongGianLamViec(),
              ),
              _item(
                context,
                icon: Icons.self_improvement,
                title: lang.text("relax"),
                page: const KhongGianThuGian(),
              ),
              _item(
                context,
                icon: Icons.person,
                title: lang.text("personal"),
                page: const KhongGianCaNhan(),
              ),
              _item(
                context,
                icon: Icons.info,
                title: lang.text("team_info"),
                page: const ThongTinNhom(),
              ),

              const Spacer(),

              Padding(
                padding: const EdgeInsets.all(16),
                child: DropdownButton<NgonNgu>(
                  value: lang.current,
                  dropdownColor: Colors.deepPurple,
                  style: const TextStyle(color: Colors.white),
                  iconEnabledColor: Colors.white,
                  underline: const SizedBox(),
                  items: const [
                    DropdownMenuItem(
                      value: NgonNgu.vi,
                      child: Text("Tiếng Việt"),
                    ),
                    DropdownMenuItem(value: NgonNgu.en, child: Text("English")),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      lang.doiNgonNgu(value);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _item(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Widget page,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      onTap: () {
        Navigator.pop(context);

        if (ModalRoute.of(context)?.settings.name !=
            page.runtimeType.toString()) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => page,
              settings: RouteSettings(name: page.runtimeType.toString()),
            ),
          );
        }
      },
    );
  }
}
