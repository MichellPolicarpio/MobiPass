const Admin = require('../models/Admin');
const jwt = require('jsonwebtoken');

// Registrar un nuevo administrador
exports.signup = async (req, res) => {
  try {
    const { name, email, password } = req.body;

    // Verificar si ya existe un admin con ese email
    const existingAdmin = await Admin.findOne({ email });
    if (existingAdmin) {
      return res.status(400).json({ message: 'El email ya está registrado' });
    }

    // Crear nuevo admin
    const admin = new Admin({
      name,
      email,
      password,
    });

    await admin.save();

    // Generar token
    const token = jwt.sign(
      { id: admin._id, role: 'admin' },
      process.env.JWT_SECRET || 'tu_jwt_secret',
      { expiresIn: '24h' }
    );

    // Enviar respuesta
    res.status(201).json({
      message: 'Administrador creado exitosamente',
      user: {
        id: admin._id,
        name: admin.name,
        email: admin.email,
        role: admin.role,
      },
      token,
    });
  } catch (error) {
    console.error('Error en signup admin:', error);
    res.status(500).json({ message: 'Error al crear administrador', error: error.message });
  }
};

// Login de administrador
exports.login = async (req, res) => {
  try {
    const { email, password } = req.body;

    // Buscar admin por email
    const admin = await Admin.findOne({ email });
    if (!admin) {
      return res.status(401).json({ message: 'Credenciales inválidas' });
    }

    // Verificar contraseña
    const isMatch = await admin.comparePassword(password);
    if (!isMatch) {
      return res.status(401).json({ message: 'Credenciales inválidas' });
    }

    // Generar token
    const token = jwt.sign(
      { id: admin._id, role: 'admin' },
      process.env.JWT_SECRET || 'tu_jwt_secret',
      { expiresIn: '24h' }
    );

    // Enviar respuesta
    res.json({
      message: 'Login exitoso',
      user: {
        id: admin._id,
        name: admin.name,
        email: admin.email,
        role: admin.role,
      },
      token,
    });
  } catch (error) {
    console.error('Error en login admin:', error);
    res.status(500).json({ message: 'Error en el login', error: error.message });
  }
}; 