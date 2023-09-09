

class CommonUtils{

  static bool isValidLatitude(double latitude) => latitude >= -90.0 && latitude <= 90.0;

  static bool isValidLongitude(double longitude) => longitude >= -180.0 && longitude <= 180.0;

}