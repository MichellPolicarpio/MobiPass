const mongoose = require('mongoose');

const reportSchema = new mongoose.Schema({
  driverLicense: {
    type: String,
    required: true,
  },
  route: {
    type: String,
    required: true,
  },
  complaint: {
    type: String,
    required: true,
  },
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true,
  },
  status: {
    type: String,
    enum: ['pendiente', 'en proceso', 'resuelto'],
    default: 'pendiente',
  },
  createdAt: {
    type: Date,
    default: Date.now,
  },
});

module.exports = mongoose.model('Report', reportSchema); 