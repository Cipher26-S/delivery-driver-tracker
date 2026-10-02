# Delivery Driver Tracker – Backend

## Description
API Node.js/Express/MongoDB pour la gestion des livraisons, chauffeurs, localisation et administration.

## Installation
1. Installer les dépendances :
   ```powershell
   npm install
   ```
2. Lancer MongoDB (service ou `mongod`)
3. Démarrer le serveur :
   ```powershell
   npm start
   ```

## Endpoints principaux
- `POST /api/auth/register` : Inscription utilisateur
- `POST /api/auth/login` : Connexion utilisateur
- `GET /api/deliveries/driver/:driverId` : Livraisons d’un chauffeur
- `PUT /api/deliveries/:id/status` : Mise à jour du statut
- `POST /api/deliveries` : Création livraison (admin)
- `POST /api/location` : Enregistrement position
- `GET /api/location/driver/:driverId` : Historique positions
- `GET /api/admin/drivers` : Liste chauffeurs (admin)
- `GET /api/admin/deliveries` : Toutes les livraisons (admin)

## Test rapide
Importe le fichier `postman_collection.json` dans Postman pour tester l’API.

## Exemple de données de test
### Chauffeur
```json
{
  "name": "Jean Dupont",
  "email": "jean@exemple.com",
  "password": "motdepasse",
  "role": "driver"
}
```
### Livraison
```json
{
  "orderId": "CMD123",
  "customerName": "Alice Martin",
  "address": "10 rue de Paris",
  "driverId": "<ID_chauffeur>"
}
```
### Position
```json
{
  "driverId": "<ID_chauffeur>",
  "coordinates": {
    "type": "Point",
    "coordinates": [2.3522, 48.8566]
  }
}
```

## Structure des dossiers
- `models/` : Schémas MongoDB
- `routes/` : Fichiers de routes Express
- `utils/` : Middleware et utilitaires

