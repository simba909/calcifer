# Calcifer
macOS menubar app for controlling external display brightness. Based on the great work in the [DDCCTL repo](https://github.com/kfix/ddcctl).

## Building from source

### Prerequisites
To build this project you need [Carthage](https://github.com/Carthage/Carthage) and [SwiftLint](https://github.com/realm/SwiftLint), both available through [HomeBrew](https://brew.sh):

```bash
$ brew install carthage swiftlint
```

### Setup
```bash
$ git submodule init                  # initializes the ddcctl dependency
$ carthage bootstrap --platform macOS # installs other dependencies
```

Open the `.xcodeproj` with Xcode, and you're good to go! 🙂
