import 'package:flutter/material.dart';
import 'dart:async';
import '../mo_hinh/cong_viec.dart';

class KhongGianLamViec extends StatefulWidget {
  const KhongGianLamViec({super.key});

  @override
  State<KhongGianLamViec> createState() => _KhongGianLamViecState();
}

class _KhongGianLamViecState extends State<KhongGianLamViec> {
  final List<CongViec> danhSach = [];
  Timer? timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  // ================= ID TỰ SINH =================
  String _taoId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  // ================= THÊM / SỬA =================
  void _moHopThoai({int? index}) {
    TextEditingController controller = TextEditingController(
      text: index != null ? danhSach[index].tieuDe : "",
    );

    DateTime? selectedDate = index != null ? danhSach[index].thoiGianHen : null;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              scrollable: true,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Text(index == null ? "Thêm công việc" : "Sửa công việc"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      labelText: "Tên công việc",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          selectedDate == null
                              ? "Chưa hẹn giờ"
                              : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year} - "
                                    "${selectedDate!.hour.toString().padLeft(2, '0')}:"
                                    "${selectedDate!.minute.toString().padLeft(2, '0')}",
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.access_time),
                        onPressed: () async {
                          DateTime? date = await showDatePicker(
                            context: context,
                            initialDate: selectedDate ?? DateTime.now(),
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2100),
                          );

                          if (date != null) {
                            TimeOfDay? time = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );

                            if (time != null) {
                              setStateDialog(() {
                                selectedDate = DateTime(
                                  date.year,
                                  date.month,
                                  date.day,
                                  time.hour,
                                  time.minute,
                                );
                              });
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Hủy"),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (controller.text.isEmpty) return;

                    setState(() {
                      if (index == null) {
                        danhSach.add(
                          CongViec(
                            id: _taoId(),
                            tieuDe: controller.text,
                            thoiGianHen: selectedDate,
                          ),
                        );
                      } else {
                        danhSach[index].capNhatTieuDe(controller.text);
                        danhSach[index].capNhatHenGio(selectedDate);
                      }
                    });

                    Navigator.pop(context);
                  },
                  child: const Text("Lưu"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // ================= XỬ LÝ =================
  void _xoa(int index) {
    setState(() {
      danhSach.removeAt(index);
    });
  }

  void _toggle(int index) {
    setState(() {
      danhSach[index].toggleHoanThanh();
    });
  }

  String _thoiGianConLai(DateTime thoiGian) {
    Duration diff = thoiGian.difference(DateTime.now());

    if (diff.isNegative) {
      return "Đã hết hạn";
    }

    int gio = diff.inHours;
    int phut = diff.inMinutes % 60;
    int giay = diff.inSeconds % 60;

    return "$gio giờ $phut phút $giay giây";
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Không gian làm việc"),
        centerTitle: true,
      ),
      body: danhSach.isEmpty
          ? const Center(child: Text("Chưa có công việc"))
          : ListView.builder(
              itemCount: danhSach.length,
              itemBuilder: (context, index) {
                final congViec = danhSach[index];

                bool hetHan =
                    congViec.thoiGianHen != null &&
                    congViec.thoiGianHen!.isBefore(DateTime.now());

                return Card(
                  margin: const EdgeInsets.all(12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 6,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Checkbox(
                          value: congViec.daHoanThanh,
                          onChanged: (_) => _toggle(index),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                congViec.tieuDe,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  decoration: congViec.daHoanThanh
                                      ? TextDecoration.lineThrough
                                      : null,
                                ),
                              ),
                              const SizedBox(height: 6),
                              if (congViec.thoiGianHen != null)
                                Text(
                                  _thoiGianConLai(congViec.thoiGianHen!),
                                  style: TextStyle(
                                    color: hetHan ? Colors.red : Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () => _moHopThoai(index: index),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _xoa(index),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _moHopThoai(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
