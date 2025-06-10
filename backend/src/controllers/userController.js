const User = require('../models/User');

// Obtener todos los usuarios
exports.getAllUsers = async (req, res) => {
  try {
    console.log('Obteniendo todos los usuarios');
    const users = await User.find({ role: 'user' })
      .select('-password')
      .sort({ createdAt: -1 });
    
    console.log(`Se encontraron ${users.length} usuarios`);
    res.json(users);
  } catch (error) {
    console.error('Error al obtener usuarios:', error);
    res.status(500).json({ message: 'Error al obtener usuarios', error: error.message });
  }
};

// Obtener un usuario por ID
exports.getUserById = async (req, res) => {
  try {
    console.log('Buscando usuario con ID:', req.params.id);
    const user = await User.findOne({ _id: req.params.id, role: 'user' }).select('-password');
    
    if (!user) {
      console.log('Usuario no encontrado');
      return res.status(404).json({ message: 'Usuario no encontrado' });
    }
    
    console.log('Usuario encontrado:', user);
    res.json(user);
  } catch (error) {
    console.error('Error al obtener usuario:', error);
    res.status(500).json({ message: 'Error al obtener usuario', error: error.message });
  }
};

// Actualizar un usuario
exports.updateUser = async (req, res) => {
  try {
    const { name, email } = req.body;
    console.log('Actualizando usuario:', req.params.id);
    console.log('Datos recibidos:', { name, email });

    // Verificar si el usuario existe y es un usuario normal
    const existingUser = await User.findOne({ _id: req.params.id, role: 'user' });
    if (!existingUser) {
      console.log('Usuario no encontrado o no es un usuario normal');
      return res.status(404).json({ message: 'Usuario no encontrado' });
    }

    // Verificar si el email ya está en uso por otro usuario
    if (email && email !== existingUser.email) {
      const duplicateEmail = await User.findOne({ email, _id: { $ne: req.params.id } });
      if (duplicateEmail) {
        console.log('Email duplicado encontrado');
        return res.status(400).json({ message: 'El correo electrónico ya está en uso' });
      }
    }

    // Actualizar usuario
    const updatedUser = await User.findByIdAndUpdate(
      req.params.id,
      { name, email },
      { new: true }
    ).select('-password');

    console.log('Usuario actualizado:', updatedUser);
    res.json(updatedUser);
  } catch (error) {
    console.error('Error al actualizar usuario:', error);
    res.status(500).json({ message: 'Error al actualizar usuario', error: error.message });
  }
};

// Eliminar un usuario
exports.deleteUser = async (req, res) => {
  try {
    console.log('Intentando eliminar usuario con ID:', req.params.id);
    
    // Verificar si el usuario existe y es un usuario normal
    const user = await User.findOne({ _id: req.params.id, role: 'user' });
    if (!user) {
      console.log('Usuario no encontrado o no es un usuario normal');
      return res.status(404).json({ message: 'Usuario no encontrado' });
    }

    // Eliminar usuario
    await User.deleteOne({ _id: req.params.id });
    console.log('Usuario eliminado exitosamente');
    
    res.json({ message: 'Usuario eliminado exitosamente' });
  } catch (error) {
    console.error('Error al eliminar usuario:', error);
    res.status(500).json({ message: 'Error al eliminar usuario', error: error.message });
  }
}; 