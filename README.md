# Delivery Driver Tracker

> Application mobile de suivi des livreurs : authentification, gestion des livraisons et remontée de la position des chauffeurs.

## Fonctionnalités

- **Authentification JWT** avec rôles `driver` et `admin`
- **Livreur** : liste de ses livraisons, détail d'une livraison, mise à jour du statut
- **Géolocalisation** : envoi de la position du livreur et historique des positions (index géospatial MongoDB `Point`)
- **Administration** : création de comptes livreurs, création et attribution de livraisons, vue de toutes les livraisons

## Stack technique

| Couche | Technologies |
|---|---|
| Mobile | Flutter, Dart, http |
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
npm start              # API sur http://localhost:3000
```

La collection Postman `backend/postman_collection.json` permet de tester tous les endpoints.

### Application mobile

```bash
cd frontend
flutter pub get
flutter run
```

> Sur un téléphone ou un émulateur Android, remplacer `localhost` dans `lib/services/` par l'adresse IP de la machine qui fait tourner l'API (ou `10.0.2.2` pour l'émulateur).

## API

| Méthode | Route | Accès | Description |
|---|---|---|---|
| POST | `/api/auth/register` | public | Inscription |
| POST | `/api/auth/login` | public | Connexion |
| GET | `/api/deliveries/driver/:driverId` | connecté | Livraisons d'un livreur |
| PUT | `/api/deliveries/:id/status` | connecté | Mise à jour du statut |
| POST | `/api/deliveries` | admin | Créer une livraison |
| POST | `/api/location` | connecté | Enregistrer une position |
| GET | `/api/location/driver/:driverId` | connecté | Historique des positions |
| GET | `/api/admin/drivers` | admin | Liste des livreurs |
| GET | `/api/admin/deliveries` | admin | Toutes les livraisons |

## Auteur

**Sawadogo Kiswendsida Salif** — Développeur Full-Stack & Mobile
[GitHub](https://github.com/Cipher26-S) · [LinkedIn](https://www.linkedin.com/in/salif-sawadogo-348081375)
