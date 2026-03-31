<div align="center">

<img src="https://img.shields.io/badge/MyWeather-Flutter%20App-0288d1?style=for-the-badge&logo=flutter&logoColor=white" alt="MyWeather Banner"/>

# 🌤️ MyWeather — Flutter Weather Application

### *Real-Time Weather with Dynamic Particle Animations — Rain · Snow · Clear Sky*

<br/>

[![Live Demo](https://img.shields.io/badge/🌐%20Web%20Demo-GitHub%20Pages-0288d1?style=for-the-badge)](https://manikanta-04.github.io/myweather_app/)

<br/>

[![Flutter](https://img.shields.io/badge/Flutter-Cross%20Platform-02569B?style=flat-square&logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-Language-0175C2?style=flat-square&logo=dart&logoColor=white)](https://dart.dev)
[![CustomPainter](https://img.shields.io/badge/CustomPainter-Particle%20FX-00BCD4?style=flat-square)]()
[![OpenWeather](https://img.shields.io/badge/OpenWeather-API-orange?style=flat-square)](https://openweathermap.org/api)
[![License: MIT](https://img.shields.io/badge/License-MIT-green?style=flat-square)](LICENSE)
[![PRs Welcome](https://img.shields.io/badge/PRs-Welcome-brightgreen?style=flat-square)](CONTRIBUTING.md)

</div>

---

## 🚀 Live Demo

| Platform | Link |
|---|---|
| 🌐 **Web (GitHub Pages)** | [manikanta-04.github.io/myweather_app](https://manikanta-04.github.io/myweather_app/) |
| 📱 **Android APK** | [Download Release APK](https://github.com/Manikanta-04/myweather_app/releases) |

> *(Update with actual deployed URLs and APK release link)*

---

## 🎥 Demo Video

> 📽️ *(Add a Loom / YouTube demo walkthrough here)*
>
> [![Watch Demo](https://img.shields.io/badge/▶%20Watch%20Demo-YouTube-red?style=for-the-badge&logo=youtube)](https://youtube.com)

---

## 🧠 Problem Statement

Most weather apps show data — but fail to create any emotional connection with the actual weather. Current problems:

- 📊 Static number displays — no visual representation of what the weather *feels* like
- 😐 Generic UI — every weather app looks the same (blue sky + sun icon)
- 🌧️ No immersive experience — seeing "Rain: 80%" is not the same as *seeing rain fall*
- 📵 Most beautiful weather UIs require heavy native SDKs or paid frameworks

**Weather is a sensory experience — your app should feel like it too.**

---

## 💡 Solution

**MyWeather** is a Flutter weather app that goes beyond numbers — it renders custom particle animations that match the live weather condition. Rain falls on screen when it's raining outside. Snow drifts when it's cold. Sparkles shimmer on clear days. Built with Flutter's `CustomPainter` and canvas-based particle engine.

> *"Don't just read the weather. Feel it."*

---

## 🖼️ Screenshots

| Rainy Weather | Snowy Weather |
|---|---|
| ![Rain](assets/screenshot1.png) | ![Snow](assets/screenshot2.png) |

| Clear Sky | Dashboard Stats |
|---|---|
| ![Clear](assets/screenshot3.png) | ![Stats](assets/screenshot4.png) |

> 📌 *(Replace with actual screenshots from your app)*

---

## 🏗️ Architecture

```
┌──────────────────────────────────────────────────────────┐
│                      UI LAYER (Flutter)                   │
│     MaterialApp → WeatherScreen → WeatherCard            │
│     Dynamic background color based on weather condition  │
│              Deployed: Android · iOS · Web · Desktop     │
└───────────────────────────┬──────────────────────────────┘
                            │  setState / Future<>
                            ▼
┌──────────────────────────────────────────────────────────┐
│                  ANIMATION LAYER                          │
│          CustomPainter + Canvas + AnimationController    │
│                                                           │
│  RainPainter    → falling droplet particles              │
│  SnowPainter    → drifting snowflake particles           │
│  SparklePainter → twinkling clear-sky particles          │
│                                                           │
│  Condition → Animation selected at runtime               │
└───────────────────────────┬──────────────────────────────┘
                            │  HTTP GET
                            ▼
┌──────────────────────────────────────────────────────────┐
│                  SERVICE LAYER                            │
│              WeatherService (Dart)                        │
│  OpenWeatherMap API → parse JSON → WeatherModel          │
│  Temperature · Humidity · Wind Speed · Description       │
└──────────────────────────────────────────────────────────┘
```

---

## ⚙️ Tech Stack

| Layer | Technology | Purpose |
|---|---|---|
| **Framework** | Flutter | Cross-platform UI framework |
| **Language** | Dart | App logic & state management |
| **Animations** | CustomPainter + Canvas | Particle weather effects |
| **Weather Data** | OpenWeatherMap API | Real-time weather JSON |
| **HTTP Client** | `http` package (Dart) | REST API calls |
| **State** | `setState` / `FutureBuilder` | Reactive UI updates |
| **Build** | Android · iOS · Web · Windows · Linux · macOS | All Flutter platforms |

---

## ✨ Features

### 🌡️ Real-Time Weather Data
- Live **temperature**, **humidity**, **wind speed**, **weather description**
- Fetched from OpenWeatherMap API on every load
- City-based weather lookup

### 🎨 Dynamic Particle Animations (CustomPainter)

| Weather | Animation | Effect |
|---|---|---|
| 🌧️ **Rain** | `RainPainter` | Falling blue droplets with velocity + angle |
| ❄️ **Snow** | `SnowPainter` | Drifting white snowflakes with random drift |
| ✨ **Clear Sky** | `SparklePainter` | Twinkling sparkle particles |

Each animation is built with Flutter's `CustomPainter` + `Canvas` API — no third-party animation libraries.

### 🎨 Dynamic UI Theming
- Background gradient changes automatically based on weather condition
- Rainy → dark blue | Snowy → light blue-grey | Clear → warm gradient

### 📱 Cross-Platform
- Android · iOS · Web · Windows · Linux · macOS
- Single codebase, all platforms via Flutter

---

## 📊 System Design

```
Weather Fetch Flow:

[App launches]
         │
         ▼
[WeatherService.fetchWeather(city)]
         │
         ▼
[GET https://api.openweathermap.org/data/2.5/weather
  ?q=CityName&appid=API_KEY&units=metric]
         │
         ▼
[Parse JSON → WeatherModel]
  { temp, humidity, windSpeed, description, condition }
         │
         ▼
[setState() → UI rebuilds]
  → Background gradient updated
  → Stats card updated
  → Animation selected:
      "Rain" → RainPainter
      "Snow" → SnowPainter
      "Clear" → SparklePainter
```

```
CustomPainter Animation Loop:

[AnimationController(vsync: this)]
         │  ticks at 60fps
         ▼
[CustomPainter.paint(canvas, size)]
  → Update particle positions (x, y, velocity)
  → canvas.drawCircle() / drawOval() per particle
  → Particles that exit screen → reset to top
         │
         ▼
[repaint notifier triggers next frame]
```

**WeatherModel Schema:**
```dart
class WeatherModel {
  final double temperature;   // °C
  final int    humidity;      // %
  final double windSpeed;     // km/h
  final String description;   // "light rain", "clear sky"
  final String condition;     // "Rain" | "Snow" | "Clear"
}
```

---

## 🔄 Workflow

```
1. App launches               →  FutureBuilder triggers WeatherService
2. API call fires             →  OpenWeatherMap returns JSON
3. JSON parsed                →  WeatherModel populated
4. Condition identified       →  "Rain" / "Snow" / "Clear" / other
5. Background gradient set    →  matches weather mood
6. Stats card rendered        →  temp, humidity, wind, description
7. AnimationController starts →  60fps particle loop begins
8. CustomPainter renders      →  rain / snow / sparkles on canvas
9. Particles loop             →  exit bottom → reset to top
```

---

## 📈 Performance & Metrics

| Metric | Value |
|---|---|
| Animation target | 60fps (CustomPainter) |
| Platforms supported | 6 (Android, iOS, Web, Windows, Linux, macOS) |
| API provider | OpenWeatherMap (free tier) |
| Weather conditions | 3 animated (Rain, Snow, Clear) |
| State management | `setState` + `FutureBuilder` |
| Build size (APK) | ~15MB release APK |

---

## 🧪 Testing

```bash
# Run all tests
flutter test

# Run on connected device / emulator
flutter run

# Run on web
flutter run -d chrome

# Build release APK
flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk

# Build for web
flutter build web
# Output: build/web/

# Manual test checklist:
# ✅ App fetches real weather data on launch
# ✅ Rain animation plays when condition = Rain
# ✅ Snow animation plays when condition = Snow
# ✅ Sparkle animation plays when condition = Clear
# ✅ Background gradient matches weather condition
# ✅ Temperature, humidity, wind speed display correctly
# ✅ Works on Android emulator (API 21+)
# ✅ Works on Chrome (flutter run -d chrome)
# ✅ Particles loop (exit bottom → reset to top)
```

---

## 📁 Project Structure

```
myweather_app/
│
├── lib/
│   ├── main.dart                   # App entry point
│   ├── widgets/                    # Reusable UI components
│   ├── animations/                 # CustomPainter weather effects
│   │   ├── rain_painter.dart       # Falling rain droplets
│   │   ├── snow_painter.dart       # Drifting snowflakes
│   │   └── sparkle_painter.dart    # Clear sky sparkles
│   └── services/
│       └── weather_service.dart    # OpenWeatherMap API calls
│
├── android/                        # Android platform files
├── ios/                            # iOS platform files
├── web/                            # Flutter web build output
├── windows/                        # Windows platform files
├── linux/                          # Linux platform files
├── macos/                          # macOS platform files
├── test/                           # Unit + widget tests
│
├── pubspec.yaml                    # Flutter dependencies
├── pubspec.lock                    # Dependency lockfile
├── analysis_options.yaml           # Dart linting rules
└── README.md
```

---

## 🔐 Security

- **API key** stored in `.env` or as a constant — never committed to the repository
- **No user data collected** — city query only, no personal data stored
- **HTTPS only** — all API calls over secure connection

---

## ⚙️ Local Development Setup

### Prerequisites

- Flutter SDK `3.0+` — [Install Flutter](https://flutter.dev/docs/get-started/install)
- Dart `3.0+` (bundled with Flutter)
- Android Studio / VS Code with Flutter extension
- OpenWeatherMap API key (free) — [Get yours](https://openweathermap.org/api)

### 1️⃣ Clone the Repository

```bash
git clone https://github.com/Manikanta-04/myweather_app.git
cd myweather_app
```

### 2️⃣ Install Dependencies

```bash
flutter pub get
```

### 3️⃣ Add Your API Key

In `lib/services/weather_service.dart`, replace:
```dart
const String apiKey = 'YOUR_OPENWEATHERMAP_API_KEY';
```

### 4️⃣ Run the App

```bash
flutter run              # Default connected device
flutter run -d chrome    # Web browser
flutter run -d android   # Android emulator
```

---

## 🔑 Environment Variables

```env
OPENWEATHER_API_KEY=your_openweathermap_api_key
```

> ⚠️ Never commit your API key. Add it to `.gitignore` or use Flutter's `--dart-define` flag:
> ```bash
> flutter run --dart-define=API_KEY=your_key_here
> ```

---

## 📱 Building & Releasing

### Android APK

```bash
# Debug
flutter build apk --debug

# Release (recommended)
flutter build apk --release
# → build/app/outputs/flutter-apk/app-release.apk
```

### Web

```bash
flutter build web
# → build/web/ (deploy to GitHub Pages or Vercel)
```

### Windows / Linux / macOS

```bash
flutter build windows
flutter build linux
flutter build macos
```

---

## 🚀 Deployment

### Web → GitHub Pages

```bash
flutter build web
# Copy build/web/ contents to gh-pages branch
# OR use GitHub Actions for auto-deploy
```

### Android → Google Play
1. Sign the APK with a keystore
2. Build: `flutter build appbundle --release`
3. Upload `.aab` to Google Play Console

---

## 🔮 Future Improvements

- [ ] 📅 Hourly & 7-day weather forecast
- [ ] 📍 Auto-detect location via GPS (`geolocator` package)
- [ ] 🌙 Light / dark theme toggle
- [ ] 🔔 Weather alerts and push notifications
- [ ] 🎬 Smooth screen transition animations
- [ ] ⛈️ More conditions — Thunderstorm, Foggy, Cloudy animations
- [ ] 🌍 Multiple city support with favorites list
- [ ] 🌐 Multi-language support

---

## 🤝 Contributing

Contributions are welcome!

```bash
git checkout -b feature/your-feature-name
git commit -m "feat: describe your change"
git push origin feature/your-feature-name
# Open a Pull Request
```

Please follow [Conventional Commits](https://www.conventionalcommits.org/) and run `flutter test` before submitting.

---

## 👨‍💻 Author

**Manikanta Naripeddi** — Flutter & Full Stack Developer

[![GitHub](https://img.shields.io/badge/GitHub-Manikanta--04-181717?style=flat-square&logo=github)](https://github.com/Manikanta-04)
[![LinkedIn](https://img.shields.io/badge/LinkedIn-Manikanta%20Naripeddi-0077b5?style=flat-square&logo=linkedin)](https://www.linkedin.com/in/manikanta-naripeddi-4326232a5/)

---

## 📜 License

Licensed under the **MIT License** — modify, distribute, and use freely. See [LICENSE](LICENSE) for details.

---

## 🙌 Acknowledgements

- [Flutter](https://flutter.dev/) — Cross-platform UI framework
- [OpenWeatherMap](https://openweathermap.org/api) — Free weather API
- [Dart CustomPainter](https://api.flutter.dev/flutter/rendering/CustomPainter-class.html) — Canvas-based particle rendering

---

<div align="center">

**Built with ❤️ for weather enthusiasts who want to *feel* the forecast**

⭐ **Star this repo** if MyWeather impressed you!

[![GitHub Stars](https://img.shields.io/github/stars/Manikanta-04/myweather_app?style=social)](https://github.com/Manikanta-04/myweather_app)

---

*🌤️ Don't just read the weather. Feel it.*

</div>
