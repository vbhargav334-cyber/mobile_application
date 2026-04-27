# Testing the school app (Flutter web, demo mode)

Use this skill when you need to launch the app and walk through any role-based UI flow without setting up Android/iOS emulators or Firebase.

## Build for web

The repo directory is named `school-app` (with a hyphen), which is **not** a valid Dart package name. The pubspec uses `name: school_app`, so when adding the web platform you MUST pass `--project-name`:

```bash
# Only needed once per checkout (web/ folder is git-ignored by default flutter create output)
flutter create --project-name=school_app --platforms=web .
flutter build web --release
```

Without `--project-name`, `flutter create .` fails with: `"school-app" is not a valid Dart package name.`

## Serve the build

```bash
python3 -m http.server 8000 --directory build/web
```

Then open `http://localhost:8000` in Chrome. The app uses hash routing, so URLs look like `localhost:8000/#/student`, `localhost:8000/#/teacher`, etc.

## Demo login (no Firebase, no real auth)

The login screen (<ref_file file="lib/features/auth/login_screen.dart" />) shows 5 role chips and one "Demo {Role} Login" button below the email/password form. Tapping the chip changes the button label and target role; tapping the demo button calls `authServiceProvider.signInWithRole(role)` which the router (<ref_file file="lib/core/router/app_router.dart" />) redirects to `/{role}`.

Valid demo paths after login:

| Role | URL | Sign-out |
|---|---|---|
| Student | `/#/student` | Tap profile icon (top-right) → `Sign Out` |
| Teacher | `/#/teacher` | Same |
| Principal | `/#/principal` | Same |
| Parent | `/#/parent` | Same |
| Admin | `/#/admin` | Same |

To switch roles during testing, sign out via the profile icon and the bottom red `Sign Out` button on the profile screen — that returns to `/login` cleanly.

## Key interactive flows worth verifying

- **Teacher attendance toggle** (`/teacher` → `Mark Attendance`): SwitchListTile per student, top counter `Present: X / Y` updates immediately, `Save Attendance` shows SnackBar `Attendance saved for today (demo mode)`.
- **Parent fees pay** (`/parent` → `Pay Fees`): each pending fee has a `Pay ₹{amount}` button that opens an AlertDialog titled `Razorpay`. The `Proceed` button shows SnackBar `Paid ₹{amount} (demo)`.

## Known cosmetic issues (not blocking)

- Principal "Attendance this week" chart x-axis renders `Mon Mon Mon Tue Tue ...` because `getTitlesWidget` is called per-pixel without an explicit `interval`. Add `interval: 1` to the `SideTitles` config to fix.
- Quick-action cards on web at desktop resolution have text overflow because the GridView is tuned for phone-sized viewports. Acceptable on actual mobile.

## Enabling Firebase (when needed)

Demo mode is the default. To run against real Firebase:

```bash
dart pub global activate flutterfire_cli  # one-time
flutterfire configure                      # generates lib/firebase_options.dart
flutter run --dart-define=USE_FIREBASE=true
```

The app guards Firebase init in `FirebaseBootstrap.init()` and falls back to demo mode if `firebase_options.dart` is missing.
