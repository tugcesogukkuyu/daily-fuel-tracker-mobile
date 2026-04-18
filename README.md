# Daily Fuel Tracker Mobile

A Flutter-based mobile application for tracking daily nutrition, exercise, and hydration with a backend-driven architecture.

The application integrates with a Node.js + Express backend and PostgreSQL database to provide persistent, user-specific tracking across sessions.


## Project Structure

```text
daily_fuel_tracker_mobile/
├── assets/
│   ├── data/
│   │   └── foods.json
│   └── images/
├── lib/
│   ├── core/
│   │   ├── constants/
│   │   │   ├── api_constants.dart
│   │   │   └── app_colors.dart
│   │   ├── theme/
│   │   │   └── app_theme.dart
│   │   └── utils/
│   │       └── date_helper.dart
│   ├── data/
│   │   ├── models/
│   │   │   ├── blog_model.dart
│   │   │   ├── food_item_model.dart
│   │   │   ├── tracked_exercise_model.dart
│   │   │   ├── tracked_meal_model.dart
│   │   │   ├── user_model.dart
│   │   │   └── water_model.dart
│   │   ├── services/
│   │   │   ├── api_service.dart
│   │   │   ├── auth_service.dart
│   │   │   ├── blog_service.dart
│   │   │   ├── exercise_service.dart
│   │   │   ├── food_data_service.dart
│   │   │   ├── meal_service.dart
│   │   │   └── water_service.dart
│   │   └── store/
│   │       ├── auth_store.dart
│   │       └── daily_tracker_store.dart
│   ├── screens/
│   │   ├── auth/
│   │   ├── blog/
│   │   ├── dashboard/
│   │   ├── exercises/
│   │   ├── meals/
│   │   ├── profile/
│   │   └── water/
│   ├── widgets/
│   │   ├── app_button.dart
│   │   ├── app_calendar_sheet.dart
│   │   ├── app_text_field.dart
│   │   ├── exercise_bottom_sheet.dart
│   │   ├── meal_bottom_sheet.dart
│   │   ├── metric_card.dart
│   │   └── profile_menu_sheet.dart
│   ├── app.dart
│   └── main.dart
├── android/
├── ios/
├── pubspec.yaml
└── README.md
```

---

## Architecture

The mobile client is structured into four primary layers:

- **UI Layer**: `screens/`, `widgets/`
- **State Layer**: `auth_store.dart`, `daily_tracker_store.dart`
- **Service Layer**: API communication modules under `services/`
- **Model Layer**: typed data structures under `models/`

The application does not rely on local mock data for core flows. All major features are integrated with the backend API.

---

## Runtime Model

The mobile application communicates with the following backend domains:

- `auth`
- `foods`
- `blogs`
- `meals`
- `exercises`
- `exercise catalog`
- `water`

Application state is managed through two main stores:

- **AuthStore** → handles authentication, session lifecycle, and secure restoration
- **DailyTrackerStore** → manages date-based meals, exercises, and water data

---

## Technologies

```text
| Layer | Technology | Purpose |
|---|---|---|
| Mobile | Flutter | Cross-platform mobile UI framework |
| Language | Dart | Application development language |
| Networking | http | REST API communication |
| Storage | flutter_secure_storage | Secure token & session persistence |
| UI | table_calendar | Calendar-based date selection |
| UI | google_fonts | Typography customization |
| Utility | intl | Date formatting & localization |
| Backend | Node.js + Express.js | REST API layer |
| Database | PostgreSQL | Persistent data storage |
```

---

## Features

- email/password registration
- email/password login
- persistent session restoration
- daily meal add / delete flows
- daily exercise add / delete flows
- exercise catalog search
- daily water tracking
- date-based record filtering
- blog list and blog detail views
- backend-backed persistence across app restarts

---

## System Capabilities

| Domain | Capability |
|---|---|
| Authentication | User registration, login, and secure session restoration |
| Nutrition Tracking | Add, list, and delete daily meal records |
| Exercise Tracking | Add, list, search, and delete daily exercise records |
| Hydration Tracking | Update and persist daily water consumption |
| Date-Based State | Filter meals, exercises, and water logs by selected date |
| Content | Display blog list and blog detail views |
| Persistence | Restore user-specific records from backend storage across app restarts |

---

## Session Management

| Component | Responsibility |
|---|---|
| Storage | Secure persistence via `flutter_secure_storage` |
| AuthStore | In-memory session state and lifecycle management |
| Token | Bearer token used for authenticated API requests |

### Stored Keys

```text
auth_user_id
auth_full_name
auth_email
auth_token
```

### Startup flow:

```text
App Launch
→ Restore session from secure storage
→ Validate session existence
→ Initialize AuthStore
→ Fetch user-specific data for selected date
→ Render dashboard state
```

---

## Data Persistence

| Layer | Description |
|---|---|
| Backend API | Handles all CRUD operations |
| Database | PostgreSQL stores user-specific records |
| Scope | Data is persisted per user and per date |

### Persisted Domains

- users
- meals
- exercises
- water_logs

---

## Backend Integration

