import 'package:flutter/material.dart';
import '../models/delivery.dart';

class DeliveryDetailScreen extends StatelessWidget {
  final Delivery delivery;
  DeliveryDetailScreen({required this.delivery});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Détail Livraison'),
        backgroundColor: Colors.indigo,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Commande: ${delivery.orderId}', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            Text('Client: ${delivery.customerName}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Adresse: ${delivery.address}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Statut: ${delivery.status}', style: TextStyle(fontSize: 18, color: Colors.indigo)),
            SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () async {
                // Exemple: Changer le statut en "delivered"
                final success = await DeliveryService().updateStatus(delivery.id, 'delivered', 'TOKEN_A_REMPLACER');
                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Statut mis à jour !')));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur mise à jour statut')));
                }
              },
              icon: Icon(Icons.update),
              label: Text('Mettre à jour le statut'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
            ),
            SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () async {
                // Utilise le package geolocator pour obtenir la position
                // Remplace 'TOKEN_A_REMPLACER' et 'DRIVERID_A_REMPLACER' par les vraies valeurs
                // Ajoute geolocator dans pubspec.yaml
                // import 'package:geolocator/geolocator.dart';
                // Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
                // final success = await DeliveryService().shareLocation('DRIVERID_A_REMPLACER', position.latitude, position.longitude, 'TOKEN_A_REMPLACER');
                // if (success) {
                //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Position partagée !')));
                // } else {
                //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur partage position')));
                // }
              },
              icon: Icon(Icons.location_on),
              label: Text('Partager ma position'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            ),
          ],
        ),
      ),
    );
  }
}
