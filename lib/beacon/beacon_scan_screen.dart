import 'package:flutter/material.dart';
import 'beacon_scanner.dart';

class BeaconScanScreen extends StatefulWidget {
  const BeaconScanScreen({super.key});

  @override
  State<BeaconScanScreen> createState() => _BeaconScanScreenState();
}

class _BeaconScanScreenState extends State<BeaconScanScreen> {
  String result = "아직 스캔되지 않았습니다.";

  final Map<String, Map<String, dynamic>> beaconInfo = {
    'C3:00:00:3F:47:49': {
      'location': '2층 왼쪽 복도',
      'x': 50,
      'y': 120,
    },
    'C3:00:00:3F:47:4B': {
      'location': '2층 중앙 엘리베이터',
      'x': 180,
      'y': 120,
    },
    'C3:00:00:3F:47:3C': {
      'location': '2층 오른쪽 복도',
      'x': 300,
      'y': 120,
    },
  };

  void _scanBeacon() async {
    setState(() {
      result = "📡 스캔 중...";
    });

    final beacon = await BeaconScanner().scanStrongestBeacon();

    if (beacon == null) {
      setState(() {
        result = "❌ 비콘을 찾을 수 없습니다.";
      });
      return;
    }

    final mac = beacon.macAddress.toUpperCase();
    final info = beaconInfo[mac];

    setState(() {
      if (info != null) {
        result =
            "✅ ${info["location"]} (${info["x"]}, ${info["y"]})\nMAC: $mac | RSSI: ${beacon.rssi}";
      } else {
        result = "⚠️ 알 수 없는 비콘: $mac | RSSI: ${beacon.rssi}";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("📍 비콘 스캔 테스트")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: Text(result, textAlign: TextAlign.center)),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _scanBeacon,
            child: const Text("비콘 스캔 시작"),
          ),
        ],
      ),
    );
  }
}
