import 'package:flutter/material.dart';
import '../mo_hinh/ghi_chu.dart';
import '../tien_ich/dinh_dang_thoi_gian.dart';

class TheGhiChu extends StatelessWidget {
  final GhiChu ghiChu;
  final VoidCallback? onDelete;

  const TheGhiChu({
    super.key,
    required this.ghiChu,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.yellow[100],
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            ghiChu.tieuDe,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),

          Text(
            ghiChu.noiDung,
            style: const TextStyle(fontSize: 14),
          ),

          const SizedBox(height: 8),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                DinhDangThoiGian.dinhDangNgay(ghiChu.thoiGianTao),
                style: const TextStyle(fontSize: 12),
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: onDelete,
              ),
            ],
          ),
        ],
      ),
    );
  }
}