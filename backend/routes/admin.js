const express = require('express');
const Delivery = require('../models/Delivery');
const User = require('../models/User');
const { adminMiddleware } = require('../utils/auth');

const router = express.Router();

// Liste des chauffeurs
router.get('/drivers', adminMiddleware, async (req, res) => {
  try {
    const drivers = await User.find({ role: 'driver' });
    res.json(drivers);
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
});

// Liste de toutes les livraisons
router.get('/deliveries', adminMiddleware, async (req, res) => {
  try {
    const deliveries = await Delivery.find();
    res.json(deliveries);
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
});

module.exports = router;
