# StreamWeather SDK

A flutter project to get weather forecasts.

## Getting Started

StreamWeatherSDK is a Flutter SDK for fetching weather forecast data. It provides a simple interface for retrieving weather forecast information for specific locations and timestamps.

## Usage

To use the StreamWeatherSDK, follow these steps:

1. Create an instance of the `StreamWeatherSDK` class:

```dart
    final weatherSDK = StreamWeatherSDK();

    final result = await weatherSDK.fetchWeatherForecast(
    42.0,            // Latitude
    -71.0,           // Longitude
    1631151600,      // Timestamp (in seconds)
    TempFormat.celsius, // Temperature format (Celsius/Fahrenheit)
    );

    if (result.value != null) {
        // Handle weather data
        final weatherData = result.value;
    } else {
        // Handle error
        final errorMessage = result.error;
    }
```
