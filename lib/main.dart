// BLE + GPS 기반 실내 위치 추적 (3초 반복 측정 + 정확도 향상)

import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';

void main() => runApp(const BeaconApp());

// 앱 시작 지점: 전체 앱 위젯 구조 정의
class BeaconApp extends StatelessWidget {
  const BeaconApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: BeaconTrackerScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// 위치 추적 기능이 포함된 Stateful 위젯
class BeaconTrackerScreen extends StatefulWidget {
  const BeaconTrackerScreen({super.key});

  @override
  State<BeaconTrackerScreen> createState() => _BeaconTrackerScreenState();
}

class _BeaconTrackerScreenState extends State<BeaconTrackerScreen> {
  // 도면 이미지의 크기 (픽셀 기준)
  final double imageWidth = 349;
  final double imageHeight = 227;

  // 비콘 MAC 주소와 도면 내 위치 매핑
  final Map<String, Offset> knownBeacons = {
    "C3:00:00:3F:47:49": Offset(60, 200),
    "C3:00:00:3F:47:4B": Offset(170, 20),
    "C3:00:00:3F:47:3C": Offset(320, 200),
  };

  // 비콘 MAC 주소 → 층수 매핑
  final Map<String, int> beaconToFloor = {
    "C3:00:00:3F:47:49": 1,
    "C3:00:00:3F:47:4B": 2,
    "C3:00:00:3F:47:3C": 3,
  };

  // RSSI 측정값 저장 버퍼
  Map<String, List<int>> rssiBuffer = {};
  int rssiWindowSize = 5; // (사용 안 하지만 확장 대비)

  Offset? userPosition; // 사용자 추정 위치 (도면 내 좌표)
  int? currentFloor;    // 추정된 층수
  Position? gpsPosition; // GPS 기반 실제 위치

  @override
  void initState() {
    super.initState();
    requestPermissions(); // 앱 시작 시 권한 요청
  }

  // 위치 및 BLE 관련 권한 요청
  Future<void> requestPermissions() async {
    await Permission.location.request();
    await Permission.bluetoothScan.request();
    await Permission.bluetoothConnect.request();
  }

  // GPS 현재 위치 요청 함수
  Future<Position> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('GPS 서비스가 꺼져 있습니다.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('위치 권한이 거부되었습니다.');
      }
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  // 위치 계산 시작 함수 (3초 동안 비콘 스캔 → 위치 추정)
  Future<void> startScanAndLocate() async {
    setState(() {
      userPosition = null;
      rssiBuffer.clear();
    });

    gpsPosition = await getCurrentLocation();

    const int scanDuration = 3; // 반복 측정 시간 (초)
    final stopwatch = Stopwatch()..start();

    FlutterBluePlus.startScan(timeout: Duration(seconds: scanDuration));

    // 0.5초 간격으로 scanResults 수집
    while (stopwatch.elapsed.inSeconds < scanDuration) {
      final results = await FlutterBluePlus.scanResults.first;
      for (final r in results) {
        final mac = r.device.id.id.toUpperCase();
        if (knownBeacons.containsKey(mac)) {
          rssiBuffer.putIfAbsent(mac, () => []);
          rssiBuffer[mac]!.add(r.rssi);
        }
      }
      await Future.delayed(const Duration(milliseconds: 500));
    }

    FlutterBluePlus.stopScan();

    // 각 비콘의 평균 RSSI → 거리 추정
    Map<String, double> averagedDistances = {};
    for (var entry in rssiBuffer.entries) {
      final mac = entry.key;
      final rssiList = entry.value;
      if (rssiList.isNotEmpty) {
        final avgRssi = rssiList.reduce((a, b) => a + b) ~/ rssiList.length;
        averagedDistances[mac] = calculateDistance(avgRssi);
      }
    }

    // 가장 가까운 비콘 → 현재 층 추정
    if (averagedDistances.isNotEmpty) {
      final strongest = averagedDistances.entries.reduce((a, b) => a.value < b.value ? a : b);
      currentFloor = beaconToFloor[strongest.key];
    }

    // 두 개 이상 비콘 있을 경우 → 위치 가중 평균 계산
    if (averagedDistances.length >= 2) {
      double sumWeight = 0;
      double weightedX = 0;
      double weightedY = 0;

      for (final entry in averagedDistances.entries) {
        final pos = knownBeacons[entry.key]!;
        final d = entry.value;
        final weight = 1 / (d + 0.01); // 거리 가까울수록 가중치 ↑
        weightedX += pos.dx * weight;
        weightedY += pos.dy * weight;
        sumWeight += weight;
      }

      if (sumWeight > 0) {
        final avgX = weightedX / sumWeight;
        final avgY = weightedY / sumWeight;

        // 도면 밖 좌표는 무시
        if (avgX >= 0 && avgX <= imageWidth && avgY >= 0 && avgY <= imageHeight) {
          setState(() {
            userPosition = Offset(avgX, avgY);
          });
        }
      }
    }
  }

  // RSSI → 거리 계산 함수 (기본 공식)
  double calculateDistance(int rssi) {
    const txPower = -59;
    const n = 2.0;
    return pow(10, (txPower - rssi) / (10 * n)).toDouble();
  }

  // UI 구성 함수
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('BLE 위치 추적 (3초 평균)')),
      body: Column(
        children: [
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: startScanAndLocate,
            child: const Text("내 위치 찾기"),
          ),
          if (gpsPosition != null)
            Text("📍 GPS 위도: ${gpsPosition!.latitude}, 경도: ${gpsPosition!.longitude}"),
          if (currentFloor != null)
            Text("🏢 예측된 층수: ${currentFloor!}층"),
          const SizedBox(height: 10),
          Center(
            child: SizedBox(
              width: imageWidth,
              height: imageHeight,
              child: Stack(
                children: [
                  Image.asset("assets/flower.png", fit: BoxFit.cover), // 도면 이미지 표시
                  // 비콘 위치 표시
                  ...knownBeacons.entries.map((e) => Positioned(
                        left: e.value.dx - 12,
                        top: e.value.dy - 24,
                        child: const Icon(Icons.location_on, color: Colors.red, size: 24),
                      )),
                  // 사용자 위치 표시 (파란 점)
                  if (userPosition != null)
                    Positioned(
                      left: userPosition!.dx - 8,
                      top: userPosition!.dy - 8,
                      child: const Icon(Icons.circle, color: Colors.blue, size: 16),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
