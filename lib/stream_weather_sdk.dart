library stream_sdk;

import 'package:stream_sdk/src/repository/weather_repository.dart';
import 'package:stream_sdk/src/data/weather_data_source.dart';
import 'package:stream_sdk/src/models/temp_info.dart';
import 'package:stream_sdk/src/models/weather.dart';
import 'package:stream_sdk/src/models/result.dart';



class StreamWeatherSDK {
    final weatherDataSource = WeatherDataSource();
  late WeatherRepository weatherRepository;
  static final StreamWeatherSDK _singleton = StreamWeatherSDK._internal();

  StreamWeatherSDK._internal(){
    weatherRepository = WeatherRepository(dataSource: weatherDataSource);
  }

  factory StreamWeatherSDK() {
    return _singleton;
  }

  /* Fetches weather forecast for a location and timestamp.

    Parameters:
      - `lat`: Latitude of the location.
      - `lon`: Longitude of the location.
      - `timestamp`: Requested timestamp in seconds.
      - `tempFormat`: Desired temperature format (Celsius/Fahrenheit).

    Returns a [Future<Result<Weather>>].
  */
  Future<Result<Weather>> fetchWeatherForecast(
    double lat, double lon, int timestamp, TempFormat tempFormat) async {
     return weatherRepository.getWeather(lat, lon, timestamp, tempFormat);
  }
}
