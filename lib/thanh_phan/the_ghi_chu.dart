import 'dart:io';
import 'package:flutter/material.dart';
import '../mo_hinh/ghi_chu.dart';
import '../tien_ich/dinh_dang_thoi_gian.dart';

class TheGhiChu extends StatelessWidget {
  final GhiChu ghiChu;
  final VoidCallback? onDelete;
  final VoidCallback? onTap;

  const TheGhiChu({
    super.key,
    required this.ghiChu,
    this.onDelete,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool daChinhSua = ghiChu.thoiGianCapNhat != null;

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: Colors.yellow[100],
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ================= TIÊU ĐỀ =================
            Row(
              children: [
                Expanded(
                  child: Text(
                    ghiChu.tieuDe,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                _buildLoaiIcon(),
              ],
            ),

            const SizedBox(height: 8),

            // ================= NỘI DUNG =================
            Text(
              ghiChu.noiDung,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 14),
            ),

            const SizedBox(height: 10),

            // ================= HÌNH ẢNH =================
            if (ghiChu.coAnh)
              SizedBox(
                height: 70,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: ghiChu.hinhAnhPaths.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.only(right: 8),
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                          image: FileImage(
                            File(ghiChu.hinhAnhPaths[index]),
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),
              ),

            if (ghiChu.coAnh) const SizedBox(height: 8),

            // ================= VIDEO =================
            if (ghiChu.coVideo)
              Row(
                children: [
                  const Icon(Icons.videocam, size: 18),
                  const SizedBox(width: 6),
                  Text("${ghiChu.videoPaths.length} video"),
                ],
              ),

            const SizedBox(height: 10),

            // ================= FOOTER =================
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DinhDangThoiGian.dinhDangNgay(ghiChu.thoiGianTao),
                      style: const TextStyle(fontSize: 12),
                    ),
                    if (daChinhSua)
                      const Text(
                        "Đã chỉnh sửa",
                        style: TextStyle(
                          fontSize: 11,
                          fontStyle: FontStyle.italic,
                          color: Colors.grey,
                        ),
                      ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: onDelete,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ================= ICON LOẠI =================

  Widget _buildLoaiIcon() {
    switch (ghiChu.loaiNoiDung) {
      case LoaiNoiDung.image:
        return const Icon(Icons.image, size: 18);
      case LoaiNoiDung.video:
        return const Icon(Icons.videocam, size: 18);
      case LoaiNoiDung.mix:
        return const Icon(Icons.collections, size: 18);
      default:
        return const Icon(Icons.notes, size: 18);
    }
  }
}