const express = require('express');
const router = express.Router();
const auth = require('../middleware/auth');
const reportController = require('../controllers/reportController');

// Rutas protegidas por autenticación
router.use(auth);

// Rutas para administradores (deben ir antes que las rutas específicas)
router.get('/all', reportController.getAllReports);
router.put('/:id/status', reportController.updateReportStatus);

// Rutas para usuarios normales
router.post('/', reportController.createReport);
router.get('/', reportController.getReports);
router.get('/:id', reportController.getReport);
router.put('/:id', reportController.updateReport);
router.delete('/:id', reportController.deleteReport);

module.exports = router; 