
import 'package:weather/Services/location.dart' as Loc;
import 'package:weather/Services/networking.dart';


const apiKey = 'ea77b27a1760fcfa9b16541e066e86f8';
const openWeatherURL = 'https://api.openweathermap.org/data/2.5/onecall';

class WeatherModel {
  Future<dynamic> getLocationAndWeatherData() async {
    Loc.Location locationCheck = Loc.Location();
    await locationCheck.getCurrentLocation();
    double latitude = locationCheck.latitude;
    double longitude = locationCheck.longitude;

    NetworkHelper networkHelper = NetworkHelper(
      url:
      '$openWeatherURL?lat=$latitude&lon=$longitude&exclude=minutely,hourly&appid=$apiKey&units=metric',
    );
    var weatherJsonData = await networkHelper.getData();
    return weatherJsonData;
  }

  Future<dynamic> getUnitMeasure(String unit) async {
    Loc.Location locationCheck = Loc.Location();
    await locationCheck.getCurrentLocation();
    double? latitude = locationCheck.latitude;
    double? longitude = locationCheck.longitude;
    NetworkHelper networkHelper = NetworkHelper(
        url:
        '$openWeatherURL?lat=$latitude&lon=$longitude&exclude=minutely,hourly&appid=$apiKey&units=$unit');
    var weatherJsonData = await networkHelper.getData();
    return weatherJsonData;
  }
}