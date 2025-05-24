import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

// ✅ 도면 위에 경로 안내 표시할 화면
import 'it_building_navigation_screen.dart';

class QrNavigateScreen extends StatefulWidget {
  const QrNavigateScreen({super.key});

  @override
  State<QrNavigateScreen> createState() => _QrNavigateScreenState();
}

class _QrNavigateScreenState extends State<QrNavigateScreen> {
  String? currentRoom;
  bool scannerUsed = false;

  /// ✅ 출발 강의실 수동 입력
  void _showStartRoomInput() async {
    String? start = await showDialog<String>(
      context: context,
      builder: (context) {
        String input = '';
        return AlertDialog(
          title: const Text("출발 강의실 입력"),
          content: TextField(
            autofocus: true,
            onChanged: (value) => input = value,
            decoration: const InputDecoration(hintText: "예: 1125"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(input),
              child: const Text("다음"),
            )
          ],
        );
      },
    );

    if (start != null && start.isNotEmpty) {
      setState(() {
        currentRoom = start;
      });
      _showDestinationInput();
    }
  }

  /// ✅ 도착 강의실 입력 후 경로 안내 화면으로 이동
  void _showDestinationInput() async {
    String? destination = await showDialog<String>(
      context: context,
      builder: (context) {
        String input = '';
        return AlertDialog(
          title: const Text("도착 강의실 입력"),
          content: TextField(
            autofocus: true,
            onChanged: (value) => input = value,
            decoration: const InputDecoration(hintText: "예: 4218"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(input),
              child: const Text("경로 안내"),
            )
          ],
        );
      },
    );

    if (destination != null && destination.isNotEmpty && currentRoom != null) {
      debugPrint("출발: $currentRoom → 도착: $destination");

      // ✅ 실제 경로 안내 화면으로 이동
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ItBuildingNavigationScreen(
            startRoom: currentRoom!,
            endRoom: destination,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("QR로 출발 강의실 인식"),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_location_alt),
            tooltip: '직접 입력',
            onPressed: () {
              if (!scannerUsed) _showStartRoomInput();
            },
          ),
        ],
      ),
      body: MobileScanner(
        onDetect: (capture) {
          if (scannerUsed) return;

          final barcode = capture.barcodes.first;
          final value = barcode.rawValue;

          if (value != null && value.startsWith("room_")) {
            setState(() {
              scannerUsed = true;
              currentRoom = value.replaceFirst("room_", "");
            });
            debugPrint("QR 인식된 현재 강의실: $currentRoom");
            _showDestinationInput();
          }
        },
      ),
    );
  }
}
