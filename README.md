# Daily Fuel Tracker Mobile

Flutter tabanlı mobil istemci.  
Uygulama, ayrı bir Node.js/Express backend API ve PostgreSQL veritabanı ile çalışır.

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


## Architecture

The mobile client is organized into four primary layers:

- **UI Layer**: `screens/` and `widgets/`
- **State Layer**: `auth_store.dart`, `daily_tracker_store.dart`
- **Service Layer**: API communication modules under `services/`
- **Model Layer**: typed data mapping under `models/`

The app no longer relies on local mock data for the core user flows. Authentication, meals, exercises, water logs, blog content, and food data are integrated with the backend API.

## Runtime Model

The mobile client communicates with the following backend domains:

- `auth`
- `foods`
- `blogs`
- `meals`
- `exercises`
- `exercise catalog search`
- `water`

Application state is coordinated primarily through two stores:

- `AuthStore`: session lifecycle and secure session restoration
- `DailyTrackerStore`: date-based meal, exercise, and water state

## Technologies

| Technology | Purpose |
|---|---|
| Flutter | Mobile UI framework |
| Dart | Application language |
| http | REST client |
| flutter_secure_storage | Secure token and session persistence |
| intl | Localization and date formatting |
| table_calendar | Calendar UI |
| google_fonts | Typography |
| Node.js + Express.js | Backend API |
| PostgreSQL | Persistent storage |

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

## Session Persistence

Session data is stored with `flutter_secure_storage`.

Stored keys:

```text
auth_user_id
auth_full_name
auth_email
auth_token

Startup flow:

App launch
→ restore session from secure storage
→ if session exists, open dashboard
→ fetch meals / exercises / water for selected date
→ render current user state

Data Persistence
User-generated data is persisted in PostgreSQL through the backend API.

Persisted domains:

users
meals
exercises
water logs
As a result, when the same user logs in again, previously recorded data is retrieved from the backend and rendered back into the app.

Backend Dependency
This mobile repository depends on a separate backend project:

daily_fuel_tracker_backend
The API base URL is configured in:

lib/core/constants/api_constants.dart
Example development base URL:

http://localhost:3000/api
Notes:

localhost works for iOS Simulator
Android Emulator typically requires 10.0.2.2
production builds should point to the deployed backend URL

Getting Started
Prerequisites
Flutter SDK
Xcode / iOS Simulator or Android Studio / Android Emulator
running backend API
running PostgreSQL database
Install dependencies
flutter pub get
Start the backend
cd ../daily_fuel_tracker_backend
npm run dev
Run the mobile app
flutter run
API Integration
Authentication
POST /api/auth/register
POST /api/auth/login
Foods
GET /api/foods
Blogs
GET /api/blogs
GET /api/blogs/:slug
Meals
GET /api/meals?userId=...&date=...
POST /api/meals
DELETE /api/meals/:id
Exercises
GET /api/exercises?userId=...&date=...
POST /api/exercises
DELETE /api/exercises/:id
GET /api/exercises/catalog/search?q=...
Water
GET /api/water?userId=...&date=...
PUT /api/water

State Flow
Login Flow
User submits credentials
→ backend returns user + token
→ session is written to secure storage
→ AuthStore updates in-memory session state
→ DailyTrackerStore refreshes selected date data
→ dashboard becomes the active screen
Meal Flow
Meal bottom sheet loads foods from backend
→ user selects meal type
→ user selects a food item
→ meal record is posted to backend
→ DailyTrackerStore refreshes selected date data
→ dashboard and meal detail views reflect the updated state
Exercise Flow
User searches exercise catalog
→ backend returns normalized exercise results
→ user selects exercise + duration
→ exercise record is posted to backend
→ DailyTrackerStore refreshes selected date data
→ dashboard and exercise detail views reflect the updated state
Water Flow
User increments or decrements water amount
→ updated value is sent to backend
→ water log is persisted
→ DailyTrackerStore updates local state
→ dashboard water card reflects the latest value

Screen Responsibilities
Screen	Responsibility
Login	user authentication
Register	account creation
Dashboard	summary metrics and current-day overview
Meals	date-based meal records, add / delete
Exercises	date-based exercise records, add / delete
Water	daily hydration tracking
Blog	content list and detail rendering
Profile	account-related actions

Development Notes
AuthStore owns session state and secure restoration
DailyTrackerStore owns daily meals, exercises, and water state
food selection is backend-backed
exercise search uses the backend catalog endpoint instead of a hardcoded static list
meals, exercises, and water are fetched per user and per selected date
the mobile client and backend are separated into different repositories
Tested Flows
user registration
user login
session restoration after app restart
meal add / delete
exercise add / delete
water increment / decrement
date switching
blog open / detail view
backend-backed data reload
Troubleshooting
API connection refused
Check that the backend is running and the base URL is correct.

lib/core/constants/api_constants.dart
Session is not restored
Verify that:

main.dart
restores the session before app startup and that secure storage writes are completed after login.

iOS build issues
Run:

flutter clean
flutter pub get
flutter run
If needed:

cd ios
pod install
cd ..
flutter run
Data exists in backend but is not visible in the app
Verify:

the same user account is being used
the selected date matches the record date
DailyTrackerStore.refreshForSelectedDate() is called after state-changing operations

Current Status
Core application development is complete.

Completed areas:

Flutter UI layer
backend integration
persistent PostgreSQL-backed records
secure session persistence
meals / exercises / water flows
blog module
date-based state management
Remaining work is mainly polish and release preparation:

production deployment
app icon / branding updates
release configuration
final UX polish
