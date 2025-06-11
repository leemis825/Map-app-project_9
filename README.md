
# 🗺️ 교내 실내 지도 앱 – lib/ 폴더 구조 정리

## 📌 1. 핵심 진입점 (`core`)
- `main.dart`:  
  앱 시작점.  
  Firebase 초기화, Provider 설정, 로그인 또는 지도 화면으로 전환 처리.

---

## 🔥 2. Firebase 연동 (`firebase`)
- `firebase.dart`: Firebase 기능 헬퍼 함수
- `firebase_options.dart`: FlutterFire 자동 생성된 구성 파일

---

## 🙍‍♂️ 3. 사용자 상태 관리 (`user`)
- `user_provider.dart`:  
  사용자 상태 전역 관리 (`Provider` 사용)

---

## 📂 4. 데이터 및 모델 (`data`)
- `lecture_data.dart`: 시간표 JSON 로딩 및 필터링
- `room_coordinates.dart`: 강의실 → 위치 좌표 매핑
- `room_floor_table.dart`: 강의실 → 층수 매핑
- `beacon_scanner.dart`: BLE 비콘 신호 스캔 처리
- `models.dart`: RoomInfo, IconInfo 등 모델 정의

---

## 🧭 5. 주요 화면 구성 (`screens`)
- `menu.dart`: IT융합대학 층별 도면 중심 UI, QR·BLE·검색 연동
- `campus_map_screen.dart`: 비콘으로 건물/층 감지 후 Menu로 이동
- `navigate_result_screen.dart`: 경로 탐색 시각화
- `lecture_schedule_screen.dart`, `lecture_detail_screen.dart`: 시간표 및 상세 강의 정보
- `login_screen.dart`: 로그인 UI
- `qr_navigate_screen.dart`: QR로 현재 위치 인식 → 경로 안내
- `MyPage.dart`, `MyTimetable.dart`: 사용자 정보/시간표
- `it_building_Xf_screen.dart`: 각 층별 도면 화면 구성
- `room_intro.dart`, `space_detail_screen.dart`: 공간 소개 화면

---

## 🧰 6. 유틸리티 (`utils`)
- `ble_helper.dart`: BLE 스캔 후 거리 계산 및 처리
- `floor_screen_router.dart`: 층수 → 대응 도면 화면 매핑

---

## 🧱 7. 공용 위젯 (`widgets`)
- `qr_button.dart`: QR 팝업 호출용 FAB
- `qr_floor_scanner_widget.dart`: MobileScanner 사용한 QR 인식 팝업
- `locate_button.dart`: BLE 감지를 통한 위치 확인 버튼
- `navigate_button.dart`: 경로 탐색 시작 버튼
- `ble_debug_popup.dart`: BLE 상태 표시 팝업
- `FloorSelect.dart`: 층 선택 위젯
- `search_bar_with_results.dart`: 강의실 실시간 검색바
- `lecturestatusdot.dart`: 강의실 상태 표시 점 UI
- `responsive_layout.dart`: 반응형 대응 위젯
- `AppDrawer.dart`: 앱 전체 메뉴 드로어

---

## 🔗 전체 흐름 요약
```
main.dart
  └─ 로그인 성공 → campus_map_screen.dart
        └─ BLE 또는 QR 인식 → MenuScreen
              ├─ 층 도면: it_building_Xf_screen.dart
              ├─ FABs
              │    ├─ LocateButton → ble_floor_detector.dart
              │    ├─ QrButton → qr_floor_scanner_widget.dart
              │    └─ NavigateButton → navigate_result_screen.dart
              └─ 강의실 검색 → lecture_schedule_screen.dart
```
