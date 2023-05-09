import 'package:geolocator/geolocator.dart';

class GeolocatorService {

  GeolocatorService();

  Future<List> getPosition() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    return [position.latitude, position.longitude];
  }

}