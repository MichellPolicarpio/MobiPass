const Ticket = require('../models/Ticket');
const Route = require('../models/Route');
const Bus = require('../models/Bus');
const crypto = require('crypto');

// Generate unique QR code
const generateQRCode = () => {
  return crypto.randomBytes(16).toString('hex');
};

// Purchase ticket
exports.purchaseTicket = async (req, res) => {
  try {
    const { routeId, busId, seatNumber, departureTime, passengerName, passengerId } = req.body;
    
    // Check if route exists and get price
    const route = await Route.findById(routeId);
    if (!route) {
      return res.status(404).json({ message: 'Route not found' });
    }

    // Check if bus exists
    const bus = await Bus.findById(busId);
    if (!bus) {
      return res.status(404).json({ message: 'Bus not found' });
    }

    // Check if seat is available
    const existingTicket = await Ticket.findOne({
      busId,
      departureTime,
      seatNumber,
      status: { $in: ['pending', 'confirmed'] }
    });

    if (existingTicket) {
      return res.status(400).json({ message: 'Seat is already taken' });
    }

    // Create ticket
    const ticket = new Ticket({
      userId: req.user.id, // From auth middleware
      routeId,
      busId,
      seatNumber,
      departureTime,
      price: route.price,
      qrCode: generateQRCode(),
      passengerName,
      passengerId
    });

    await ticket.save();

    res.status(201).json({
      message: 'Ticket purchased successfully',
      ticket
    });
  } catch (error) {
    res.status(500).json({ message: 'Error purchasing ticket', error: error.message });
  }
};

// Get user's tickets
exports.getUserTickets = async (req, res) => {
  try {
    const tickets = await Ticket.find({ userId: req.user.id })
      .populate('routeId', 'name origin destination')
      .populate('busId', 'plateNumber model')
      .sort({ createdAt: -1 });

    res.json(tickets);
  } catch (error) {
    res.status(500).json({ message: 'Error fetching tickets', error: error.message });
  }
};

// Validate ticket (for QR scanning)
exports.validateTicket = async (req, res) => {
  try {
    const { qrCode } = req.body;

    const ticket = await Ticket.findOne({ qrCode })
      .populate('routeId', 'name origin destination')
      .populate('busId', 'plateNumber model');

    if (!ticket) {
      return res.status(404).json({ message: 'Invalid ticket' });
    }

    if (ticket.status === 'used') {
      return res.status(400).json({ message: 'Ticket already used' });
    }

    if (ticket.status === 'cancelled') {
      return res.status(400).json({ message: 'Ticket is cancelled' });
    }

    // Update ticket status
    ticket.status = 'used';
    await ticket.save();

    res.json({
      message: 'Ticket validated successfully',
      ticket
    });
  } catch (error) {
    res.status(500).json({ message: 'Error validating ticket', error: error.message });
  }
};

// Cancel ticket
exports.cancelTicket = async (req, res) => {
  try {
    const ticket = await Ticket.findOne({
      _id: req.params.id,
      userId: req.user.id
    });

    if (!ticket) {
      return res.status(404).json({ message: 'Ticket not found' });
    }

    if (ticket.status === 'used') {
      return res.status(400).json({ message: 'Cannot cancel used ticket' });
    }

    if (ticket.status === 'cancelled') {
      return res.status(400).json({ message: 'Ticket already cancelled' });
    }

    ticket.status = 'cancelled';
    await ticket.save();

    res.json({
      message: 'Ticket cancelled successfully',
      ticket
    });
  } catch (error) {
    res.status(500).json({ message: 'Error cancelling ticket', error: error.message });
  }
};

// Crear múltiples tickets
exports.createTickets = async (req, res) => {
  try {
    const { tickets } = req.body;
    const userId = req.user.id;

    const ticketPromises = tickets.map(ticket => {
      return Ticket.create({
        userId,
        type: ticket.type,
        price: ticket.price,
        purchaseDate: ticket.purchaseDate
      });
    });

    const createdTickets = await Promise.all(ticketPromises);
    res.status(201).json(createdTickets);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// Obtener tickets activos de un usuario
exports.getUserActiveTickets = async (req, res) => {
  try {
    const userId = req.user.id;
    const tickets = await Ticket.find({
      userId,
      isActive: true
    });
    res.json(tickets);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// Obtener conteo de tickets activos de un usuario
exports.getUserActiveTicketsCount = async (req, res) => {
  try {
    const userId = req.user.id;
    const count = await Ticket.countDocuments({
      userId,
      isActive: true
    });
    res.json({ count });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
}; 