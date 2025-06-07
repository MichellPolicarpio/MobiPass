const express = require('express');
const router = express.Router();
const ticketController = require('../controllers/ticketController');
const auth = require('../middleware/auth');

// Protected routes
router.use(auth);

// Ticket routes
router.post('/purchase', ticketController.purchaseTicket);
router.get('/', ticketController.getUserTickets);
router.get('/active', ticketController.getUserActiveTickets);
router.get('/active/count', ticketController.getUserActiveTicketsCount);
router.post('/validate', ticketController.validateTicket);
router.post('/:id/cancel', ticketController.cancelTicket);

module.exports = router; 