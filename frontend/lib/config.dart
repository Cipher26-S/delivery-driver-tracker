/// URL de base de l'API.
///
/// Par défaut `localhost` ; sur un téléphone ou un émulateur, la surcharger :
/// `flutter run --dart-define=API_URL=http://192.168.1.10:3000/api`
/// (ou `http://10.0.2.2:3000/api` pour l'émulateur Android).
const String apiBaseUrl = String.fromEnvironment(
  'API_URL',
  defaultValue: 'http://localhost:3000/api',
);
