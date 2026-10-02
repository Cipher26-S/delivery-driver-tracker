# Delivery Driver Tracker

> Application mobile de suivi des livreurs : authentification, gestion des livraisons et remontée de la position des chauffeurs.

## Fonctionnalités

- **Authentification JWT** avec rôles `driver` et `admin` ; seuls les administrateurs créent des comptes
- **Livreur** : liste de ses livraisons, détail d'une livraison, progression du statut (`En attente → Récupérée → En route → Livrée`)
- **Géolocalisation** : partage de la position GPS du livreur (package `geolocator`) et historique des positions (index géospatial MongoDB `2dsphere`)
- **Administration** : création de comptes livreurs depuis l’app ; création et attribution des livraisons et vue globale via l’API

## Stack technique

| Couche | Technologies |
|---|---|
| Mobile | Flutter, Dart, http, geolocator |
| Backend | Node.js, Express, Mongoose, JWT, bcrypt |
| Base de données | MongoDB |

## Structure

```
.
├── backend/   API REST Node.js / Express / MongoDB (voir backend/README.md)
│   ├── models/   User, Delivery, LocationUpdate
│   ├── routes/   auth, deliveries, location, admin
│   └── postman_collection.json
└── frontend/  Application Flutter
    └── lib/
        ├── config.dart  URL de l'API (surchargeable via --dart-define)
        ├── screens/   login, deliveries, delivery_detail, admin
        ├── services/  auth_service, delivery_service
        └── models/
```

## Installation

**Prérequis** : Node.js 18+, MongoDB, Flutter SDK 3.6+.

### Backend

```bash
cd backend
npm install
cp .env.example .env   # renseigner MONGODB_URI et JWT_SECRET
node create_admin.js "Admin" admin@exemple.com motdepasse   # premier compte admin
npm start              # API sur http://localhost:3000
```

La collection Postman `backend/postman_collection.json` permet de tester tous les endpoints.

### Application mobile

```bash
cd frontend
flutter pub get
flutter run
```

Sur un téléphone ou un émulateur, indiquer l'adresse de l'API :

```bash
flutter run --dart-define=API_URL=http://10.0.2.2:3000/api   # émulateur Android
```

L'administrateur se connecte avec le même écran et accède à la création des comptes livreurs.

### Tests

```bash
cd frontend && flutter test
```

## API

| Méthode | Route | Accès | Description |
|---|---|---|---|
| POST | `/api/auth/register` | admin | Créer un compte livreur |
| POST | `/api/auth/login` | public | Connexion |
| GET | `/api/deliveries/driver/:driverId` | livreur concerné / admin | Livraisons d'un livreur |
| PUT | `/api/deliveries/:id/status` | livreur assigné / admin | Mise à jour du statut |
| POST | `/api/deliveries` | admin | Créer une livraison |
| POST | `/api/location` | livreur | Enregistrer sa position |
| GET | `/api/location/driver/:driverId` | livreur concerné / admin | Historique des positions |
| GET | `/api/admin/drivers` | admin | Liste des livreurs |
| GET | `/api/admin/deliveries` | admin | Toutes les livraisons |

## Auteur

**Sawadogo Kiswendsida Salif** — Développeur Full-Stack & Mobile
[GitHub](https://github.com/Cipher26-S) · [LinkedIn](https://www.linkedin.com/in/salif-sawadogo-348081375)
