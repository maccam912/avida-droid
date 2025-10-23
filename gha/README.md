# GitHub Actions Workflows

This folder contains GitHub Actions workflow files for the Avida-Droid project.

## Installation

To activate these workflows, move them to the `.github/workflows/` directory:

```bash
mkdir -p .github/workflows
cp gha/*.yml .github/workflows/
git add .github/workflows/
git commit -m "Add GitHub Actions workflows"
git push
```

## Available Workflows

### build-apk.yml

Builds the Android APK in debug mode and uploads it as an artifact.

**Triggers:**
- Push to main, master, or any claude/* branch
- Pull requests to main or master
- Manual workflow dispatch

**What it does:**
1. Checks out the code
2. Sets up Java 17 (required for Android builds)
3. Sets up Flutter 3.24.5 (stable channel)
4. Installs dependencies with `flutter pub get`
5. Runs static analysis with `flutter analyze`
6. Runs tests with `flutter test`
7. Builds the debug APK with `flutter build apk --debug`
8. Uploads the APK as two artifacts:
   - `avida-droid-debug-apk` - Latest build (retained for 30 days)
   - `avida-droid-debug-<commit-sha>` - Specific commit build (retained for 7 days)

**Downloading the APK:**

After the workflow runs successfully:
1. Go to the Actions tab in your GitHub repository
2. Click on the workflow run
3. Scroll down to the "Artifacts" section
4. Download the `avida-droid-debug-apk` artifact
5. Extract the ZIP file to get the APK
6. Install on your Android device

**Note:** Debug APKs are larger than release APKs and include debugging symbols. For production use, you'd want to create a release build with signing keys.

## Future Enhancements

You could add additional workflows for:
- Building release APKs (requires signing keys as secrets)
- Running integration tests
- Deploying to Google Play Store
- Running on different Flutter versions
- Building for iOS (requires macOS runner)
