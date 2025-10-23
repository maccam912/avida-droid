# Claude Development Guide for Avida-Droid

This document provides setup instructions and development guidelines for working on Avida-Droid.

## First-Time Setup

### 1. Set Up Flutter

Run the setup script to install Flutter and dependencies:

```bash
chmod +x setup-flutter.sh
./setup-flutter.sh
```

This script will:
- Install Flutter SDK (if not already installed)
- Add Flutter to your PATH
- Run Flutter doctor to verify installation
- Get all project dependencies

### 2. Manual Setup (Alternative)

If you prefer to set up manually:

```bash
# Install Flutter
git clone https://github.com/flutter/flutter.git -b stable --depth 1 ~/flutter
export PATH="$PATH:$HOME/flutter/bin"

# Navigate to project
cd /home/user/avida-droid

# Get dependencies
flutter pub get

# Verify setup
flutter doctor
```

## Development Workflow

### Running Tests

```bash
flutter test
```

### Analyzing Code

```bash
flutter analyze
```

### Building the App

```bash
# Debug APK
flutter build apk --debug

# Release APK
flutter build apk --release
```

### Running the App

```bash
# On connected device/emulator
flutter run
```

## Project Structure

- `lib/` - Main application code
  - `main.dart` - App entry point
  - `screens/` - UI screens
  - `models/` - Data models
  - `widgets/` - Reusable widgets
- `test/` - Test files
- `.github/workflows/` - CI/CD workflows

## CI/CD

The project uses GitHub Actions for automated builds and tests. The workflow:
1. Checks out code
2. Sets up Java 17 and Flutter 3.24.5
3. Gets dependencies
4. Analyzes code
5. Runs tests
6. Builds debug APK
7. Uploads artifacts

## Troubleshooting

### Tests Failing

If widget tests fail, ensure you're using `pumpAndSettle()` after `pumpWidget()` to allow all animations and async operations to complete.

### Flutter Not Found

Make sure Flutter is in your PATH:
```bash
export PATH="$PATH:$HOME/flutter/bin"
```

### Dependencies Out of Date

Update dependencies:
```bash
flutter pub get
flutter pub upgrade
```
