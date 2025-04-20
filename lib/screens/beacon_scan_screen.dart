import 'package:flutter/material.dart';
import 'package:flutter_beacon/flutter_beacon.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BeaconScanScreen extends StatefulWidget {
  @override
  _BeaconScanScreenState createState() => _BeaconScanScreenState();
}

class _BeaconScanScreenState extends State<BeaconScanScreen> {
  final _beacons = <Beacon>[];

  @override
  void initState() {
    super.initState();
    _initializeBeacon();
  }

  Future<void> _initializeBeacon() async {
    await flutterBeacon.initializeScanning;

    final regions = <Region>[
      Region(identifier: 'MyRegion', proximityUUID: 'e2c56db5-dffb-48d2-b060-d0f5a71096e0')
    ];

    flutterBeacon.ranging(regions).listen((RangingResult result) {
      setState(() {
        _beacons.clear();
        _beacons.addAll(result.beacons);
      });

      // ✅ Firestore에 저장
      for (final beacon in result.beacons) {
        saveBeaconToFirestore(beacon);
      }
    });
  }

  // ✅ Firestore에 저장하는 함수
  Future<void> saveBeaconToFirestore(Beacon beacon) async {
    try {
      await FirebaseFirestore.instance.collection('beacons').add({
        'uuid': beacon.proximityUUID,
        'major': beacon.major,
        'minor': beacon.minor,
        'rssi': beacon.rssi,
        'timestamp': FieldValue.serverTimestamp(),
      });
      print('✅ Firestore 저장 성공!');
    } catch (e) {
      print('❌ Firestore 저장 실패: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Beacon 스캔')),
      body: ListView.builder(
        itemCount: _beacons.length,
        itemBuilder: (context, index) {
          final beacon = _beacons[index];
          return ListTile(
            title: Text('UUID: ${beacon.proximityUUID}'),
            subtitle: Text('RSSI: ${beacon.rssi}, Major: ${beacon.major}, Minor: ${beacon.minor}'),
          );
        },
      ),
    );
  }
}