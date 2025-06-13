# RickStar: A Rick and Morty Explorer iOS App

## 🚀 Description

RickStar is an iOS application built with SwiftUI that allows users to explore characters from the popular TV show "Rick and Morty." Users can browse through a list of characters, view detailed information about each character, and enjoy a seamless experience with features like image caching, pagination, and real-time search.

## ✨ Features

*   **Character List**:
    *   Displays characters with their image, name, and status.
    *   **Infinite Scrolling & Pagination**: Automatically loads more characters as the user scrolls (page-by-page loading).
    *   **Search**: Real-time search functionality for characters by name, with built-in throttling (400ms) to optimize performance.
    *   **Prefetching**: Proactively loads data for upcoming characters (when within 5 items of the list's end) to provide a smoother browsing experience.
*   **Character Details**:
    *   Shows comprehensive information about a selected character, including species, type, origin, location, and a list of episodes they appeared in.
*   **Image Caching**:
    *   Utilizes an in-memory cache (`CacheKit`'s `MemoryImageCache`) for efficiently loading and storing character images, reducing network requests and improving performance.
*   **Responsive UI**:
    *   Adapts to network connectivity changes (monitored by `NetworkKit`), providing feedback to the user and attempting to refresh data on reconnection.
    *   Clean and intuitive user interface built with SwiftUI and custom Design System components.
*   **Localization**:
    *   Supports string localization using `NSLocalizedString` (extensions in `String+.swift`) for broader accessibility (though specific translations might need to be added).

## 🛠️ Technologies & Architecture

*   **UI Framework**: SwiftUI
*   **Architecture**: Model-View-ViewModel (MVVM)
    *   ViewModels (e.g., `CharactersListViewModel`, `CharacterDetailViewModel`) are `@Observable` and manage state and business logic for their respective Views.
    *   Domain logic and data transformation are handled within ViewModels and Data layer mappers. (Note: Dedicated UseCase classes in `RickMortyDomain` are not explicitly implemented; ViewModels currently fulfill this role by interacting directly with repositories).
*   **Modularity**: Swift Package Manager (SPM) is used to organize the project into distinct, reusable modules.
*   **Reactive Programming**: Combine framework is used for handling asynchronous operations, particularly for network connectivity monitoring in `NetworkKit` and in ViewModels.
*   **Networking**:
    *   `NetworkKit` provides a robust, generic client (`URLSessionClient` conforming to `NetworkClient`) for making API calls using `async/await`.
    *   It includes network monitoring (`NetworkPathMonitor`) to adapt to connectivity changes.
*   **Styling & UI**:
    *   `DesignSystem` package provides a collection of reusable UI components (e.g., `SearchBarView`) and styling constants.
    *   Custom SwiftUI `ViewModifier` extensions (`View+.swift`) are used for consistent styling across the app (e.g., status borders, rounded borders, navigation bar styles).
*   **Constants & Utilities**:
    *   Centralized constants for UI elements (`Constants.swift` - e.g., `CharacterStatus` enum with colors).
    *   Helpful extensions for `Image` (SF Symbol fallback), `String` (localization), and `View`.

## 📦 Modules

The project is structured into several Swift Packages to promote separation of concerns and maintainability:

*   **`RickStar` (Main Application Target)**
    *   **Description**: The main iOS application target. It contains the app's entry point (`RickStarApp.swift`), navigation logic (`Router.swift`), ViewModels (e.g., `CharactersListViewModel`, `CharacterDetailViewModel`), and SwiftUI Views (e.g., `CharactersListView`, `CharacterDetailView`).
    *   **Responsibilities**: UI presentation, user interaction, state management, and coordination between different modules.

*   **`CacheKit`**
    *   **Description**: Provides image caching capabilities.
    *   **Implementation**: Uses an in-memory cache (`MemoryImageCache` built on `NSCache`) to store and retrieve images efficiently based on URLs.
    *   **Key Files**: `ImageCache.swift`

*   **`DesignSystem`**
    *   **Description**: A dedicated module for UI components, styling guidelines, and resources (e.g., `Media.xcassets`).
    *   **Responsibilities**: Ensures a consistent look and feel across the application by providing reusable UI elements (e.g., `SearchBarView`, `PlaceholderTextField`) and defining common styles.
    *   **Key Files**: `Components/SearchBarView.swift` (example)

*   **`NetworkKit`**
    *   **Description**: Manages all network communication for the application.
    *   **Responsibilities**: Provides a generic `NetworkClient` (`URLSessionClient`) for making API requests, handles `Endpoint` definitions, defines custom `NetworkError` types for error management, and includes a `NetworkPathMonitor` (using `NWPathMonitor` and Combine) to observe and react to network connectivity changes.
    *   **Key Files**: `NetworkClient.swift`, `NetworkMonitor.swift`, `Endpoint.swift`, `NetworkClient+Error.swift`

*   **`RickMortyData`**
    *   **Description**: The data layer of the application, responsible for fetching and managing data related to Rick and Morty characters, episodes, etc., from the API.
    *   **Dependencies**: `NetworkKit` (for API calls), `RickMortyDomain` (for domain models).
    *   **Responsibilities**: Implements repository patterns (e.g., `DefaultCharacterRepository`, `DefaultEpisodeRepository`, `DefaultCharactersImageRepository`) to abstract data sources. Contains embedded mapping logic to transform Data Transfer Objects (DTOs) from the API into domain models defined in `RickMortyDomain`. Also handles mapping network errors to domain errors.
    *   **Key Files**: `Repositories/DefaultCharacterRepository.swift`, `Repositories/DefaultEpisodeRepository.swift`, `RickMortyRoute.swift` (defines API endpoints)

*   **`RickMortyDomain`**
    *   **Description**: Defines the core business logic (implicitly, as ViewModels currently handle this), repository protocols, and domain models for the Rick and Morty features.
    *   **Responsibilities**: Contains the definitions for primary data structures like `RickCharacter`, `Episode`, `CharacterPage`, `PageInfo`, `ROrigin`, `RLocation`. This layer ensures that the business rules are independent of the UI and data fetching mechanisms. Defines repository contracts (e.g., `CharacterRepository`, `EpisodeRepository`).
    *   **Key Files**: `RickCharacter.swift` (contains `RickCharacter`, `CharacterPage`, etc.), `Episode.swift`, `CharacterRepository.swift`, `DomainError.swift`

## ⚙️ Building and Running

1.  Clone the repository.
2.  Open `RickStar.xcodeproj` in Xcode.
3.  Select a simulator or a connected device.
4.  Build and run the project (Cmd+R).

No special environment variables or setup steps are required beyond a standard Xcode installation.

## ✅ Testing

The project includes a suite of tests to ensure functionality and stability:

*   **Unit Tests**:
    *   **`CacheKitTests`**: (`ImageCacheTests.swift`) Verifies the image caching logic.
    *   **`NetworkKitTests`**: (`NetworkKitTests.swift`, `NetworkMonitorTests.swift`) Tests networking functionalities, including the network monitor.
    *   **`RickMortyDataTests`**: (`DefaultCharacterRepositoryTests.swift`, etc.) Comprehensive tests covering data repositories (characters, images, episodes), API route construction, and error mapping. This module has good test coverage.
    *   **`RickStarTests`**: (`RickStarTests.swift`) Unit tests for the main application logic, potentially including ViewModels.
*   **UI Tests**:
    *   **`RickStarUITests`**: (`RickStarUITests.swift`) Conducts UI tests to verify user flows and interactions within the app.
    *   **`RickStarUITestsLaunchTests`**: (`RickStarUITestsLaunchTests.swift`) Ensures the app launches correctly.

