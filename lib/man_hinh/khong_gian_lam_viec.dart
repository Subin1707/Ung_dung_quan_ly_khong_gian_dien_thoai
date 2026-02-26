import 'package:flutter/material.dart';
import 'dart:async';
import '../mo_hinh/cong_viec.dart';

class KhongGianLamViec extends StatefulWidget {
  const KhongGianLamViec({super.key});

  @override
  State<KhongGianLamViec> createState() => _KhongGianLamViecState();
}

class _KhongGianLamViecState extends State<KhongGianLamViec> {
  List<CongViec> danhSach = [];
  Timer? timer;

  @override
  void initState() {
    super.initState();

    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      setState(() {});
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

    DateTime? selectedDate = index != null ? danhSach[index].thoiGian : null;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
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
                              : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year} - ${selectedDate!.hour}:${selectedDate!.minute.toString().padLeft(2, '0')}",
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.access_time),
                        onPressed: () async {
                          DateTime? date = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
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
                            tieuDe: controller.text,
                            daHoanThanh: false,
                            thoiGian: selectedDate,
                          ),
                        );
                      } else {
                        danhSach[index].tieuDe = controller.text;
                        danhSach[index].thoiGian = selectedDate;
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

  void _xoa(int index) {
    setState(() {
      danhSach.removeAt(index);
    });
  }

  void _toggle(int index) {
    setState(() {
      danhSach[index].daHoanThanh = !danhSach[index].daHoanThanh;
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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE3F2FD), Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            // ===== HEADER =====
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 10),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Tổng công việc",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "${danhSach.length}",
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),

            // ===== DANH SÁCH =====
            Expanded(
              child: danhSach.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.work_outline,
                            size: 60,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Chưa có công việc",
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: danhSach.length,
                      itemBuilder: (context, index) {
                        final congViec = danhSach[index];

                        bool hetHan = false;
                        if (congViec.thoiGian != null) {
                          hetHan = congViec.thoiGian!.isBefore(DateTime.now());
                        }

                        return Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: const [
                              BoxShadow(color: Colors.black12, blurRadius: 8),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                Checkbox(
                                  value: congViec.daHoanThanh,
                                  activeColor: Colors.blue,
                                  onChanged: (_) => _toggle(index),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                      if (congViec.thoiGian != null)
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.access_time,
                                              size: 16,
                                              color: hetHan
                                                  ? Colors.red
                                                  : Colors.green,
                                            ),
                                            const SizedBox(width: 5),
                                            Text(
                                              _thoiGianConLai(
                                                congViec.thoiGian!,
                                              ),
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: hetHan
                                                    ? Colors.red
                                                    : Colors.green,
                                              ),
                                            ),
                                          ],
                                        ),
                                    ],
                                  ),
                                ),
                                Column(
                                  children: [
                                    IconButton(
                                      icon: const Icon(
                                        Icons.edit,
                                        color: Colors.blue,
                                      ),
                                      onPressed: () =>
                                          _moHopThoai(index: index),
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
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
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () => _moHopThoai(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
