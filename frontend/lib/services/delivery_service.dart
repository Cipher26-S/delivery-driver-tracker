import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/delivery.dart';

class DeliveryService {
  Future<List<Delivery>> fetchDeliveries(String driverId, String token) async {
    final response = await http.get(
      Uri.parse('http://localhost:3000/api/deliveries/driver/$driverId'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      return data.map((json) => Delivery.fromJson(json)).toList();
    } else {
      throw Exception('Erreur chargement livraisons');
    }
  }

  Future<bool> updateStatus(String deliveryId, String status, String token) async {
    final response = await http.put(
      Uri.parse('http://localhost:3000/api/deliveries/$deliveryId/status'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({'status': status}),
    );
    return response.statusCode == 200;
  }

  Future<bool> shareLocation(String driverId, double lat, double lng, String token) async {
    final response = await http.post(
      Uri.parse('http://localhost:3000/api/location'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'driverId': driverId,
        'coordinates': {'type': 'Point', 'coordinates': [lng, lat]}
      }),
    );
    return response.statusCode == 201;
  }
}