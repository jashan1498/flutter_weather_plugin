import 'dart:async';

import 'package:flutter/material.dart';
// ignore: implementation_imports
import 'package:stream_sdk/exports.dart';
import 'package:stream_sdk_example/weather_input.dart';

void main() {
  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Weather App'),
        ),
        body: const WeatherPage(),
      ),
    );
  }
}

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  double latitude = double.nan;
  double longitude = double.nan;
  DateTime selectedDate = DateTime.now();
  TempFormat selectedUnit = TempFormat.metric; // Default unit
  String error = '';
  bool showWeatherInfo = false; // Control when to show the WeatherInfo widget

  Future<Result<Weather>> fetchWeatherData() async {
    error = ''; // Clear any previous error message
    final weatherData = StreamWeatherSDK().fetchWeatherForecast(
      latitude,
      longitude,
      selectedDate.millisecondsSinceEpoch ~/ 1000,
      selectedUnit,
    );
    return weatherData;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        if (error.isNotEmpty)
          Text(error, style: const TextStyle(color: Colors.red)),
        WeatherInput(
          onWeatherInfoChanged: (lat, lon, unit, date) {
            latitude = lat;
            longitude = lon;
            if (unit != selectedUnit || date != selectedDate) {
              setState(() {
                selectedUnit = unit;
                selectedDate = date;
              });
            }
          },
          initialLatitude: latitude,
          initialLongitude: longitude,
          initialTempFormat: selectedUnit,
          initialDate: selectedDate,
          onFetchWeather: () {
            setState(() {
              showWeatherInfo = true;
            });
          },
        ),
        const SizedBox(height: 20),
        weatherInfoBuilder()
      ],
    );
  }

  Widget weatherInfoBuilder() {
    if (showWeatherInfo) {
      showWeatherInfo = false;
      return FutureBuilder<Result<Weather>>(
          future: fetchWeatherData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.data?.error != null) {
              return Text('Error: ${snapshot.data?.error}');
            } else if (snapshot.hasData) {
              final weather = snapshot.data!;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.network(
                      'https://openweathermap.org/img/w/${weather.value?.icon}.png'),
                  Text('Location: ${weather.value?.location}'),
                  Text('Description: ${weather.value?.description}'),
                  Text(
                      'Temperature: ${weather.value?.temperature.toStringAsFixed(2)}${selectedUnit == TempFormat.metric ? '°C' : '°F'}'),
                ],
              );
            } else {
              return const SizedBox.shrink();
            }
          });
    } else {
      return const SizedBox.shrink();
    }
  }
}
