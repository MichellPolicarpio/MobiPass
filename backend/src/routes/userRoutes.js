const express = require('express');
const router = express.Router();
const userController = require('../controllers/userController');

// Rutas CRUD para usuarios
router.get('/', userController.getAllUsers);
router.get('/:id', userController.getUserById);
router.put('/:id', userController.updateUser);
router.delete('/:id', userController.deleteUser);

module.exports = router; 