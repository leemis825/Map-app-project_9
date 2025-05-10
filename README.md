🗺️ 조선대학교 캠퍼스 실내 지도 앱

📌 프로젝트 개요

Flutter 기반으로 제작된 조선대학교 캠퍼스 실내 지도 앱입니다. 실시간 강의 시간표, 층별 강의실 위치, BLE 비콘 스캔, 검색 기능 등을 통해 학생들의 이동과 시간 관리를 효율화하는 것을 목표로 합니다.

✅ 주요 기능

실내 도면 기반 강의실 탐색 (1층~10층)

강의실 시간표 표시 (병합 셀 UI 적용)

강의명/교수명/강의실명 실시간 검색

BLE 비콘 스캔 및 Firebase Firestore 연동

로그인 화면, 반응형 UI, 다크모드 지원

📁 폴더 구조

assets/
├── data/
│   └── classroom_schedule_final.json    # 강의실 시간표 JSON
├── images/                              # 도면 및 UI 이미지
│   ├── campus_map.png
│   ├── it_building_1f_map.png ~ 10f_map.png
│   └── logo.png

lib/
├── data/
│   └── lecture_data.dart                # JSON 로딩 및 검색 처리
├── models/
│   └── models.dart                      # RoomInfo, IconInfo 모델 정의
├── screens/
│   ├── login_screen.dart                # 로그인 UI
│   ├── campus_map_screen.dart           # 캠퍼스 지도 메인 화면
│   ├── menu.dart                        # IT융합대학 지도 + 층 선택
│   ├── lecture_schedule_screen.dart     # 강의실 시간표
│   ├── lecture_detail_screen.dart       # 강의 상세 정보
│   ├── it_building_1f~10f_screen.dart   # 각 층 도면별 화면
│   ├── buildingFloorScreen.dart         # 공통 도면 + 버튼 처리
│   ├── beacon_scan_screen.dart          # BLE 비콘 스캔 및 저장
│   ├── home_screen.dart                 # 본관 정보 화면
│   └── floor_selector_screen.dart       # (미사용) 층 목록 선택 화면
├── widgets/
│   ├── common_search_appbar.dart        # 상단 검색 AppBar 위젯
│   └── responsive_layout.dart           # 반응형 화면 적용 Wrapper
├── dummy.dart                           # Firebase 예시 코드 모음 (주석)
└── main.dart                            # 앱 진입점

🔄 앱 흐름도 (기능 이동 구조)

graph TD
  main[main.dart] --> login[LoginScreen]
  login --> map[CampusMapScreen]
  map --> menu[MenuScreen]
  menu --> it[ItBuildingXfScreen]
  it --> schedule[LectureScheduleScreen]
  schedule --> detail[LectureDetailScreen]
  map --> search[SearchBarWithResults]
  menu --> search
  search --> schedule

🔍 핵심 클래스 설명

📦 lecture_data.dart

loadLectureData(): JSON 불러오기

getLecturesForRoom(roomName): 특정 강의실 데이터

searchLecturesByKeyword(keyword): 검색 기능 구현

🧱 models.dart

RoomInfo: 강의실 위치 좌표 보관

IconInfo: 아이콘(엘리베이터/계단 등) 위치 보관

🗓️ lecture_schedule_screen.dart

병합 셀로 강의 시간 표시

클릭 시 LectureDetailScreen으로 이동

🔎 search_bar_with_results.dart

강의실/강의명/교수명 기반 자동완성 검색

🧩 유지보수 및 구조 개선 제안

📁 구조 확장 제안

lib/
├── services/       # 비콘, Firebase 처리 분리
├── utils/          # 공통 유틸 함수
├── themes/         # 색상, 테마 관리
├── constants/      # 문자열, 상수 분리
├── routes/         # 라우팅 경로 관리

💡 향후 확장 가능 기능

즐겨찾는 강의실 저장

검색 히스토리 추천 기능

현재 위치 자동 표시 (비콘 기반)

포털 로그인 연동

📦 주요 패키지 목록

패키지

설명

flutter_svg

SVG 아이콘 렌더링

google_fonts

폰트 적용

cloud_firestore, firebase_core

Firebase 연동

dchs_flutter_beacon

비콘 스캔 기능

permission_handler

위치 권한 요청

uuid

고유 ID 생성

📢 협업 및 배포 가이드

시간표 데이터(JSON)는 주기적으로 갱신 필요

도면 이미지 변경 시 assets/images 내 동일 파일명으로 교체

Firebase 연동 정보는 로컬에서 설정 필요 (예: google-services.json)

웹 배포 시 Firebase Hosting 또는 Flutter Web 활용 가능

🙋 문의 및 협업: 조선대학교 IT융합캡스톤 프로젝트 팀