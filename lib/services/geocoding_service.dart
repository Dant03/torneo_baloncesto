import 'dart:convert';
import 'package:http/http.dart' as http;

class GeocodingService {
  final String apiKey;

  GeocodingService(this.apiKey);

  Future<String> getAddressFromCoordinates(double lat, double lng) async {
    final url = 'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$apiKey';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final results = json['results'] as List<dynamic>;
      if (results.isNotEmpty) {
        return results[0]['formatted_address'];
      } else {
        return 'Dirección no encontrada';
      }
    } else {
      throw Exception('Error al obtener la dirección');
    }
  }
}
