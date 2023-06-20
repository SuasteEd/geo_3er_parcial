import 'dart:convert';
import 'package:geo_3er_parcial/models/directions.dart';
import 'package:geo_3er_parcial/utils/utils.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

// class DirectionsService {
//   static Future<String> calculateRoute(LatLng origin, LatLng destination) async { 
//     String apiKey = ApiConstants.key;
//     String url = 'https://maps.googleapis.com/maps/api/directions/json?origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude},${destination.longitude}&key=$apiKey';

//     var response = await http.get(Uri.parse(url));

//     if (response.statusCode == 200) {
//       var data = json.decode(response.body);
//      final directions = data['routes'][0]['legs'][0]['duration']['text'];
//      final distance = data['routes'][0]['legs'][0]['distance']['text'];
//       print(directions);
//       print(distance);
//       return 'Tiempo total del trayecto: 90 minutos';
//     } else {
//       throw Exception('Error en la solicitud de dirección');
//     }
//   }
// }

// class DirectionsService {
//   static Future<List<String>> calculateRoute(LatLng origin, List<LatLng> destinations) async {
//     String apiKey = ApiConstants.key;

//     List<String> distances = [];

//     for (LatLng destination in destinations) {
//       String url = 'https://maps.googleapis.com/maps/api/directions/json?origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude},${destination.longitude}&key=$apiKey';

//       var response = await http.get(Uri.parse(url));

//       if (response.statusCode == 200) {
//         var data = json.decode(response.body);
//         final distance = data['routes'][0]['legs'][0]['distance']['text'];
//         distances.add(distance);
//       } else {
//         throw Exception('Error en la solicitud de dirección');
//       }
//     }

//     distances.sort((a, b) {
//       // Convierte las distancias en números para poder compararlas
//       double distanceA = double.parse(a.split(' ')[0]);
//       double distanceB = double.parse(b.split(' ')[0]);

//       return distanceA.compareTo(distanceB);
//     });

//     // Toma los primeros 3 elementos de la lista de distancias
//     List<String> closestDistances = distances.take(3).toList();

//     return closestDistances;
//   }
// }


class DirectionsService {
  static Future<List<LatLng>> calculateRoute(LatLng origin, List<LatLng> destinations) async {
    String apiKey = ApiConstants.key;

    List<LatLng> closestCoordinates = [];

    // Calcular las distancias desde el punto de partida a todas las sucursales
    List<double> distances = [];
    for (LatLng destination in destinations) {
      String url = 'https://maps.googleapis.com/maps/api/directions/json?origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude},${destination.longitude}&key=$apiKey';

      var response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        final distance = data['routes'][0]['legs'][0]['distance']['value'];
        distances.add(distance.toDouble());
      } else {
        throw Exception('Error en la solicitud de dirección');
      }
    }

    // Obtener los índices de las 3 sucursales más cercanas
    List<int> closestIndices = [];
    for (int i = 0; i < distances.length; i++) {
      if (closestIndices.length < 3) {
        closestIndices.add(i);
      } else {
        // Reemplazar el índice del elemento más lejano si se encuentra uno más cercano
        for (int j = 0; j < closestIndices.length; j++) {
          if (distances[i] < distances[closestIndices[j]]) {
            closestIndices[j] = i;
            break;
          }
        }
      }
    }

    // Obtener las coordenadas de las 3 sucursales más cercanas
    for (int index in closestIndices) {
      LatLng coordinates = destinations[index];
      closestCoordinates.add(coordinates);
    }

    return closestCoordinates;
  }
}

