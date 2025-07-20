# CarPlatform - 중고차 거래 플랫폼

Ruby on Rails 8.0을 기반으로 한 현대적인 중고차 거래 플랫폼입니다.

## 🚗 주요 기능

### 핵심 기능
- **사용자 관리**: Devise를 통한 인증 시스템, 관리자/일반 사용자 권한 구분
- **차량 관리**: 차량 등록, 수정, 삭제, 이미지 업로드 (Active Storage)
- **고급 검색**: Ransack을 통한 다중 조건 검색 및 필터링
- **페이지네이션**: 성능 최적화된 커스텀 페이지네이션

### 소셜 기능
- **관심 차량**: 찜하기/찜 해제 기능
- **리뷰 시스템**: 5점 평점 및 댓글 시스템
- **메시징**: 사용자 간 실시간 메시지 교환
- **차량 비교**: 최대 3개 차량 동시 비교

### 고급 기능
- **가격 알림**: 목표 가격 도달 시 자동 알림
- **실시간 알림**: 새 메시지, 가격 변동 등 알림 시스템
- **성능 최적화**: 데이터베이스 인덱싱, 캐싱 시스템
- **관리자 대시보드**: 사용자, 차량, 리뷰 통계 및 관리

## 🛠 기술 스택

- **Backend**: Ruby on Rails 8.0
- **Database**: SQLite3 (개발), PostgreSQL (프로덕션 권장)
- **Frontend**: Tailwind CSS, Stimulus, Turbo
- **Authentication**: Devise
- **Search**: Ransack
- **File Storage**: Active Storage
- **Caching**: Rails Cache (Solid Cache)
- **Background Jobs**: Solid Queue
- **Deployment**: Docker + Kamal

## 📋 설치 및 실행

### 필수 요구사항
- Ruby 3.4.4+
- Rails 8.0+
- Node.js (JavaScript 의존성)
- SQLite3

### 설치 과정

1. **저장소 클론**
   ```bash
   git clone <repository-url>
   cd carplatform
   ```

2. **의존성 설치**
   ```bash
   bundle install
   ```

3. **데이터베이스 설정**
   ```bash
   rails db:create
   rails db:migrate
   rails db:seed
   ```

4. **더미 데이터 생성 (선택사항)**
   ```bash
   rails db:generate_dummy_cars
   ```

5. **서버 실행**
   ```bash
   rails server
   ```

6. **브라우저에서 접속**
   ```
   http://localhost:3000
   ```

## 🧪 테스트

```bash
# 전체 테스트 실행
rails test

# 특정 테스트 실행
rails test test/controllers/cars_controller_test.rb
```

## 📊 주요 모델 관계

```
User
├── has_many :cars
├── has_many :favorites
├── has_many :reviews
├── has_many :notifications
├── has_many :price_alerts
└── has_many :conversations

Car
├── belongs_to :user
├── has_many :favorites
├── has_many :reviews
├── has_many_attached :images
└── includes Cacheable

Review
├── belongs_to :user
├── belongs_to :car
└── validates :rating (1-5)
```

## 🔧 주요 컨트롤러

- **CarsController**: 차량 목록, 상세보기, 검색
- **AdminController**: 관리자 대시보드 및 관리 기능
- **FavoritesController**: 관심 차량 관리
- **ReviewsController**: 리뷰 작성/삭제
- **ConversationsController**: 메시지 시스템
- **CarComparisonsController**: 차량 비교 기능
- **PriceAlertsController**: 가격 알림 관리
- **NotificationsController**: 알림 시스템

## 🚀 배포

### Docker 배포
```bash
# Docker 이미지 빌드
docker build -t carplatform .

# 컨테이너 실행
docker run -p 3000:3000 carplatform
```

### Kamal 배포
```bash
# 배포 설정
kamal setup

# 배포 실행
kamal deploy
```

## 📈 성능 최적화

### 데이터베이스 최적화
- 검색 성능을 위한 복합 인덱스
- 자주 조회되는 컬럼에 대한 단일 인덱스
- 외래 키 제약 조건 최적화

### 캐싱 전략
- 차량 평점 및 리뷰 수 캐싱
- 검색 결과 캐싱 (30분)
- 개별 차량 정보 캐싱 (1시간)

### 쿼리 최적화
- N+1 쿼리 방지를 위한 includes 사용
- 페이지네이션으로 메모리 사용량 제어

## 🔄 정기 작업

### 가격 알림 체크
```bash
# 매시간 실행 권장
rails price_alerts:check
```

## 🎯 향후 개선 계획

1. **결제 시스템 연동** (Stripe, PayPal)
2. **실시간 채팅** (Action Cable)
3. **지도 기반 검색** (Google Maps API)
4. **모바일 앱** (React Native)
5. **AI 기반 가격 예측**
6. **차량 상태 평가 시스템**

## 📝 라이센스

이 프로젝트는 MIT 라이센스 하에 배포됩니다.

## 🤝 기여하기

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📞 지원

문제가 있거나 제안사항이 있으시면 이슈를 생성해 주세요.
