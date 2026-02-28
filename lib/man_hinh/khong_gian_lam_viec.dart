import 'package:flutter/material.dart';
import 'dart:async';
import 'package:uuid/uuid.dart';
import 'package:video_player/video_player.dart';
import 'package:provider/provider.dart';

import '../mo_hinh/cong_viec.dart';
import '../database/database_helper.dart';
import '../ngon_ngu/ngon_ngu_quan_ly.dart';
import '../widgets/app_drawer.dart';

class KhongGianLamViec extends StatefulWidget {
  const KhongGianLamViec({super.key});

  @override
  State<KhongGianLamViec> createState() => _KhongGianLamViecState();
}

class _KhongGianLamViecState extends State<KhongGianLamViec> {
  final List<CongViec> danhSach = [];
  final uuid = const Uuid();
  Timer? timer;

  late VideoPlayerController _videoController;

  @override
  void initState() {
    super.initState();
    _loadData();

    _videoController =
        VideoPlayerController.asset("assets/video/nenkhonggianlamviec.mp4")
          ..setLooping(true)
          ..setVolume(0)
          ..initialize().then((_) {
            if (mounted) {
              setState(() {});
              _videoController.play();
            }
          });

    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    _videoController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final data = await DatabaseHelper.instance.getAllCongViec();
    if (!mounted) return;

    setState(() {
      danhSach
        ..clear()
        ..addAll(data);
    });
  }

  // ================= THÊM / SỬA =================
  void _moHopThoai({int? index}) {
    final lang = context.read<NgonNguQuanLy>();

    final controller = TextEditingController(
      text: index != null ? danhSach[index].tieuDe : "",
    );

    DateTime? selectedDate = index != null ? danhSach[index].thoiGianHen : null;

    showDialog(
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Text(
                index == null ? lang.text("add_task") : lang.text("edit_task"),
              ),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    TextField(
                      controller: controller,
                      decoration: InputDecoration(
                        labelText: lang.text("task_name"),
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            selectedDate == null
                                ? lang.text("no_schedule")
                                : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year} "
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
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(lang.text("cancel")),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (controller.text.trim().isEmpty) return;

                    if (index == null) {
                      final cv = CongViec(
                        id: uuid.v4(),
                        tieuDe: controller.text.trim(),
                        thoiGianHen: selectedDate,
                      );

                      await DatabaseHelper.instance.insertCongViec(cv);
                      setState(() => danhSach.add(cv));
                    } else {
                      final cv = danhSach[index];
                      cv.capNhatTieuDe(controller.text.trim());
                      cv.capNhatHenGio(selectedDate);

                      await DatabaseHelper.instance.updateCongViec(cv);
                      setState(() {});
                    }

                    if (mounted) Navigator.pop(context);
                  },
                  child: Text(lang.text("save")),
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
    final id = danhSach[index].id;
    await DatabaseHelper.instance.deleteCongViec(id);

    setState(() {
      danhSach.removeAt(index);
    });
  }

  // ================= TOGGLE =================
  void _toggle(int index) async {
    final cv = danhSach[index];
    cv.toggleHoanThanh();
    await DatabaseHelper.instance.updateCongViec(cv);
    setState(() {});
  }

  // ================= ĐẾM NGƯỢC =================
  String _thoiGianConLai(DateTime thoiGian) {
    final lang = context.watch<NgonNguQuanLy>();
    final diff = thoiGian.difference(DateTime.now());

    if (diff.isNegative) {
      return lang.text("expired");
    }

    final gio = diff.inHours;
    final phut = diff.inMinutes % 60;
    final giay = diff.inSeconds % 60;

    return "$gio ${lang.text("hours")} "
        "$phut ${lang.text("minutes")} "
        "$giay ${lang.text("seconds")}";
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    final lang = context.watch<NgonNguQuanLy>();

    return Scaffold(
      extendBodyBehindAppBar: true,
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: Text(lang.text("work_space")),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: _videoController.value.isInitialized
                ? FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: _videoController.value.size.width,
                      height: _videoController.value.size.height,
                      child: VideoPlayer(_videoController),
                    ),
                  )
                : Container(color: Colors.black),
          ),
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.4)),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 100),
            child: danhSach.isEmpty
                ? Center(
                    child: Text(
                      lang.text("no_task"),
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: danhSach.length,
                    itemBuilder: (context, index) {
                      final congViec = danhSach[index];
                      final hetHan =
                          congViec.thoiGianHen != null &&
                          congViec.thoiGianHen!.isBefore(DateTime.now());

                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: Colors.white.withOpacity(0.9),
                        ),
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
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600,
                                      decoration: congViec.daHoanThanh
                                          ? TextDecoration.lineThrough
                                          : null,
                                    ),
                                  ),
                                  if (congViec.thoiGianHen != null)
                                    Text(
                                      _thoiGianConLai(congViec.thoiGianHen!),
                                      style: TextStyle(
                                        color: hetHan
                                            ? Colors.red
                                            : Colors.green,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () => _moHopThoai(index: index),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF764ba2),
        onPressed: () => _moHopThoai(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
