# 🎬 FlixGo — Premium Movie & Series Streaming App

**FlixGo** is a modern, responsive streaming web and mobile application inspired by Netflix, built from scratch using **Flutter** and **Dart**.

Designed with rich aesthetics, FlixGo features a cinematic dark theme (`#09090D`), signature red branding (`#E50914`), responsive layouts for Android phones, tablets, and desktop browsers, dedicated multi-genre search, and persistent local storage for bookmarked titles.

---

## ✨ Features

- **Cinematic Dark Theme**: Crafted with dark backgrounds (`#09090D`), surface card styling (`#161622`), and signature Netflix-inspired red accents (`#E50914`).
- **Responsive Layout**: Adapts gracefully across mobile screens (<650px), tablets (650–1100px), and wide desktop browser viewports (≥1100px).
- **Featured Hero Spotlight**: Large cinematic hero banner with backdrop vignettes, rating badges, release metadata, synopsis, and quick-action buttons.
- **Horizontal Carousels**:
  - 🔥 *Trending Now*
  - ⭐ *Popular on FlixGo*
  - 🏆 *Top Rated Classics*
  - 🤖 *Sci-Fi & Cyberpunk*
  - Desktop arrow navigation and smooth touch-scrolling.
- **Dedicated Multi-Attribute Search Screen**:
  - Real-time search across titles, directors, actors, genres, and overviews.
  - Combined multi-genre filter chips (e.g. *Action* + *Sci-Fi* + *Adventure*).
  - Sorting options: *Top Rated*, *Release Year*, and *Title (A-Z)*.
  - Polished empty state with quick *Reset All Filters* action.
- **Persistent "My List"**:
  - Bookmarked movie IDs are saved locally to the device using `shared_preferences`.
  - State is restored after page reloads, browser refreshes, and app restarts.
- **Detailed Movie Modals**:
  - High-res backdrops, full cast list, director, duration, quality badges, and age ratings.
- **Interactive Trailer Preview**:
  - Preview player with play/pause controls, timecode scrubber, and volume toggle.
  - Honest preview transparency regarding configured demo streams vs. production streaming sources.
- **Demo User Profile**:
  - Displays user avatar, VIP 4K plan status, viewing statistics, and playback settings.

---

## 🏗️ Project Architecture & Folder Structure

```
flixgo/
├── android/                    # Native Android Gradle configuration & manifest
├── web/                        # Web host files, manifest, and icons
├── lib/
│   ├── main.dart               # Application entry point & theme initialization
│   ├── core/
│   │   ├── theme/
│   │   │   ├── app_colors.dart # Central color palette & gradient definitions
│   │   │   └── app_theme.dart  # Material 3 dark theme configuration
│   │   └── utils/
│   │       └── responsive.dart # Device breakpoint helpers (Mobile, Tablet, Desktop)
│   ├── models/
│   │   └── movie.dart          # Movie entity model with serialization helpers
│   ├── data/
│   │   └── demo_movies.dart    # Curated cinematic catalog with CDN poster URLs
│   ├── services/
│   │   └── favorites_service.dart # Persistent storage manager (SharedPreferences)
│   ├── screens/
│   │   ├── home_screen.dart    # 5-tab responsive navigation coordinator
│   │   └── search_screen.dart  # Dedicated search, multi-genre filters & sorting
│   └── widgets/
│       ├── flixgo_app_bar.dart # Responsive top navigation with logo & search
│       ├── hero_banner.dart    # Spotlight hero header with action buttons
│       ├── movie_card.dart     # Poster card with hover zoom, rating & bookmark
│       ├── movie_carousel_section.dart # Horizontal scrolling movie carousel
│       ├── movie_details_dialog.dart   # Synopsis, director, and cast dialog
│       ├── network_movie_image.dart    # Network image loader with fallback placeholder
│       ├── profile_dialog.dart         # VIP demo profile & statistics
│       └── trailer_preview_dialog.dart # Interactive trailer preview player
└── test/
    ├── favorites_service_test.dart # Unit tests for persistent local storage
    └── widget_test.dart            # Automated smoke, search, and navigation tests
```

---

## 🚀 Getting Started

### Prerequisites

- **Flutter SDK**: 3.44.0 or higher ([Install Flutter](https://docs.flutter.dev/get-started/install))
- **Dart SDK**: 3.12.0 or higher
- **Web Browser**: Google Chrome or Microsoft Edge
- **Android Device / Emulator**: Android Studio with SDK 34+ and USB debugging enabled (optional for mobile testing)

---

### Installation & Run

1. **Clone the repository**:
   ```bash
   git clone https://github.com/<your-username>/flixgo.git
   cd flixgo
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Run on Web (Chrome or Edge)**:
   ```bash
   # Launch on Microsoft Edge
   flutter run -d edge

   # Or launch on Google Chrome
   flutter run -d chrome
   ```

4. **Run on Android Phone or Emulator**:
   ```bash
   # List available connected devices
   flutter devices

   # Run on your connected Android device
   flutter run -d android
   ```

---

## 🧪 Testing & Quality Checks

Run all automated tests, static analysis, and code formatting:

```bash
# 1. Format code according to official Dart standards
dart format .

# 2. Run static analysis (must report 0 issues)
flutter analyze

# 3. Execute all unit and widget tests
flutter test

# 4. Compile production Web bundle
flutter build web

# 5. Build production Android APK
flutter build apk --release
```

---

## 📦 Pushing to GitHub

To push this project to your GitHub account:

1. **Initialize Git (if not already initialized)**:
   ```bash
   git init
   git add .
   git commit -m "feat: complete FlixGo streaming application (Stages 1-5)"
   ```

2. **Create a new repository on GitHub**:
   - Go to [github.com/new](https://github.com/new)
   - Name it `flixgo`
   - Leave it empty (without initializing with a README or license)

3. **Link your local repository and push**:
   ```bash
   git branch -M main
   git remote add origin https://github.com/<your-username>/flixgo.git
   git push -u origin main
   ```

---

## 📄 License & Attribution

- Built as an educational project with Flutter & Dart.
- Movie photography and artwork are sourced from reliable public CDNs (Unsplash and Wikimedia Commons) for demo and educational purposes.
- All copyrights and trademarks belong to their respective creators and production studios.
