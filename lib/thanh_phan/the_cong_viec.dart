import 'package:flutter/material.dart';
import '../mo_hinh/cong_viec.dart';
import '../tien_ich/dinh_dang_thoi_gian.dart';

class TheCongViec extends StatelessWidget {
  final CongViec congViec;
  final VoidCallback? onToggle;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;

  const TheCongViec({
    super.key,
    required this.congViec,
    this.onToggle,
    this.onDelete,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final bool quaHan =
        congViec.thoiGianHen != null &&
        DinhDangThoiGian.daQuaHan(congViec.thoiGianHen) &&
        !congViec.daHoanThanh;

    return Dismissible(
      key: ValueKey(congViec.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDelete?.call(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: quaHan
              ? Colors.red.withOpacity(0.05)
              : congViec.daHoanThanh
              ? Colors.green.withOpacity(0.05)
              : Colors.white,
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Checkbox(
              value: congViec.daHoanThanh,
              onChanged: (_) => onToggle?.call(),
            ),

            Expanded(
              child: InkWell(
                onTap: onEdit,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      congViec.tieuDe,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        decoration: congViec.daHoanThanh
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      "Tạo: ${DinhDangThoiGian.dinhDangThongMinh(congViec.thoiGianTao)}",
                      style: const TextStyle(fontSize: 12),
                    ),

                    if (congViec.thoiGianHen != null)
                      Text(
                        "Hẹn: ${DinhDangThoiGian.dinhDangNgayGio(congViec.thoiGianHen!)}",
                        style: TextStyle(
                          fontSize: 12,
                          color: quaHan ? Colors.red : Colors.grey[700],
                          fontWeight: quaHan
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                  ],
                ),
              ),
            ),

            IconButton(icon: const Icon(Icons.more_vert), onPressed: onEdit),
          ],
        ),
      ),
    );
  }
}
