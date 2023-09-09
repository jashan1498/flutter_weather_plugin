
// ignore: implementation_imports
import 'package:stream_sdk/src/models/temp_info.dart';
// ignore: implementation_imports
import 'package:stream_sdk/src/utils/common_utils.dart';
import 'package:flutter/material.dart';


class WeatherInput extends StatelessWidget {
  final Function(double, double, TempFormat, DateTime) onWeatherInfoChanged;
  final Function() onFetchWeather;
  final double initialLatitude;
  final double initialLongitude;
  final TempFormat initialTempFormat;
  final DateTime initialDate;

  WeatherInput({
    Key? key,
    required this.onWeatherInfoChanged,
    required this.initialLatitude,
    required this.initialLongitude,
    required this.initialTempFormat,
    required this.initialDate,
    required this.onFetchWeather,
  }) : super(key: key);

  final latitudeController = TextEditingController();
  final longitudeController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    if (initialLatitude.isFinite) {
      latitudeController.text = initialLatitude.toString();
    }
    if (initialLongitude.isFinite) {
      longitudeController.text = initialLongitude.toString();
    }

    return Form(
      key: formKey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            TextFormField(
              controller: latitudeController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Latitude'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a valid latitude';
                }
                final latitude = double.tryParse(value);
                if (latitude == null || !CommonUtils.isValidLatitude(latitude)) {
                  return 'Please enter a valid latitude (-90 to 90)';
                }
                return null;
              },
               onChanged: (text) {
                onWeatherInfoChanged(
                  double.parse(latitudeController.text),
                  double.parse(longitudeController.text),
                  initialTempFormat,
                  initialDate,
                );
              }
            ),
            TextFormField(
              controller: longitudeController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Longitude'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a valid longitude';
                }
                final longitude = double.tryParse(value);
                if (longitude == null || !CommonUtils.isValidLongitude(longitude)) {
                  return 'Please enter a valid longitude (-180 to 180)';
                }
                return null;
              },
              onChanged: (text) {
                onWeatherInfoChanged(
                  double.parse(latitudeController.text),
                  double.parse(longitudeController.text),
                  initialTempFormat,
                  initialDate,
                );
              }
            ),
            DropdownButton<TempFormat>(
              value: initialTempFormat,
              onChanged: (unit) => onWeatherInfoChanged(
                double.parse(latitudeController.text),
                double.parse(longitudeController.text),
                unit!,
                initialDate,
              ),
              items: TempFormat.values.map((unit) {
                return DropdownMenuItem(
                  value: unit,
                  child: Text(unit == TempFormat.metric ? 'Celsius' : 'Fahrenheit'),
                );
              }).toList(),
            ),
            ElevatedButton(
              onPressed: () async {
                final pickedDate = await showDatePicker(
                  context: context,
                  initialDate: initialDate,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                if (pickedDate != null) {
                  onWeatherInfoChanged(
                    double.parse(latitudeController.text),
                    double.parse(longitudeController.text),
                    initialTempFormat,
                    pickedDate,
                  );
                }
              },
              child: Text(
                "${initialDate.toLocal()}".split(' ')[0],
                style: const TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState?.validate() ?? false) {
                  final latitudeText = latitudeController.text.trim();
                  final longitudeText = longitudeController.text.trim();
                  final latitude = double.tryParse(latitudeText) ?? 0.0;
                  final longitude = double.tryParse(longitudeText) ?? 0.0;
                  if (CommonUtils.isValidLatitude(latitude) && CommonUtils.isValidLongitude(longitude)) {
                    // onWeatherInfoChanged(latitude, longitude, initialTempFormat, initialDate);
                    onFetchWeather();
                  }
                }
              },
              child: const Text('Get Weather'),
            ),
          ],
        ),
      ),
    );
  }
}
