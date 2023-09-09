import 'package:http/http.dart' as http;
import 'package:stream_sdk/src/models/temp_info.dart';
import 'dart:convert';
import '../models/weather.dart';
import '../models/result.dart';

class WeatherDataSource {

  final _apiKey = 'e177cbfcf5b1306fe78717d0e7975325';
  final _baseUrl = 'https://api.openweathermap.org/data/2.5/onecall/timemachine';

  Future<Result<Weather>> fetchWeatherForecast(double latitude,
      double longitude, TempFormat tempFormat, int timestamp) async {
    final url = '$_baseUrl?lat=$latitude&lon=$longitude&dt=$timestamp&units=${tempFormat.name}&appid=$_apiKey';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Result.success(Weather.fromJson(data));
      } else {
        final errorMessage = jsonDecode(response.body)['message'];
        return Result.error(errorMessage);
      }
    } catch(e) {
      return Result.error(e.toString());
    }
  }
}
