const express = require('express');
const router = express.Router();
const auth = require('../middleware/auth');
const reportController = require('../controllers/reportController');

// Rutas protegidas por autenticación
router.use(auth);

// Crear un nuevo reporte
router.post('/', reportController.createReport);

// Obtener todos los reportes del usuario
router.get('/', reportController.getReports);

// Obtener un reporte específico
router.get('/:id', reportController.getReport);

// Actualizar un reporte
router.put('/:id', reportController.updateReport);

// Eliminar un reporte
router.delete('/:id', reportController.deleteReport);

module.exports = router; 