# sales-system-warehouse-mobile

Warehouse Inventory Management System — Flutter Android app for the Sales System project.

## Features

- Product management (create, edit, delete, search, filter by category)
- Stock In / Stock Out with movement tracking
- Inventory check with adjustment movements
- Full movement history with filters
- Bilingual UI: Uzbek (default) and Russian
- Language switching from Settings
- 3 user roles: Admin, Warehouse Manager, Warehouse Worker
- Clean architecture + Riverpod state management
- Ready for backend API integration (PostgreSQL)

---

## Prerequisites

| Tool | Notes |
|---|---|
| Flutter SDK | `C:\flutter\flutter` (or your installation path) |
| Dart SDK | Included with Flutter (>=3.6.1) |
| Android Studio | For AVD Manager / emulator only |
| VS Code | With Dart and Flutter extensions |
| Git | Required by Flutter SDK |

---

## Setup on Windows

### 1. Verify Flutter installation

Open a terminal and run:

```bash
flutter doctor
```

All items should show a checkmark.

### 2. Install VS Code extensions

- **Dart** (Dart-Code.dart-code)
- **Flutter** (Dart-Code.flutter)

### 3. Open the project in VS Code

```bash
cd C:\Users\Abdurasul\Desktop\warehouse
code .
```

### 4. Install dependencies

```bash
flutter pub get
```

### 5. Generate localization files

```bash
flutter gen-l10n
```

This generates `lib/l10n/app_localizations.dart` from the `.arb` files.

---

## Running on Android Emulator

### Create an emulator (one time)

1. Open Android Studio
2. Go to **Tools > Device Manager**
3. Click **Create Virtual Device**
4. Choose **Pixel 6** with **API 33** (Android 13)
5. Click **Finish** and start the emulator

### Run the app from VS Code

1. Start your Android emulator first
2. Open VS Code in the project folder
3. Press **F5** or go to **Run > Start Debugging**
4. Select **"sales-system-warehouse (debug)"**

### Run from terminal

```bash
flutter run
```

---

## Mock Login Credentials

| Role | Username | Password |
|---|---|---|
| Admin | `admin` | `admin123` |
| Warehouse Manager | `manager` | `manager123` |
| Warehouse Worker | `worker` | `worker123` |

---

## Project Structure

```
lib/
+-- main.dart                    - App entry point
+-- app.dart                     - MaterialApp + GoRouter
+-- core/
|   +-- constants/               - Route names, app config
|   +-- theme/                   - Colors, typography, ThemeData
|   +-- utils/                   - Enums, validators, extensions
|   +-- widgets/                 - Shared reusable widgets
+-- features/
|   +-- auth/                    - Login, user session
|   +-- dashboard/               - Home screen with action cards
|   +-- products/                - Product CRUD, list, detail
|   +-- stock/                   - Stock In / Stock Out
|   +-- inventory/               - Inventory check and adjustment
|   +-- movements/               - Movement history
|   +-- settings/                - Language switch, profile, logout
+-- shared/
    +-- models/                  - Data models (match PostgreSQL schema)
    +-- services/                - Auth, barcode placeholder
    +-- mock_data/               - In-memory mock database
```

Each feature follows clean architecture:
- `domain/` - abstract repos, use cases (pure Dart)
- `data/` - concrete repos, mock datasources
- `presentation/` - Riverpod providers, pages, widgets

---

## Architecture

- **State management**: Riverpod 2.x (AsyncNotifier, Notifier)
- **Navigation**: go_router with ShellRoute + auth redirect
- **Localization**: Flutter gen-l10n with .arb files
- **Mock data**: MockDatabase singleton (in-memory, resets on app restart)

### Critical Business Rule

Stock quantity is NEVER changed directly. Every change creates a StockMovement first:

```
1. Get current quantity
2. Validate (qty > 0; OUT: qty <= current)
3. Create StockMovement (before/after quantities recorded)
4. Update product current_quantity
5. Invalidate Riverpod providers -> UI refreshes
```

---

## Localization

Edit ARB files:
- `lib/l10n/app_uz.arb` - Uzbek (default)
- `lib/l10n/app_ru.arb` - Russian

After editing, regenerate:

```bash
flutter gen-l10n
```

Switch language in the Settings screen. Preference is persisted via SharedPreferences.

---

## TODO: Backend Integration

When the PostgreSQL backend is ready:

1. Add `dio` or `http` to pubspec.yaml
2. Create `*_remote_datasource.dart` in each feature's `data/datasources/`
3. Update `*_repository_impl.dart` to call remote datasource
4. Replace mock auth with real JWT auth in `AuthRepositoryImpl`
5. Store/refresh JWT tokens in `local_storage_service.dart`

No changes needed in `domain/` or `presentation/` layers.
Database schema matches model classes exactly (snake_case JSON keys).

---

## TODO: Barcode Integration

1. Add `mobile_scanner: ^5.x` to pubspec.yaml
2. Open `lib/shared/services/barcode_service.dart`
3. Set `_scannerEnabled = true`
4. Implement `scanBarcode()` with MobileScannerController
5. Add to AndroidManifest.xml:
   ```xml
   <uses-permission android:name="android.permission.CAMERA" />
   ```

---

## Useful Commands

```bash
flutter pub get          # Install packages
flutter gen-l10n         # Generate localization
flutter analyze          # Check for issues
flutter run              # Run on emulator/device
flutter build apk        # Build debug APK
flutter build apk --release  # Build release APK
```
