import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:weather/Screens/location_error_screen.dart';
import 'package:weather/Screens/settings_screen.dart';
import 'package:weather/Services/get_weather.dart';
import 'package:weather/Widgtes/bottom_container.dart';
import 'package:weather/Widgtes/center_container.dart';
import 'package:weather/Widgtes/tertiary_container.dart';
import 'package:weather/Widgtes/week_days_container.dart';
import 'package:weather/getX/controller.dart';


// ignore: must_be_immutable
class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key, this.weatherDataJson}) : super(key: key);
  final weatherDataJson;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final double _fixedHeight = 10;

  var dateStringFormat = DateFormat.yMMMEd('en_US').format(DateTime.now());

  final _transition = Transition.rightToLeft;

  final _duration = const Duration(milliseconds: 300);

  final _locationDuration = const Duration(milliseconds: 50);

  final _locationTransition = Transition.native;

  final WeatherModel _weatherModel = WeatherModel();

  Future<void> refreshList(StateController controller) async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Get.off(
          LocationError(),
          transition: _locationTransition,
          duration: _locationDuration,
        );
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    await Future.delayed(const Duration(seconds: 2));
    if (controller.groupVal.value == 'metric') {
      var weatherData1 = await _weatherModel.getLocationAndWeatherData();
      print(weatherData1.toString());
      controller.updateUI(weatherData1);
    } else if (controller.groupVal.value == 'imperial') {
      var weatherData2 =
          await _weatherModel.getUnitMeasure(controller.groupVal.value);
      controller.updateUI(weatherData2);
      WeekDaysContainer(weatherDataJson: weatherData2);
    }
    // if (!serviceEnabled) {
    //   Get.off(
    //     LocationError(),
    //     transition: _locationTransition,
    //     duration: _locationDuration,
    //   );
    // }
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        elevation: 20,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        title: new Text('Are you sure?',style: TextStyle(fontWeight: FontWeight.w500),),
        content: new Text('Do you want to exit the App',style: TextStyle(fontWeight: FontWeight.w400)),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text('No',style: TextStyle(fontWeight: FontWeight.w400)),
          ),
          TextButton(
            onPressed: () =>  SystemNavigator.pop(),
            child: new Text('Yes',style: TextStyle(fontWeight: FontWeight.w400)),
          ),
        ],
      ),
    )) ?? false;
  }

  @override
  Widget build(BuildContext context)  {
    double _screenHeight = MediaQuery.of(context).size.height;
    StateController stateController = Get.put(StateController());
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          actions: [
            IconButton(
              splashRadius: 20,
              onPressed: () {
                Get.to(
                  () => SettingsScreen(),
                  transition: _transition,
                  duration: _duration,
                );
              },
              icon: Icon(
                Icons.more_vert,
                color: Theme.of(context).appBarTheme.foregroundColor,
              ),
            ),
          ],
          title: Text(
            dateStringFormat,
            style: Theme.of(context).textTheme.bodyText2,
          ),
        ),
        body: RefreshIndicator(
          displacement: 20,
          color: (Get.isDarkMode) ? Colors.black : Colors.white,
          onRefresh: () => refreshList(stateController),
          child: GetBuilder<StateController>(
            init: StateController(),
            initState: (_) {
              stateController.updateUI(widget.weatherDataJson);
            },
            builder: (_) {
              return SafeArea(
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Obx(
                        () => CenterContainer(
                          cityName: stateController.cityName.value,
                          temperatureDegree:
                              stateController.temperatureDegree.value,
                          weatherCondition:
                              stateController.weatherCondition.value,
                          latitude: stateController.latitude.value,
                          longitude: stateController.longitude.value,
                          // centerIcon: stateController.weatherIconData.value,
                        ),
                      ),
                      SizedBox(height: _fixedHeight),
                      // Obx(
                      //   () => TertiaryContainer(
                      //     minDegree: stateController.latitude.value,
                      //     maxDegree: stateController.longitude.value,
                      //   ),
                      // ),
                      // SizedBox(height: _fixedHeight * 2),
                      const Divider(
                        thickness: 1,
                      ),
                      SizedBox(height: _fixedHeight),
                      WeekDaysContainer(
                        weatherDataJson: widget.weatherDataJson,
                      ),
                      SizedBox(height: _fixedHeight),
                      const Divider(
                        thickness: 1,
                      ),
                      SizedBox(height: _fixedHeight),
                      // Obx(
                      //   () => BottomContainer(
                      //     humidity: stateController.humidity.value,
                      //     windSpeed: stateController.windSpeed.value,
                      //     sunrise: stateController.sunrise.value,
                      //     sunset: stateController.sunset.value,
                      //   ),
                      // ),
                      // SizedBox(height: _fixedHeight * 4),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
