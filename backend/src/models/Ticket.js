const mongoose = require('mongoose');

const ticketSchema = new mongoose.Schema({
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  routeId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Route',
    required: true
  },
  busId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Bus',
    required: true
  },
  seatNumber: {
    type: Number,
    required: true
  },
  departureTime: {
    type: Date,
    required: true
  },
  price: {
    type: Number,
    required: true
  },
  qrCode: {
    type: String,
    required: true,
    unique: true
  },
  passengerName: {
    type: String,
    required: true
  },
  passengerId: {
    type: String,
    required: true
  },
  status: {
    type: String,
    enum: ['pending', 'confirmed', 'used', 'cancelled'],
    default: 'pending'
  },
  purchaseDate: {
    type: Date,
    default: Date.now
  },
  isActive: {
    type: Boolean,
    default: true
  }
});

module.exports = mongoose.model('Ticket', ticketSchema); 