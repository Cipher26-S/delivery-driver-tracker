class Delivery {
  static const statusLabels = {
    'pending': 'En attente',
    'picked': 'Récupérée',
    'in_transit': 'En route',
    'delivered': 'Livrée',
  };

  final String id;
  final String orderId;
  final String customerName;
  final String address;
  final String status;

  Delivery({required this.id, required this.orderId, required this.customerName, required this.address, required this.status});

  factory Delivery.fromJson(Map<String, dynamic> json) {
    return Delivery(
      id: json['_id'],
      orderId: json['orderId'],
      customerName: json['customerName'],
      address: json['address'],
      status: json['status'],
    );
  }

  String get statusLabel => statusLabels[status] ?? status;
}
