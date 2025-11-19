🌤️ MyWeather App

A clean, modern, and visually rich Flutter Weather Application that displays real-time weather conditions with beautiful animated effects. The app uses custom particle animations to represent rain, snow, and clear sky for an immersive weather-viewing experience.

✨ Features

Real-Time Weather Updates
Fetches live temperature, humidity, wind speed, and weather descriptions.

Dynamic Weather Animations

🌧️ Rain Animation

❄️ Snow Animation

✨ Clear Sky Sparkles
Each created using CustomPainter and canvas-based particle effects.

Clean & Simple UI
Designed to be fast, responsive, and pleasant to use.

Cross-Platform Flutter Project
Runs on Android, iOS, Web, Windows, Linux, and macOS (Flutter-supported platforms).

📸 Screenshots

Add your screenshots here:

assets/
├── screenshot1.png
├── screenshot2.png
└── screenshot3.png


Example (after uploading):

![Weather App Screenshot 1](assets/screenshot1.png)

🚀 Getting Started
1️⃣ Clone the Repository
git clone https://github.com/Manikanta-04/myweather_app.git
cd myweather_app

2️⃣ Install Dependencies
flutter pub get

3️⃣ Run the App
flutter run

📱 Building APK
Debug APK
flutter build apk --debug

Release APK (recommended)
flutter build apk --release


APK will be created in:

build/app/outputs/flutter-apk/app-release.apk

🧩 Project Structure
lib/
 ├── main.dart               # Main entry point
 ├── widgets/                # UI components (optional)
 ├── animations/             # CustomPainter weather animations
 └── services/               # Weather API integration

🛠️ Technologies Used

Flutter (Dart)

CustomPainter & Canvas

Weather API integration (OpenWeather or any API you use)

Material Design Widgets

🎯 Future Improvements

Add hourly & weekly forecast

Add light/dark themes

Add geolocation auto-detect

Add weather alerts

Add beautiful UI transitions

🤝 Contributing

Pull requests are welcome!
If you want to contribute, follow these steps:

git checkout -b feature-name
git commit -m "Added new feature"
git push origin feature-name

📄 License

This project is licensed under the MIT License.
You can modify, distribute, and use freely.

❤️ Support

If you like this project, consider giving it a ⭐ star on GitHub!
