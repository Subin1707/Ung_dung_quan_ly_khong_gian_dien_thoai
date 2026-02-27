import 'package:flutter/material.dart';
import 'dart:async';
import 'package:uuid/uuid.dart';
import '../mo_hinh/cong_viec.dart';
import '../database/database_helper.dart';

class KhongGianLamViec extends StatefulWidget {
  const KhongGianLamViec({super.key});

  @override
  State<KhongGianLamViec> createState() => _KhongGianLamViecState();
}

class _KhongGianLamViecState extends State<KhongGianLamViec> {
  final List<CongViec> danhSach = [];
  final uuid = const Uuid();
  Timer? timer;

  @override
  void initState() {
    super.initState();
    _loadData();

    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  Future<void> _loadData() async {
    final data = await DatabaseHelper.instance.getAllCongViec();
    setState(() {
      danhSach.clear();
      danhSach.addAll(data);
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
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
                  onPressed: () async {
                    if (controller.text.isEmpty) return;

                    if (index == null) {
                      final cv = CongViec(
                        id: uuid.v4(),
                        tieuDe: controller.text,
                        thoiGianHen: selectedDate,
                      );

                      await DatabaseHelper.instance.insertCongViec(cv);
                    } else {
                      final cv = danhSach[index];
                      cv.capNhatTieuDe(controller.text);
                      cv.capNhatHenGio(selectedDate);

                      await DatabaseHelper.instance.updateCongViec(cv);
                    }

                    Navigator.pop(context);
                    _loadData();
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

  // ================= XÓA =================
  void _xoa(int index) async {
    await DatabaseHelper.instance.deleteCongViec(danhSach[index].id);

    _loadData();
  }

  // ================= TOGGLE =================
  void _toggle(int index) async {
    final cv = danhSach[index];
    cv.toggleHoanThanh();

    await DatabaseHelper.instance.updateCongViec(cv);
    _loadData();
  }

  // ================= ĐẾM NGƯỢC =================
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
