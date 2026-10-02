
require('dotenv').config();
const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');

const app = express();

app.use(express.json());
app.use(cors());

// Import des routes
const authRoutes = require('./routes/auth');
const deliveryRoutes = require('./routes/deliveries');
const locationRoutes = require('./routes/location');
const adminRoutes = require('./routes/admin');

app.use('/api/auth', authRoutes);
app.use('/api/deliveries', deliveryRoutes);
app.use('/api/location', locationRoutes);
app.use('/api/admin', adminRoutes);

// Connect to MongoDB
mongoose.connect(process.env.MONGODB_URI).then(() => {
  console.log('MongoDB connecté');
}).catch((err) => {
  console.error('Erreur MongoDB:', err);
});

app.get('/', (req, res) => {
  res.send('API Delivery Driver Tracker');
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Serveur démarré sur le port ${PORT}`);
});
