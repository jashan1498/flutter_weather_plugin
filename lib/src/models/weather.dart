class Weather {
  final String location;
  final String description;
  final String icon;
  final double temperature;

  Weather({required this.location, required this.description, required this.temperature,required this.icon});

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      location: json['timezone'],
      description: json['current']['weather'][0]['description'],
      temperature: json['current']['temp'],
      icon: json['current']['weather'][0]['icon'],
    );
  }
}


