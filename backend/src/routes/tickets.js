const express = require('express');
const router = express.Router();
const ticketController = require('../controllers/ticketController');
const auth = require('../middleware/auth');

// Protected routes
router.use(auth);

// Ticket routes
router.post('/purchase', ticketController.purchaseTicket);
router.get('/my-tickets', ticketController.getUserTickets);
router.post('/validate', ticketController.validateTicket);
router.post('/cancel/:id', ticketController.cancelTicket);

module.exports = router; 