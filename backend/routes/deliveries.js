const express = require('express');
const Delivery = require('../models/Delivery');
const User = require('../models/User');
const { authMiddleware, adminMiddleware } = require('../utils/auth');

const router = express.Router();

const STATUSES = ['pending', 'picked', 'in_transit', 'delivered'];


// Liste des livraisons assignées au chauffeur
router.get('/driver/:driverId', authMiddleware, async (req, res) => {
  if (req.user.role !== 'admin' && req.user.id !== req.params.driverId) {
    return res.status(403).json({ error: 'Accès refusé' });
  }
  try {
    const { status, from, to } = req.query;
    let query = { driverId: req.params.driverId };
    if (status) query.status = status;
    if (from || to) {
      query.assignedAt = {};
      if (from) query.assignedAt.$gte = new Date(from);
      if (to) query.assignedAt.$lte = new Date(to);
    }
    const deliveries = await Delivery.find(query);
    res.json(deliveries);
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
});

// Mise à jour du statut d'une livraison
router.put('/:id/status', authMiddleware, async (req, res) => {
  try {
    const { status } = req.body;
    if (!STATUSES.includes(status)) {
      return res.status(400).json({ error: 'Statut invalide.' });
    }
    const delivery = await Delivery.findById(req.params.id);
    if (!delivery) return res.status(404).json({ error: 'Livraison introuvable' });
    if (req.user.role !== 'admin' && delivery.driverId.toString() !== req.user.id) {
      return res.status(403).json({ error: 'Accès refusé' });
    }
    delivery.status = status;
    await delivery.save();
    res.json(delivery);
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
});


// Création d'une livraison (admin) avec validation
router.post('/', adminMiddleware, async (req, res) => {
  try {
    const { orderId, customerName, address, driverId } = req.body;
    if (!orderId || !customerName || !address || !driverId) {
      return res.status(400).json({ error: 'Tous les champs sont obligatoires.' });
    }
    if (orderId.length < 3) {
      return res.status(400).json({ error: 'orderId trop court.' });
    }
    const delivery = new Delivery({ orderId, customerName, address, driverId });
    await delivery.save();
    res.status(201).json(delivery);
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
});

module.exports = router;
