# myPesa

## Info

Works by looking for messages from `MPESA` then parses them using regex.

## Help Wanted

If there is anyone who wants to help out with this please feel free to submit issues or PRs :)

## Installation

- [Go to Releases](https://github.com/williamluke4/myPesa/releases) and download the latest `.apk` under assets.
- After installation you may have to close the app after initially opening it to get it to work.

---

## Getting Started 🚀

This project contains 3 flavors:

- development
- staging
- production

To run the desired flavor either use the launch configuration in VSCode/Android Studio or use the following commands:

```sh
# Development
$ flutter run --flavor development --target lib/main_development.dart

# Staging
$ flutter run --flavor staging --target lib/main_staging.dart

# Production
$ flutter run --flavor production --target lib/main_production.dart
```

### JSON Seriablizable code generations

```
flutter pub run build_runner build
```

_\*myPesa works on Android._

---

## Running Tests 🧪

To run all unit and widget tests use the following command:

```sh
$ flutter test --coverage --test-randomize-ordering-seed random
```

To view the generated coverage report you can use [lcov](https://github.com/linux-test-project/lcov).

```sh
# Generate Coverage Report
$ genhtml coverage/lcov.info -o coverage/

# Open Coverage Report
$ open coverage/index.html
```

---
