# Country Weather Explorer

A Flutter mobile application for exploring countries and viewing detailed country information along with weather information based on the country's geographical coordinates.

## Features

### 🌍 Countries Explorer
- Fetches countries from the REST Countries API.
- Supports API pagination.
- Loads all available country records.
- Search countries by name.
- Displays:
  - Country flag
  - Country name
  - Official country name
  - Country code
  - Capital
  - Region
  - Subregion
  - Latitude
  - Longitude
  - Population
  - Area
  - Currencies
  - Languages
  - Timezones
  - Continents
  - Bordering countries
  - Independence status
  - UN membership
  - Driving side
  - International dialing information
  - Top-level domains

### 🏳️ Country Details
Selecting a country opens a detailed country screen containing the available information returned by the API.

The application handles missing API fields gracefully by displaying `N/A` instead of causing the application to crash.

### 🌤️ Weather
From the country details screen, users can open the weather screen using the country's latitude and longitude.

The weather functionality is designed to retrieve weather for the selected country's actual coordinates rather than displaying the same weather for every country.

### 🗺️ Map
The country coordinates can be used to display the selected country's location on a map.

### 🔎 Search
Users can search the complete country list using the search field.

### 📱 Responsive UI
The application uses a modern dark/glass-style interface with:
- Gradient/glow backgrounds
- Rounded cards
- Country flag display
- Smooth scrolling
- Material UI components

---

## Tech Stack

- **Flutter**
- **Dart**
- **BLoC / flutter_bloc**
- **REST API**
- **HTTP**
- **Firebase**
- **flutter_dotenv**
- REST Countries API
- Weather API
- Map integration

---

## Project Architecture

The application follows a feature-based architecture.

```text
lib/
│
├── main.dart
│
├── app/
│   └── app.dart
│
├── core/
│   ├── constants/
│   │   └── api_constants.dart
│   │
│   └── ...
│
├── features/
│   │
│   ├── countries/
│   │   ├── bloc/
│   │   │   ├── countries_bloc.dart
│   │   │   ├── countries_event.dart
│   │   │   └── countries_state.dart
│   │   │
│   │   ├── data/
│   │   │   ├── countries_repository.dart
│   │   │   └── models/
│   │   │       └── country_model.dart
│   │   │
│   │   └── presentation/
│   │       ├── screens/
│   │       │   ├── countries_screen.dart
│   │       │   └── country_details_screen.dart
│   │       │
│   │       └── widgets/
│   │           └── country_card.dart
│   │
│   ├── weather/
│   │   ├── bloc/
│   │   ├── data/
│   │   └── presentation/
│   │
│   └── ...
│
└── firebase_options.dart
```

---

## API

### REST Countries

The application uses the REST Countries API to retrieve country information.

```text
https://api.restcountries.com/countries/v5
```

Pagination is handled using:

```text
?limit=100&offset=0
?limit=100&offset=100
?limit=100&offset=200
```

The application continues requesting pages until all available countries have been retrieved.

Example response structure:

```json
{
  "data": {
    "objects": [],
    "meta": {
      "total": 254,
      "count": 100,
      "limit": 100,
      "offset": 0,
      "more": true
    }
  }
}
```

---

## Environment Configuration

Sensitive configuration should be stored in `.env` rather than directly inside the source code.

Example:

```env
REST_COUNTRIES_API_KEY=your_api_key
WEATHER_API_KEY=your_weather_api_key
```

Make sure `.env` is included in `.gitignore`.

```gitignore
.env
```

---

## Installation

Clone the project:

```bash
git clone <repository-url>
```

Enter the project:

```bash
cd country_weather_explorer
```

Install dependencies:

```bash
flutter pub get
```

Check the Flutter environment:

```bash
flutter doctor
```

Run the application:

```bash
flutter run
```

---

## Build APK

For a release APK:

```bash
flutter build apk --release
```

The generated APK will normally be available at:

```text
build/app/outputs/flutter-apk/app-release.apk
```

---

## Development Commands

### Analyze

```bash
flutter analyze
```

### Format

```bash
dart format lib
```

### Run tests

```bash
flutter test
```

### Clean project

```bash
flutter clean
flutter pub get
```

---

## Error Handling

The application handles common API problems including:

- Missing API key
- Invalid API response
- HTTP errors
- Request timeout
- Empty country response
- Invalid country records
- Missing country information
- Missing flag information
- Missing coordinates
- Missing capital

Where information is unavailable, the UI displays:

```text
N/A
```

instead of crashing.

---

## Country Data Mapping

The country model maps API data such as:

```text
names.common
names.official
capital
latlng
cca2
cca3
region
subregion
population
area
flags
currencies
languages
timezones
continents
borders
independent
unMember
car
idd
tld
```

The application uses the country latitude and longitude when opening the weather functionality.

---

## Application Flow

```text
Launch App
    │
    ▼
Countries Screen
    │
    ├── Search Country
    │
    ▼
Country List
    │
    ▼
Select Country
    │
    ▼
Country Details
    │
    ├── Country Information
    │
    ├── Flag
    │
    ├── Capital
    │
    ├── Latitude / Longitude
    │
    ├── Population
    │
    ├── Languages
    │
    ├── Currency
    │
    └── Other Details
    │
    ▼
View Weather
    │
    ▼
Weather Screen
```

---

## Current Status

### Completed

- [x] Flutter project setup
- [x] REST Countries API integration
- [x] API authentication
- [x] Country pagination
- [x] Fetch all countries
- [x] Country model
- [x] Country search
- [x] Country list
- [x] Country card
- [x] Country details screen
- [x] Country flag
- [x] Capital
- [x] Country code
- [x] Latitude
- [x] Longitude
- [x] Additional country information
- [x] Missing-value handling
- [x] Weather navigation
- [x] BLoC state management

### Remaining / Future Improvements

- [ ] Complete weather UI and weather details
- [ ] Weather forecast
- [ ] Interactive map
- [ ] Last 5 searched countries
- [ ] Search history persistence
- [ ] Favorites
- [ ] Offline caching
- [ ] Unit testing
- [ ] Widget testing
- [ ] Production logging instead of `print()`
- [ ] Production release configuration

---

## Last 5 Searches

A planned search-history feature can store the user's five most recent country searches.

Example:

```text
1. India
2. United States
3. Japan
4. Germany
5. Australia
```

The list can be persisted locally so it remains available after restarting the application.

---

## Map

The map feature can use the country's:

```text
latitude
longitude
```

to position the map on the selected country.

Example:

```text
Country
   │
   ├── Latitude
   └── Longitude
          │
          ▼
       Map Marker
```

---

## Weather

Weather should be requested using the selected country's coordinates:

```text
Country Latitude
       +
Country Longitude
       │
       ▼
Weather API
       │
       ▼
Current Weather
```

This prevents every country from incorrectly displaying the same weather location.

---

## Security

API keys should **not** be committed to GitHub.

Use:

```text
.env
```

and keep it inside:

```gitignore
.env
```

For production applications, additional backend/API-key protection should be considered where appropriate.

---

## Author

**Kashif Patel**

Flutter Developer | Full-Stack Developer

Experience with:

- Flutter
- Dart
- React.js
- Next.js
- TypeScript
- JavaScript
- Node.js
- Firebase
- MongoDB
- REST APIs

---

## License

This project is intended for development/evaluation purposes. Add an appropriate open-source license if the project is published publicly.