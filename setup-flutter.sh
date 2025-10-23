#!/bin/bash
set -e

echo "Setting up Flutter for Avida-Droid..."

# Install Flutter if not already installed
if ! command -v flutter &> /dev/null; then
    echo "Flutter not found. Installing Flutter..."

    # Download and install Flutter
    cd ~
    git clone https://github.com/flutter/flutter.git -b stable --depth 1

    # Add Flutter to PATH
    export PATH="$PATH:$HOME/flutter/bin"

    # Add to bashrc for persistence
    if ! grep -q "flutter/bin" ~/.bashrc; then
        echo 'export PATH="$PATH:$HOME/flutter/bin"' >> ~/.bashrc
    fi

    echo "Flutter installed successfully!"
else
    echo "Flutter is already installed."
fi

# Run Flutter doctor to check setup
echo "Running Flutter doctor..."
flutter doctor

# Get Flutter dependencies
echo "Getting Flutter dependencies..."
cd /home/user/avida-droid
flutter pub get

echo "Flutter setup complete!"
echo "You can now run:"
echo "  flutter test       - Run tests"
echo "  flutter analyze    - Analyze code"
echo "  flutter run        - Run the app"
