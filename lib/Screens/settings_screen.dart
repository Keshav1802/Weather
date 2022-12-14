import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weather/Widgtes/theme_list_tile.dart';
import 'package:weather/Widgtes/unit_list_tile.dart';
import 'package:weather/getX/controller.dart';

import '../Services/get_weather.dart';


class SettingsScreen extends StatelessWidget {
  SettingsScreen({Key? key}) : super(key: key);
  final _fixedHeight = 10.0;
  //
  StateController settingsController = Get.put(StateController());
  void updatedData(var newValue) async {
    settingsController.groupVal.value = newValue;
    var jsonUpdatedData =
        await WeatherModel().getUnitMeasure(settingsController.groupVal.value);
    settingsController.updateUI(jsonUpdatedData);
  }

  //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Settings",
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
        bottom: PreferredSize(
          child: Container(
            color: Colors.grey,
            height: 1,
          ),
          preferredSize: const Size.fromHeight(1),
        ),
        leading: IconButton(
          splashRadius: 20,
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
          },
        ),
        foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Theme:",
                style: Theme.of(context).textTheme.headline1?.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0,
                    ),
              ),
              SizedBox(height: _fixedHeight),
              const ThemeListTile(),
              SizedBox(height: _fixedHeight * 2),
              Text(
                "Unit:",
                style: Theme.of(context).textTheme.headline1?.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0,
                    ),
              ),
              SizedBox(height: _fixedHeight),
              Obx(
                () => UnitListTile(
                  title: 'Celsius',
                  value: 'metric',
                  groupValue: settingsController.groupVal.value,
                  onChanged: (newValue) {
                    updatedData(newValue);
                  },
                ),
              ),
              SizedBox(height: _fixedHeight),
              Obx(
                () => UnitListTile(
                  title: 'Fahrenheit',
                  value: 'imperial',
                  groupValue: settingsController.groupVal.value,
                  onChanged: (newValue) {
                    updatedData(newValue);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
