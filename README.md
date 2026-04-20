# School App 📚

An all-in-one school management mobile app for **Android + iOS**, built with Flutter and Firebase.

## Roles

| Role      | What they can do |
|-----------|------------------|
| **Student**   | Attendance, marks, timetable, assignments, fees, library, study materials, announcements, events, leave request, chat with teacher |
| **Teacher**   | Mark attendance, upload marks, create/grade assignments, approve leave, timetable, announcements, chat |
| **Principal** | School-wide dashboards (attendance, fees, staff), announcements, events, staff management, reports |
| **Parent**    | Child's attendance/marks/timetable, pay fees (Razorpay stub), chat with class teacher, notices, leave for child |
| **Admin**     | User / class / subject management, school settings |

All roles share: push notifications (FCM), role-based routing, light/dark theme, profile, sign-out.

## Tech stack

- **Flutter 3.24+** (Dart 3.5)
- **Firebase**: Auth, Firestore, Storage, Cloud Messaging (optional — see below)
- **State**: `flutter_riverpod`
- **Routing**: `go_router`
- **Charts / UI**: `fl_chart`, `table_calendar`, `google_fonts`, `cached_network_image`

## Running locally (demo mode — no backend required)

```bash
flutter pub get
flutter run
```

The app boots in **demo mode** with in-memory mock data. On the login screen tap any role chip and then **Demo &lt;Role&gt; Login** to jump directly into that role's dashboard. No Firebase configuration is needed to explore the UI.

## Enabling Firebase

1. Create a Firebase project at <https://console.firebase.google.com>.
2. Install FlutterFire CLI and configure:
   ```bash
   dart pub global activate flutterfire_cli
   flutterfire configure --project=<your-firebase-project-id>
   ```
   This generates `lib/firebase_options.dart` and places `google-services.json` / `GoogleService-Info.plist` into the Android and iOS projects.
3. Update `lib/main.dart` to pass the generated options:
   ```dart
   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
   ```
   (or just replace the call inside `core/services/firebase_bootstrap.dart`.)
4. Deploy the Firestore rules:
   ```bash
   firebase deploy --only firestore:rules
   ```
   Rules live at [`firebase/firestore.rules`](firebase/firestore.rules). Schema reference at [`firebase/SCHEMA.md`](firebase/SCHEMA.md).
5. Run with Firebase enabled:
   ```bash
   flutter run --dart-define=USE_FIREBASE=true
   ```

## Project structure

```
lib/
├── main.dart                      # entry point
├── app.dart                       # MaterialApp.router
├── core/
│   ├── constants/                 # app-wide constants, role enum
│   ├── theme/                     # light + dark themes
│   ├── router/                    # go_router with role-based redirects
│   ├── models/                    # AppUser, SchoolClass, Subject, Attendance, Marks, Fees, …
│   ├── services/
│   │   ├── firebase_bootstrap.dart
│   │   ├── auth_service.dart
│   │   └── mock_data.dart         # demo seed
│   └── providers/                 # Riverpod providers
├── features/
│   ├── auth/       (splash, login)
│   ├── student/    (dashboard, attendance, marks, timetable,
│   │                assignments, fees, library, study materials)
│   ├── teacher/    (dashboard, attendance marking, marks upload,
│   │                leave requests)
│   ├── principal/  (dashboard, staff overview)
│   ├── parent/     (dashboard, fees pay)
│   ├── admin/      (dashboard)
│   └── common/     (announcements, events, notifications,
│                    profile, chat)
└── shared/widgets/ (dashboard_card, stat_tile)
```

## Payments (Razorpay)

The parent & student Fees screens call into a simple stub. To enable real payments:

1. `flutter pub add razorpay_flutter`
2. Add your Razorpay Key in an environment variable / secret.
3. Replace the `_showPayDialog` / `_pay` methods with a call to `Razorpay.open(...)` and verify on a Cloud Function.

## Push notifications

`firebase_messaging` is wired via `firebase_bootstrap.dart`. Enable APNs on iOS + add `google-services.json` on Android, then register the device token after login and send via Cloud Functions or the Firebase console.

## Commands

```bash
flutter pub get          # install deps
flutter analyze          # static analysis
flutter test             # run widget tests
flutter run              # run on connected device
flutter build apk        # Android release APK
flutter build ios        # iOS release build (needs macOS + signing)
```

## Status

This is a scaffold with all role dashboards + primary feature screens implemented against mock data. Swap the service layer (`auth_service.dart` etc.) to Firebase calls once you run `flutterfire configure`.
