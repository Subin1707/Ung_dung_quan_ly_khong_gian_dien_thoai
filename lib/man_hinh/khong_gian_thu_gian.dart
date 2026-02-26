import 'package:flutter/material.dart';

class KhongGianThuGian extends StatefulWidget {
  const KhongGianThuGian({super.key});

  @override
  State<KhongGianThuGian> createState() => _KhongGianThuGianState();
}

class _KhongGianThuGianState extends State<KhongGianThuGian> {
  final List<String> danhSachTrichDan = [
    "Hôm nay là một ngày tuyệt vời để bắt đầu.",
    "Kiên trì sẽ đưa bạn đến thành công.",
    "Đừng so sánh, hãy phát triển.",
    "Tập trung vào mục tiêu của bạn.",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Không gian thư giãn"),
        centerTitle: true,
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Ảnh nền thư giãn (Asset)
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              "assets/hinh_anh/relax.jpg",
              height: 180,
              fit: BoxFit.cover,
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            "Trích dẫn truyền cảm hứng",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 12),

          // Danh sách quote
          ...danhSachTrichDan.map((quote) {
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(Icons.format_quote, size: 28),

                    const SizedBox(width: 10),

                    Expanded(
                      child: Text(quote, style: const TextStyle(fontSize: 16)),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
