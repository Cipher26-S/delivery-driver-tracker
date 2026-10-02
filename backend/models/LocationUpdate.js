const mongoose = require('mongoose');

const locationUpdateSchema = new mongoose.Schema({
  driverId: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
  coordinates: {
    type: { type: String, enum: ['Point'], required: true },
    coordinates: { type: [Number], required: true }
  },
  timestamp: { type: Date, default: Date.now }
});

locationUpdateSchema.index({ coordinates: '2dsphere' });

module.exports = mongoose.model('LocationUpdate', locationUpdateSchema);
