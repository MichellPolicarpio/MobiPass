const express = require('express');
const router = express.Router();
const driverController = require('../controllers/driverController');

// Rutas de autenticación
router.post('/signup', driverController.signup);
router.post('/login', driverController.login);

// Rutas CRUD
router.get('/', driverController.getAllDrivers);
router.get('/:id', driverController.getDriverById);
router.put('/:id', driverController.updateDriver);
router.delete('/:id', driverController.deleteDriver);

// Rutas de estadísticas
router.get('/:id/stats', driverController.getDriverStats);

module.exports = router; 