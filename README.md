# RickStars

RickStars is a demo iOS app that leverages the free Rick & Morty API to display detailed information about characters from the series.

## Features

* **Infinite-scroll list** of characters with on‑demand prefetching and in‑memory image caching.
* **Search** by character name directly against the API.
* **Status indicator**: circular colored border (green = alive, red = dead, yellow = unknown) around each character’s avatar.
* **Character detail screen** showing:

  * Full name, status, species, type
  * Origin and last known location
  * Total number of episodes and a scrollable list of episode codes and titles
* **Modular architecture** via Swift Package Manager:

  * **NetworkKit**: generic async/await HTTP client with robust error handling
  * **CacheKit**: simple in‑memory image cache
  * **RickMortyDomain**: core models and repository protocols
  * **RickMortyData**: concrete repository implementations using NetworkKit
* **MVVM** combined with a **Router/Coordinator** pattern for clean navigation
* **Localization** support (English, French, Spanish)


## Project Structure

```
.
├── Packages
│   ├── CacheKit
│   │   └── Sources
│   ├── NetworkKit
│   │   └── Sources
│   ├── RickMortyData
│   │   └── Sources
│   └── RickMortyDomain
│       └── Sources
├── RickStar
│   ├── Assets.xcassets
│   │   ├── AccentColor.colorset
│   │   └── AppIcon.appiconset
│   ├── Declarations
│   │   └── Extensions
│   ├── Navigation
│   ├── Preview Content
│   │   └── Preview Assets.xcassets
│   ├── Resources
│   ├── ViewModels
│   └── Views
│       └── Components
├── RickStarTests
└── RickStarUITests
```
## Running NetworkKit Tests

To run the NetworkKit tests, follow these steps:

1. Open a terminal and navigate to the NetworkKit package directory:
   ```bash
   cd Packages/NetworkKit
   ```

2. Run the tests using Swift Package Manager:
   ```bash
   swift test
   ```

   This will execute all tests in the NetworkKit package and report the results.

3. If you want to run a specific test, you can use the `--filter` option. For example:
   ```bash
   swift test --filter NetworkKitTests.testCharacterEndpointURLRequest
   ```

4. For more detailed output, you can add the `--verbose` flag:
   ```bash
   swift test --verbose
   ```

5. If you encounter any issues, ensure that your Swift version is compatible (Swift 5.9 or later) and that all dependencies are correctly set up in your `Package.swift` file.