| Component | Value |
|---|---|
| Backend Project | `daily_fuel_tracker_backend` |
| Base URL Config | `lib/core/constants/api_constants.dart` |
| Development URL | `http://localhost:3000/api` |

---

### Environment Notes

- iOS Simulator → `localhost` works
- Android Emulator → use `10.0.2.2`
- Production → must point to deployed backend URL

---

## Getting Started

### Prerequisites

- Flutter SDK
- iOS Simulator (Xcode) or Android Emulator (Android Studio)
- Running backend API (`daily_fuel_tracker_backend`)
- PostgreSQL database

---

### Installation

```bash
flutter pub get
```

---

### Backend Setup

```bash
cd ../daily_fuel_tracker_backend
npm install
npm run dev
```

---

### Run Application

```bash
flutter run
```
---

## API Integration

### Authentication

| Method | Endpoint |
|---|---|
| POST | /api/auth/register |
| POST | /api/auth/login |

---

### Foods

| Method | Endpoint |
|---|---|
| GET | /api/foods |

---

### Blogs

| Method | Endpoint |
|---|---|
| GET | /api/blogs |
| GET | /api/blogs/:slug |

---

### Meals

| Method | Endpoint |
|---|---|
| GET | /api/meals?userId=...&date=... |
| POST | /api/meals |
| DELETE | /api/meals/:id |

---

### Exercises

| Method | Endpoint |
|---|---|
| GET | /api/exercises?userId=...&date=... |
| POST | /api/exercises |
| DELETE | /api/exercises/:id |
| GET | /api/exercises/catalog/search?q=... |

---

### Water

| Method | Endpoint |
|---|---|
| GET | /api/water?userId=...&date=... |
| PUT | /api/water |

---

## State Flow

### Authentication Flow

```text
User submits credentials
→ Backend validates request
→ Backend returns authenticated user and access token
→ Session data is written to secure storage
→ AuthStore updates in-memory session state
→ DailyTrackerStore refreshes selected-date data
→ Dashboard becomes active
```

### Meal Flow

```text
Meal entry UI requests food data from backend
→ User selects meal type and food item
→ Meal record is submitted to backend
→ Backend persists meal record
→ DailyTrackerStore refreshes selected-date meals
→ Dashboard and meal detail views render updated state
```

### Exercise Flow

```text
User searches exercise catalog
→ Backend returns normalized exercise results
→ User selects exercise and duration
→ Exercise record is submitted to backend
→ Backend persists exercise record
→ DailyTrackerStore refreshes selected-date exercises
→ Dashboard and exercise detail views render updated state
```

### Water Flow

```text
User increments or decrements daily water amount
→ Updated value is sent to backend
→ Backend persists water log
→ DailyTrackerStore updates hydration state
→ Dashboard water card renders latest value
```

---

## Screen Responsibilities

| Screen | Responsibility |
|---|---|
| Login | Handles user authentication |
| Register | Handles user registration |
| Dashboard | Displays daily summary metrics and selected-date overview |
| Meals | Manages date-based meal records (add / delete) |
| Exercises | Manages date-based exercise records (add / delete / search) |
| Water | Manages daily hydration tracking |
| Blog | Displays blog list and blog detail content |
| Profile | Handles user-related actions and session context |

---

## Development Notes

- `AuthStore` owns authentication state and secure session restoration
- `DailyTrackerStore` owns selected-date meals, exercises, and water state
- food selection is backend-backed rather than mock-driven
- exercise search is powered by the backend catalog endpoint
- meals, exercises, and water records are fetched per user and per selected date
- the mobile client and backend are maintained as separate repositories
- core user flows are integrated with persistent backend storage

---

## Tested Flows

| Flow | Status |
|---|---|
| User registration | Implemented |
| User login | Implemented |
| Session restoration after app restart | Implemented |
| Meal add / delete | Implemented |
| Exercise add / delete | Implemented |
| Water increment / decrement | Implemented |
| Date switching | Implemented |
| Blog list / detail view | Implemented |
| Backend-backed data reload | Implemented |

---

## Troubleshooting

### API connection refused

Ensure the backend service is running and the base URL is correctly configured:

`lib/core/constants/api_constants.dart`

---

### Session not restored

Verify that:

- session restoration is triggered before app initialization
- secure storage write operations complete successfully after login

---

### iOS build issues

```bash
flutter clean
flutter pub get
flutter run
```

If needed:

```bash
cd ios
pod install
cd ..
flutter run
```

---

### Data exists in backend but not visible in app

Verify that:

- the same user account is used
- the selected date matches the stored record date
- `DailyTrackerStore.refreshForSelectedDate()` is triggered after state updates

---

## Current Status

| Area | Status |
|---|---|
| Flutter UI layer | Completed |
| Backend integration | Completed |
| PostgreSQL data persistence | Completed |
| Secure session management | Completed |
| Meals / exercises / water flows | Completed |
| Blog module | Completed |
| Date-based state management | Completed |

---

### Remaining Work

- production deployment
- app icon and branding updates
- release configuration
- final UX polish

---

## License

MIT