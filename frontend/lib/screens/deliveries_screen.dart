import 'package:flutter/material.dart';
import '../services/delivery_service.dart';
import '../models/delivery.dart';
import 'delivery_detail_screen.dart';

class DeliveriesScreen extends StatefulWidget {
  final String driverId;
  final String token;
  const DeliveriesScreen({super.key, required this.driverId, required this.token});

  @override
  State<DeliveriesScreen> createState() => _DeliveriesScreenState();
}

class _DeliveriesScreenState extends State<DeliveriesScreen> {
  late Future<List<Delivery>> deliveriesFuture;

  @override
  void initState() {
    super.initState();
    deliveriesFuture = DeliveryService().fetchDeliveries(widget.driverId, widget.token);
  }

  Color statusColor(String status) {
    switch (status) {
      case 'pending': return Colors.orange;
      case 'picked': return Colors.blue;
      case 'in_transit': return Colors.purple;
      case 'delivered': return Colors.green;
      default: return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mes Livraisons'),
        backgroundColor: Colors.indigo,
      ),
      body: FutureBuilder<List<Delivery>>(
        future: deliveriesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          }
          final deliveries = snapshot.data ?? [];
        if (deliveries.isEmpty) {
          return Center(
            child: Text('Aucune livraison à afficher', style: TextStyle(fontSize: 18, color: Colors.grey)),
          );
        }
        return RefreshIndicator(
          onRefresh: () async {
            setState(() {
              deliveriesFuture = DeliveryService().fetchDeliveries(widget.driverId, widget.token);
            });
          },
          child: ListView.builder(
            itemCount: deliveries.length,
            itemBuilder: (context, index) {
              final delivery = deliveries[index];
              return Card(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  leading: Icon(Icons.local_shipping, color: statusColor(delivery.status), size: 32),
                  title: Text(delivery.orderId, style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Client: ${delivery.customerName}'),
                      Text('Adresse: ${delivery.address}'),
                      Text('Statut: ${delivery.status}', style: TextStyle(color: statusColor(delivery.status))),
                    ],
                  ),
                  trailing: Icon(Icons.arrow_forward_ios, color: Colors.indigo),
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DeliveryDetailScreen(delivery: delivery, token: widget.token),
                      ),
                    );
                    // Recharge la liste pour refléter un éventuel changement de statut
                    setState(() {
                      deliveriesFuture = DeliveryService().fetchDeliveries(widget.driverId, widget.token);
                    });
                  },
                ),
              );
            },
          ),
        );
        },
      ),
    );
  }
}