const mongoose = require('mongoose');

const busSchema = new mongoose.Schema({
  plateNumber: {
    type: String,
    required: true,
    unique: true
  },
  model: {
    type: String,
    required: true
  },
  capacity: {
    type: Number,
    required: true
  },
  status: {
    type: String,
    enum: ['active', 'maintenance', 'inactive'],
    default: 'active'
  },
  features: [{
    type: String,
    enum: ['wifi', 'air_conditioning', 'bathroom', 'usb_ports', 'reclining_seats']
  }],
  driver: {
    name: String,
    license: String,
    phone: String
  }
}, {
  timestamps: true
});

module.exports = mongoose.model('Bus', busSchema); 