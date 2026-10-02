import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../models/delivery.dart';
import '../services/delivery_service.dart';

class DeliveryDetailScreen extends StatefulWidget {
  final Delivery delivery;
  final String token;

  const DeliveryDetailScreen({super.key, required this.delivery, required this.token});

  @override
  State<DeliveryDetailScreen> createState() => _DeliveryDetailScreenState();
}

class _DeliveryDetailScreenState extends State<DeliveryDetailScreen> {
  static const _statusFlow = ['pending', 'picked', 'in_transit', 'delivered'];
  static const _statusLabels = {
    'pending': 'En attente',
    'picked': 'Récupérée',
    'in_transit': 'En route',
    'delivered': 'Livrée',
  };

  final _service = DeliveryService();
  late String _status;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _status = widget.delivery.status;
  }

  String? get _nextStatus {
    final i = _statusFlow.indexOf(_status);
    return (i >= 0 && i < _statusFlow.length - 1) ? _statusFlow[i + 1] : null;
  }

  void _showMessage(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  Future<void> _advanceStatus() async {
    final next = _nextStatus;
    if (next == null) return;
    setState(() => _busy = true);
    final success = await _service.updateStatus(widget.delivery.id, next, widget.token);
    if (!mounted) return;
    setState(() {
      _busy = false;
      if (success) _status = next;
    });
    _showMessage(success ? 'Statut mis à jour : ${_statusLabels[next]}' : 'Erreur mise à jour statut');
  }

  Future<void> _shareLocation() async {
    setState(() => _busy = true);
    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        throw 'Activez la localisation du téléphone';
      }
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        throw 'Permission de localisation refusée';
      }
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
      );
      final success = await _service.shareLocation(position.latitude, position.longitude, widget.token);
      if (!mounted) return;
      _showMessage(success ? 'Position partagée !' : 'Erreur partage position');
    } catch (e) {
      if (!mounted) return;
      _showMessage(e.toString());
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final delivery = widget.delivery;
    final next = _nextStatus;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Détail Livraison'),
        backgroundColor: Colors.indigo,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Commande: ${delivery.orderId}', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Text('Client: ${delivery.customerName}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text('Adresse: ${delivery.address}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text('Statut: ${_statusLabels[_status] ?? _status}', style: const TextStyle(fontSize: 18, color: Colors.indigo)),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: (_busy || next == null) ? null : _advanceStatus,
              icon: const Icon(Icons.update),
              label: Text(next == null ? 'Livraison terminée' : 'Passer à : ${_statusLabels[next]}'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo, foregroundColor: Colors.white),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _busy ? null : _shareLocation,
              icon: const Icon(Icons.location_on),
              label: const Text('Partager ma position'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
