import 'package:stream_sdk/src/data/weather_data_source.dart';
import 'package:stream_sdk/src/models/temp_info.dart';
import 'package:stream_sdk/src/models/result.dart';
import 'package:stream_sdk/src/utils/common_utils.dart';
import 'package:stream_sdk/src/models/weather.dart';

class WeatherRepository {
  final WeatherDataSource dataSource;

  WeatherRepository({required this.dataSource});

  Future<Result<Weather>> getWeather(
    double lat, double lon, int timestamp, TempFormat tempFormat) async {
  // Check if latitude and longitude are valid
  if (CommonUtils.isValidLatitude(lat) && CommonUtils.isValidLongitude(lon)) {
    // Fetch weather data from the data source
    final data = await dataSource.fetchWeatherForecast(lat, lon, tempFormat, timestamp);
    return data; // Return the fetched weather data
  } else {
    // Return an error result for invalid latitude or longitude
    return Result.error('Invalid latitude or longitude');
  }
}

}
