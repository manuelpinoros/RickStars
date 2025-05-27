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
* **Localization** support (English, Spanish)

Enjoy exploring the multiverse of Rick & Morty with a swift, modular SwiftUI experience!
