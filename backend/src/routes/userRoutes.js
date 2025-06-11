const express = require('express');
const router = express.Router();
const userController = require('../controllers/userController');
const auth = require('../middleware/auth');

// Rutas CRUD para usuarios
router.get('/', auth, userController.getAllUsers);
router.get('/:id', auth, userController.getUserById);
router.put('/:id', auth, userController.updateUser);
router.delete('/:id', auth, userController.deleteUser);

module.exports = router; 