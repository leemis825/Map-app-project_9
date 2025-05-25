// 전체 층 강의실 좌표 정의 (출발/도착 분리)

class RoomPosition {
  final double left;
  final double top;

  const RoomPosition({required this.left, required this.top});
}

// === 1F 출발 위치 좌표 ===
const Map<String, RoomPosition> startRoomPositions1F = {
  '1101': RoomPosition(left: 240, top: 420),
  '1103': RoomPosition(left: 370, top: 420),
  '1006-1': RoomPosition(left: 120, top: 700),
  '1006-6': RoomPosition(left: 220, top: 600),
  '1204': RoomPosition(left: 200, top: 100),
  '1209': RoomPosition(left: 360, top: 100),
  '1210': RoomPosition(left: 540, top: 100),
  '1213': RoomPosition(left: 700, top: 100),
  'e.space': RoomPosition(left: 960, top: 100),
  'l.space': RoomPosition(left: 960, top: 420),
  '1225': RoomPosition(left: 1300, top: 100),
  '1228': RoomPosition(left: 1450, top: 100),
  '1122': RoomPosition(left: 1120, top: 420),
  '1125': RoomPosition(left: 1270, top: 420),
  '1128': RoomPosition(left: 1420, top: 420),
};

// === 1F 도착 위치 좌표 ===
const Map<String, RoomPosition> endRoomPositions1F = {
  '1101': RoomPosition(left: 260, top: 440),
  '1103': RoomPosition(left: 390, top: 440),
  '1006-1': RoomPosition(left: 140, top: 720),
  '1006-6': RoomPosition(left: 240, top: 620),
  '1204': RoomPosition(left: 220, top: 120),
  '1209': RoomPosition(left: 380, top: 120),
  '1210': RoomPosition(left: 560, top: 120),
  '1213': RoomPosition(left: 720, top: 120),
  'e.space': RoomPosition(left: 980, top: 120),
  'l.space': RoomPosition(left: 980, top: 440),
  '1225': RoomPosition(left: 1320, top: 120),
  '1228': RoomPosition(left: 1470, top: 120),
  '1122': RoomPosition(left: 1140, top: 440),
  '1125': RoomPosition(left: 1290, top: 440),
  '1128': RoomPosition(left: 1440, top: 440),
};
