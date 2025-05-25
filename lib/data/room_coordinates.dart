// lib/data/room_coordinates.dart
// 기준 도면 크기: width = 1000, height = 700

class RoomInfo {
  final double left;
  final double top;
  final int floor;

  const RoomInfo({
    required this.left,
    required this.top,
    required this.floor,
  });
}

/// 강의실 이름 → 좌표 및 층수 매핑
final Map<String, RoomInfo> roomCoordinates = {
  '10210': RoomInfo(left: 530.0, top: 280.0, floor: 10),
  '10221': RoomInfo(left: 1110.0, top: 280.0, floor: 10),
  '10225': RoomInfo(left: 1315.0, top: 280.0, floor: 10),
  '1103': RoomInfo(left: 510.0, top: 359.0, floor: 1),
  '1122': RoomInfo(left: 1709.0, top: 414.0, floor: 1),
  '1125': RoomInfo(left: 1933.0, top: 414.0, floor: 1),
  '2104-2': RoomInfo(left: 160.0, top: 600.0, floor: 2),
  '2105-2': RoomInfo(left: 415.0, top: 600.0, floor: 2),
  '2115-1': RoomInfo(left: 418.0, top: 425.0, floor: 2),
  '2119': RoomInfo(left: 1030.0, top: 285.0, floor: 2),
  '2122': RoomInfo(left: 1183.0, top: 285.0, floor: 2),
  '2210': RoomInfo(left: 530.0, top: 105.0, floor: 2),
  '2225': RoomInfo(left: 1060.0, top: 105.0, floor: 2),
  '2228': RoomInfo(left: 1260.0, top: 105.0, floor: 2),
  '3108': RoomInfo(left: 381.0, top: 500.0, floor: 3),
  '3208': RoomInfo(left: 415.0, top: 110.0, floor: 3),
  '3210': RoomInfo(left: 678.0, top: 110.0, floor: 3),
  '3224': RoomInfo(left: 1265.0, top: 105.0, floor: 3),
  '3228': RoomInfo(left: 1460.0, top: 105.0, floor: 3),
  '4218': RoomInfo(left: 500.0, top: 300.0, floor: 4),
  '4225': RoomInfo(left: 800.0, top: 300.0, floor: 4),
  '6210': RoomInfo(left: 400.0, top: 200.0, floor: 6),
  '6221': RoomInfo(left: 550.0, top: 200.0, floor: 6),
  '6225': RoomInfo(left: 700.0, top: 200.0, floor: 6),
  '7210': RoomInfo(left: 400.0, top: 180.0, floor: 7),
  '7221': RoomInfo(left: 560.0, top: 180.0, floor: 7),
  '7225': RoomInfo(left: 720.0, top: 180.0, floor: 7),
  '8206': RoomInfo(left: 300.0, top: 160.0, floor: 8),
  '8210': RoomInfo(left: 480.0, top: 160.0, floor: 8),
  '8221': RoomInfo(left: 660.0, top: 160.0, floor: 8),
  '9206': RoomInfo(left: 300.0, top: 140.0, floor: 9),
  '9210': RoomInfo(left: 480.0, top: 140.0, floor: 9),
  '9221': RoomInfo(left: 660.0, top: 140.0, floor: 9),
  '9225': RoomInfo(left: 820.0, top: 140.0, floor: 9),
};
