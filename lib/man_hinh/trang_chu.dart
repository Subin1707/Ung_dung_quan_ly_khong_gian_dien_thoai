import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:provider/provider.dart';

import '../ngon_ngu/ngon_ngu_quan_ly.dart';
import 'khong_gian_lam_viec.dart';
import 'khong_gian_thu_gian.dart';
import 'khong_gian_ca_nhan.dart';
import 'thong_tin_nhom.dart';

class TrangChu extends StatefulWidget {
  const TrangChu({super.key});

  @override
  State<TrangChu> createState() => _TrangChuState();
}

class _TrangChuState extends State<TrangChu> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.asset("assets/video/nentrangchu.mp4")
      ..initialize().then((_) {
        _controller
          ..setLooping(true)
          ..setVolume(0)
          ..play();
        if (mounted) setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<NgonNguQuanLy>();

    return Scaffold(
      extendBodyBehindAppBar: true,

      // ================= APPBAR =================
      appBar: AppBar(
        title: Text(lang.text("app_title")),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),

      // ================= DRAWER =================
      drawer: Drawer(
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

                _buildDrawerItem(
                  icon: Icons.work,
                  title: lang.text("work"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const KhongGianLamViec(),
                      ),
                    );
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.self_improvement,
                  title: lang.text("relax"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const KhongGianThuGian(),
                      ),
                    );
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.person,
                  title: lang.text("personal"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const KhongGianCaNhan(),
                      ),
                    );
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.info,
                  title: lang.text("team_info"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ThongTinNhom()),
                    );
                  },
                ),

                const Spacer(),

                // ================= LANGUAGE SWITCH =================
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
                      DropdownMenuItem(
                        value: NgonNgu.en,
                        child: Text("English"),
                      ),
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
      ),

      // ================= BODY =================
      body: Stack(
        children: [
          if (_controller.value.isInitialized)
            SizedBox.expand(
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _controller.value.size.width,
                  height: _controller.value.size.height,
                  child: VideoPlayer(_controller),
                ),
              ),
            ),

          Container(color: Colors.black.withOpacity(0.5)),

          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 80),

                Text(
                  lang.text("app_title"),
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 30),

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 18,
                      mainAxisSpacing: 18,
                      children: [
                        _buildCard(
                          context,
                          icon: Icons.work,
                          title: lang.text("work"),
                          color: Colors.blue,
                          screen: const KhongGianLamViec(),
                        ),
                        _buildCard(
                          context,
                          icon: Icons.self_improvement,
                          title: lang.text("relax"),
                          color: Colors.green,
                          screen: const KhongGianThuGian(),
                        ),
                        _buildCard(
                          context,
                          icon: Icons.person,
                          title: lang.text("personal"),
                          color: Colors.orange,
                          screen: const KhongGianCaNhan(),
                        ),
                        _buildCard(
                          context,
                          icon: Icons.info_outline,
                          title: lang.text("team_info"),
                          color: Colors.purple,
                          screen: const ThongTinNhom(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      onTap: onTap,
    );
  }

  Widget _buildCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Color color,
    required Widget screen,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => screen),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: Colors.white.withOpacity(0.9),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 12,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color.withOpacity(0.15),
              ),
              child: Icon(icon, size: 40, color: color),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
