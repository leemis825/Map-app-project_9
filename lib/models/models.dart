// 중복 코드 정리
// 강의실 정보 클래스
class RoomInfo {
  final String name;
  final double left;
  final double top;

  RoomInfo({required this.name, required this.left, required this.top});

  factory RoomInfo.fromJson(Map<String, dynamic> json) {
    return RoomInfo(
      name: json['name'],
      left: json['left'].toDouble(),
      top: json['top'].toDouble(),
    );
  }
}

// 아이콘 정보 클래스 (화장실, 계단 등)
class IconInfo {
  final String asset;
  final double left;
  final double top;

  IconInfo({
    required this.asset,
    required this.left,
    required this.top,
  });
}
