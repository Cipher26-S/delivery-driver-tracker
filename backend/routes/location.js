const express = require('express');
const LocationUpdate = require('../models/LocationUpdate');
const { authMiddleware } = require('../utils/auth');

const router = express.Router();

// Enregistrement d'une position
router.post('/', authMiddleware, async (req, res) => {
  try {
    const { coordinates } = req.body;
    // Un chauffeur ne peut enregistrer que sa propre position
    const driverId = req.user.role === 'admin' ? req.body.driverId : req.user.id;
    const location = new LocationUpdate({ driverId, coordinates });
    await location.save();
    res.status(201).json(location);
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
});

// Historique des positions d'un chauffeur
router.get('/driver/:driverId', authMiddleware, async (req, res) => {
  if (req.user.role !== 'admin' && req.user.id !== req.params.driverId) {
    return res.status(403).json({ error: 'Accès refusé' });
  }
  try {
    const locations = await LocationUpdate.find({ driverId: req.params.driverId }).sort({ timestamp: -1 });
    res.json(locations);
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
});

module.exports = router;
