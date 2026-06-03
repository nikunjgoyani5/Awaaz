# eagle_eye

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


Build runner command
dart run build_runner build
flutter pub run build_runner build

Branch.IO config
When app live that time must check android manifest.xml file <meta-data android:name="io.branch.sdk.TestMode" android:value="false" /> always false.

also check firebase crash record or not.
Correct code : 
if (isLiveMode) { 