import 'package:flutter/material.dart';
import '../data/room_floor_table.dart'; // ✅ 실제 층수 매핑 파일로 수정

class NavigateResultScreen extends StatefulWidget {
  final String startRoom;
  final String endRoom;
  final List<dynamic> pathSteps;

  const NavigateResultScreen({
    super.key,
    required this.startRoom,
    required this.endRoom,
    required this.pathSteps,
  });

  @override
  State<NavigateResultScreen> createState() => _NavigateResultScreenState();
}

class _NavigateResultScreenState extends State<NavigateResultScreen> {
  late String startRoom;
  late String endRoom;
  late List<dynamic> pathSteps;

  int? startFloor;
  int? endFloor;

  @override
  void initState() {
    super.initState();
    startRoom = widget.startRoom;
    endRoom = widget.endRoom;
    pathSteps = widget.pathSteps;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showManualInputDialog();
    });
  }

  Future<void> _showManualInputDialog() async {
    String tempStart = startRoom;
    String tempEnd = endRoom;

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("출발지와 도착지를 입력하세요"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(labelText: "출발 강의실 (예: 1101)"),
              controller: TextEditingController(text: tempStart),
              onChanged: (v) => tempStart = v.trim(),
            ),
            TextField(
              decoration: const InputDecoration(labelText: "도착 강의실 (예: 3208)"),
              controller: TextEditingController(text: tempEnd),
              onChanged: (v) => tempEnd = v.trim(),
            ),
          ],
        ),
        actions: [
          TextButton(
            child: const Text("확인"),
            onPressed: () async {
              final startCandidate = roomToFloorMap[tempStart];
              final endCandidate = roomToFloorMap[tempEnd];

              if (startCandidate == null || endCandidate == null) {
                Navigator.pop(context);
                await Future.delayed(const Duration(milliseconds: 300));
                _showManualInputDialog();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("❌ 존재하지 않는 강의실입니다. 다시 입력해주세요."),
                  ),
                );
              } else {
                Navigator.pop(context);
                setState(() {
                  startRoom = tempStart;
                  endRoom = tempEnd;
                  pathSteps = [];
                  startFloor = startCandidate;
                  endFloor = endCandidate;
                });
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('경로 안내'), backgroundColor: Colors.white,), // 앱바 배경 흰색
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 12),
              Text(
                '출발: $startRoom → 도착: $endRoom',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildFloorMapView(context),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Divider(height: 24, thickness: 1),
                    Text("📍 출발지: $startRoom (${startFloor ?? "?"}층)"),
                    Text("📍 도착지: $endRoom (${endFloor ?? "?"}층)"),
                    const SizedBox(height: 12),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Icon(Icons.warning, color: Colors.amber, size: 24),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            "해당 층으로 이동하려면 계단 또는 엘리베이터를 이용하세요.",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // 🟡 하단 아이콘 전설
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        /*Column(
                          children: const [
                            Icon(Icons.location_on, color: Colors.blue),
                            SizedBox(height: 4),
                            Text("출발지"),
                          ],
                        ),
                        Column(
                          children: const [
                            Icon(Icons.flag, color: Colors.red),
                            SizedBox(height: 4),
                            Text("도착지"),
                          ],
                        ),*/
                        Column(
                          children: const [
                            Icon(Icons.stairs, color: Colors.pinkAccent),
                            SizedBox(height: 4),
                            Text("계단"),
                          ],
                        ),
                        Column(
                          children: const [
                            Icon(Icons.elevator, color: Colors.orange),
                            SizedBox(height: 4),
                            Text("엘리베이터"),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFloorMapView(BuildContext context) {
    if (startFloor == null || endFloor == null) {
      return const Center(child: Text('출발지 또는 도착지의 층수 정보를 찾을 수 없습니다.'));
    }

    if (startFloor == endFloor) {
      return _buildSingleFloorView(context, startFloor!);
    } else {
      return Column(
        children: [
          const Text('출발 층 도면', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          _buildMapImage(context, floor: startFloor!),
          const SizedBox(height: 16),
          const Text('도착 층 도면', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          _buildMapImage(context, floor: endFloor!),
        ],
      );
    }
  }

  Widget _buildSingleFloorView(BuildContext context, int floor) {
    return Column(
      children: [
        const Text('출발 & 도착 층 도면', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        _buildMapImage(context, floor: floor),
      ],
    );
  }

  Widget _buildMapImage(BuildContext context, {required int floor}) {
    double screenWidth = MediaQuery.of(context).size.width;
    double imageWidth = screenWidth * 0.95;
    double imageHeight = imageWidth * (932 / 2047); // 원본 비율 기준

    final path = 'assets/images/it_building_${floor}f_map.png';

    return SizedBox(
      width: imageWidth,
      height: imageHeight,
      child: Image.asset(
        path,
        width: imageWidth,
        height: imageHeight,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return Center(
            child: Column(
              children: [
                const Icon(Icons.error, color: Colors.red, size: 40),
                const SizedBox(height: 8),
                Text(
                  '도면을 불러올 수 없습니다:\n$path',
                  style: const TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
