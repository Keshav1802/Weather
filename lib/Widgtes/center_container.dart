import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';

class CenterContainer extends StatefulWidget {
   CenterContainer({
    Key? key,
    required this.temperatureDegree,
    required this.cityName,
    required this.weatherCondition,
    this.centerIcon,
    this.latitude,
    this.longitude,
  }) : super(key: key);

  final int temperatureDegree;
  final String cityName;
  final String weatherCondition;
  final IconData? centerIcon;
  final double? latitude;
  final double? longitude;

  @override
  State<CenterContainer> createState() => _CenterContainerState();
}

class _CenterContainerState extends State<CenterContainer> {
  final double _fixedHeight = 10;

  Future<String> city() async{
    final coordinates = new Coordinates(widget.latitude, widget.longitude);

    var addresses =
    await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var locationName = addresses.first;
    print(locationName.featureName);
    return locationName.featureName;
  }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
        future: city(),
      builder: (BuildContext context,
          AsyncSnapshot<String> snapshot,) {
          if(snapshot.hasData){
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Text(
                      snapshot.data!.toUpperCase(),
                      style: Theme.of(context).textTheme.headline1,
                    ),
                    SizedBox(height: _fixedHeight),
                    Text(
                      widget.weatherCondition.toUpperCase(),
                      style: Theme.of(context).textTheme.headline2,
                    ),
                    // SizedBox(height: _fixedHeight * 2),
                    // Icon(
                    //   centerIcon,
                    //   size: 70,
                    // ),
                    SizedBox(height: _fixedHeight * 2),
                    Text(
                      '${widget.temperatureDegree.toString()}°',
                      style: Theme.of(context).textTheme.headline4,
                    ),
                  ],
                ),
              ],
            );
          }
          else {
            return Text('Loading data');
          }
      }
    );
  }
}
