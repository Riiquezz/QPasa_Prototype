import 'package:geolocator/geolocator.dart';

class Location {
  double latitude;
  double longitude;
  String state;
  String city;

  final List<Map> states = [
    {'name': 'Acre', 'abbvr': 'AC'},
    {'name': 'Alagoas', 'abbvr': 'AL'},
    {'name': 'Amapá', 'abbvr': 'AP'},
    {'name': 'Amazonas', 'abbvr': 'AM'},
    {'name': 'Bahia', 'abbvr': 'BA'},
    {'name': 'Ceará', 'abbvr': 'CE'},
    {'name': 'Distrito Federal', 'abbvr': 'DF'},
    {'name': 'Espírito Santo', 'abbvr': 'ES'},
    {'name': 'Goiás', 'abbvr': 'GO'},
    {'name': 'Maranhão', 'abbvr': 'MA'},
    {'name': 'Mato Grosso', 'abbvr': 'MT'},
    {'name': 'Mato Grosso do Sul', 'abbvr': 'MS'},
    {'name': 'Minas Gerais', 'abbvr': 'MG'},
    {'name': 'Pará', 'abbvr': 'PA'},
    {'name': 'Paraíba', 'abbvr': 'PB'},
    {'name': 'Paraná', 'abbvr': 'PR'},
    {'name': 'Pernambuco', 'abbvr': 'PE'},
    {'name': 'Piauí', 'abbvr': 'PI'},
    {'name': 'Rio de Janeiro', 'abbvr': 'RJ'},
    {'name': 'Rio Grande do Norte', 'abbvr': 'RN'},
    {'name': 'Rio Grande do Sul', 'abbvr': 'RS'},
    {'name': 'Rondônia', 'abbvr': 'RO'},
    {'name': 'Roraima', 'abbvr': 'RR'},
    {'name': 'Santa Catarina', 'abbvr': 'SC'},
    {'name': 'São Paulo', 'abbvr': 'SP'},
    {'name': 'Sergipe', 'abbvr': 'SE'},
    {'name': 'Tocantins', 'abbvr': 'TO'}
  ];

  Future<void> getCurrentPosition() async {
    try {
      Position position = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.low);

      latitude = position.latitude;
      longitude = position.longitude;
    } catch (e) {
      print(e);
    }
  }

  getCurrentPositionDataLatLong(double lat, double long) async {
    List<Placemark> placemark =
        await Geolocator().placemarkFromCoordinates(lat, long);

    Map filterState =
        states.firstWhere((e) => e['name'] == placemark[0].administrativeArea);

    state = filterState['abbvr'];
    city = placemark[0].subAdministrativeArea;
  }
}
