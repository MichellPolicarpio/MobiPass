const express = require('express');
const router = express.Router();
const driverController = require('../controllers/driverController');

// Rutas de autenticación para transportistas
router.post('/signup', driverController.signup);
router.post('/login', driverController.login);

module.exports = router; 