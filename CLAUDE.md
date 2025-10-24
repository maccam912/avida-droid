# Claude Development Guide for Avida-Droid

This document provides setup instructions and development guidelines for working on Avida-Droid.

## First-Time Setup

### Set Up Flutter

Run these commands to install Flutter and set up the project:

```bash
# Check if Flutter is already installed
if ! command -v flutter &> /dev/null; then
    echo "Flutter not found. Installing Flutter..."

    # Download and install Flutter (stable branch)
    cd ~
    git clone https://github.com/flutter/flutter.git -b stable --depth 1

    # Add Flutter to PATH for this session
    export PATH="$PATH:$HOME/flutter/bin"

    # Add to bashrc for persistence
    if ! grep -q "flutter/bin" ~/.bashrc; then
        echo 'export PATH="$PATH:$HOME/flutter/bin"' >> ~/.bashrc
    fi

    echo "Flutter installed successfully!"
else
    echo "Flutter is already installed."
fi

# Run Flutter doctor to verify setup and show what needs to be configured
echo "Running Flutter doctor to verify installation..."
flutter doctor

# Navigate to project directory and get dependencies
echo "Getting Flutter dependencies..."
cd /home/user/avida-droid
flutter pub get

echo "Flutter setup complete!"
echo "You can now run:"
echo "  flutter test       - Run tests"
echo "  flutter analyze    - Analyze code"
echo "  flutter run        - Run the app"
```

## Development Workflow

### Before Finishing Any Task

**ALWAYS** run `flutter analyze` before considering a task complete:

```bash
flutter analyze
```

This command checks for code quality issues, unused variables, and other potential problems. All warnings and errors must be addressed before finishing.

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
