// lib/data/beacon_data_loader.dart
import 'dart:convert';
import 'package:flutter/services.dart';

class BeaconPosition {
  final String mac;
  final int minor;
  final int floor;
  final String location;
  final double x;
  final double y;

  BeaconPosition({
    required this.mac,
    required this.minor,
    required this.floor,
    required this.location,
    required this.x,
    required this.y,
  });

  factory BeaconPosition.fromJson(Map<String, dynamic> json) {
    return BeaconPosition(
      mac: json['mac'],
      minor: json['minor'],
      floor: json['floor'],
      location: json['location'],
      x: json['position']['x'].toDouble(),
      y: json['position']['y'].toDouble(),
    );
  }
}

Future<List<BeaconPosition>> loadBeaconPositions() async {
  final String jsonString = await rootBundle.loadString('assets/data/beacon_mac_table.json');
  final List<dynamic> jsonList = json.decode(jsonString);
  return jsonList.map((e) => BeaconPosition.fromJson(e)).toList();
}
