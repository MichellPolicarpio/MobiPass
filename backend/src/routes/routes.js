const express = require('express');
const router = express.Router();
const routeController = require('../controllers/routeController');
const auth = require('../middleware/auth');

// Public routes
router.get('/', routeController.getRoutes);
router.get('/:id', routeController.getRouteById);

// Protected routes (admin only)
router.use(auth);
router.post('/', routeController.createRoute);
router.put('/:id', routeController.updateRoute);
router.delete('/:id', routeController.deleteRoute);

module.exports = router; 