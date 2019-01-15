# Calcifer 🔥
macOS menubar app for controlling external display brightness. Based on the great work in the [DDCCTL repo](https://github.com/kfix/ddcctl).

## Building from source

### Prerequisites
To build this project you need [Carthage](https://github.com/Carthage/Carthage) and [SwiftLint](https://github.com/realm/SwiftLint), both available through [HomeBrew](https://brew.sh):

```bash
$ brew install carthage
$ brew install swiftlint
```

### Setup
To fetch and build the project's dependencies, you just need to run:
```bash
$ make setup
```

This will in turn perform:

```bash
$ git submodule init                  # initializes the ddcctl dependency
$ carthage bootstrap --platform macOS # installs other dependencies
```

Once the dependencies are installed, open the `.xcodeproj` with Xcode - and you're good to go! 🙂
