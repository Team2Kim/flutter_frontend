<img width="240" height="200" alt="image" src="https://github.com/user-attachments/assets/fcb68c23-da70-460f-b46c-d9c570e482a9" />

한국체육진흥공단 공모전 애플리케이션 **오늘운동**

AI(LLM, RAG) 기반 개인 맞춤 운동 일지 관리 앱

## 앱 소개

오늘운동은 사용자의 운동 기록을 체계적으로 관리하고, AI 분석을 통해 개인 맞춤형 운동 추천을 제공하는 종합 운동 관리 애플리케이션입니다.

### 주요 기능

#### 1. 운동 일지 관리
- 날짜별 운동 기록 작성 및 관리
- 운동별 세트, 횟수, 강도 기록
- 운동 통계 및 분석
- AI 기반 운동 분석 및 피드백

#### 2. AI 운동 분석
- **일일 분석**: 당일 운동에 대한 AI 평가 및 추천
- **주간 패턴 분석**: 일주일 운동 패턴 분석 및 루틴 추천
- **타겟 근육 분석**: 운동한 근육 부위 분석
- **다음 훈련 추천**: AI가 추천하는 다음 운동 근육 및 운동 목록

#### 3. 운동 검색 및 영상
- 운동 데이터베이스 검색
- 운동 영상 시청 및 학습
- 근육별 운동 검색
- 운동 상세 정보 확인

#### 4. 시설 검색
- 네이버 지도 연동 시설 검색
- 주변 운동 시설 찾기
- 즐겨찾기 기능

#### 5. 근육 선택 기능
- 신체 부위 선택 (전면/후면/좌우측면)
- 선택한 부위의 근육 목록 표시
- 다중 근육 선택 및 검색

#### 6. 사용자 인증
- 회원가입 및 로그인
- 자동 로그인 상태 유지
- 사용자 정보 관리

## 기술 스택

- **Framework**: Flutter
- **Language**: Dart
- **State Management**: Provider
- **지도 서비스**: Naver Map API
- **로컬 저장소**: SharedPreferences
- **HTTP 통신**: http package
- **비디오 플레이어**: video_player
- **캘린더**: table_calendar

## 주요 패키지

```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.1.1
  shared_preferences: ^2.2.2
  flutter_dotenv: ^5.1.0
  flutter_naver_map: ^1.4.0
  table_calendar: ^3.1.2
  http: ^1.1.0
  video_player: ^2.8.2
  cached_network_image: ^3.3.1
  geolocator: ^10.0.1
  permission_handler: ^11.0.1
  body_part_selector: ^0.2.0
```

## 프로젝트 구조

```
lib/
├── config/          # 설정 파일
├── model/           # 데이터 모델
├── provider/        # 상태 관리 (Provider)
├── screen/          # 화면 (UI)
├── services/        # API 서비스
├── widget/          # 재사용 가능한 위젯
└── main.dart        # 앱 진입점
```

## 주요 화면

- **홈 화면**: 메인 대시보드 및 기능 접근
- **운동 일지**: 날짜별 운동 기록 작성 및 조회
- **시설 검색**: 주변 운동 시설 찾기
- **영상 검색**: 운동 영상 검색 및 시청
- **즐겨찾기**: 저장한 운동 및 시설 관리
- **설정**: 앱 설정 및 사용자 정보
- **근육 선택**: 신체 부위 및 근육 선택
- **AI 분석**: 운동 분석 결과 확인

## API 연동

### ExRecAI API
- **일지 조회**: `GET /api/journals/by-date?date={date}`
- **AI 분석**: 운동 일지 기반 AI 분석
- **운동 검색**: `GET /api/exercises`
- **AI 추천**: `POST /api/recommendation/basic`

## 라이선스

이 프로젝트는 한국체육진흥공단 공모전을 위해 개발되었습니다.

## 개발팀

Team Two Kim

---

**오늘 운동**
