import 'package:geocoder/geocoder.dart';
import 'package:geocoder_buddy/geocoder_buddy.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class Location {
  late double longitude;
  late double latitude;

  Future<void> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    Position position = await Geolocator.getCurrentPosition();
    latitude = position.latitude;
    longitude = position.longitude;
//     final coordinates = new Coordinates(position.latitude, position.longitude);
//     print('coordinates is: $coordinates');
//
//     var addresses =
//     await Geocoder.local.findAddressesFromCoordinates(coordinates);
//     var first = addresses.first.featureName;
// // print number of retured addresses
//     print('${addresses.length}');
// // print the best address
// //     print("${first.featureName} : ${first.addressLine}");
//print other address names
//     print(Country:${first.countryName} AdminArea:${first.adminArea} SubAdminArea:${first.subAdminArea}");
// // print more address names
//     debugPrint(Locality:${first.locality}: Sublocality:${first.subLocality}");
    }
  }
