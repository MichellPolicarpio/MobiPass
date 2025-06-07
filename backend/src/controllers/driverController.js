const Driver = require('../models/driver');
const jwt = require('jsonwebtoken');

// Registro de transportista
exports.signup = async (req, res) => {
  try {
    const { name, email, password, licenseNumber, busNumber } = req.body;

    // Verificar si ya existe un transportista con ese email
    const existingDriver = await Driver.findOne({ email });
    if (existingDriver) {
      return res.status(400).json({ message: 'El correo electrónico ya está registrado' });
    }

    // Verificar si ya existe un transportista con ese número de licencia
    const existingLicense = await Driver.findOne({ licenseNumber });
    if (existingLicense) {
      return res.status(400).json({ message: 'El número de licencia ya está registrado' });
    }

    // Crear nuevo transportista
    const driver = new Driver({
      name,
      email,
      password,
      licenseNumber,
      busNumber,
      role: 'driver'
    });

    await driver.save();

    // Generar token
    const token = jwt.sign(
      { id: driver._id, role: driver.role },
      process.env.JWT_SECRET || 'your-secret-key',
      { expiresIn: '24h' }
    );

    // Enviar respuesta sin incluir la contraseña
    const driverObject = driver.toObject();
    delete driverObject.password;

    res.status(201).json({
      message: 'Transportista registrado exitosamente',
      token,
      user: {
        _id: driverObject._id,
        name: driverObject.name,
        email: driverObject.email,
        role: driverObject.role,
        licenseNumber: driverObject.licenseNumber,
        busNumber: driverObject.busNumber,
        active: driverObject.active
      }
    });

  } catch (error) {
    console.error('Error en registro de transportista:', error);
    res.status(500).json({ message: 'Error al registrar transportista', error: error.message });
  }
};

// Login de transportista
exports.login = async (req, res) => {
  try {
    const { email, password } = req.body;

    // Buscar transportista por email
    const driver = await Driver.findOne({ email });
    if (!driver) {
      return res.status(401).json({ message: 'Credenciales inválidas' });
    }

    // Verificar contraseña
    const isMatch = await driver.comparePassword(password);
    if (!isMatch) {
      return res.status(401).json({ message: 'Credenciales inválidas' });
    }

    // Verificar si está activo
    if (!driver.active) {
      return res.status(401).json({ message: 'Cuenta desactivada' });
    }

    // Generar token
    const token = jwt.sign(
      { id: driver._id, role: driver.role },
      process.env.JWT_SECRET || 'your-secret-key',
      { expiresIn: '24h' }
    );

    // Enviar respuesta sin incluir la contraseña
    const driverObject = driver.toObject();
    delete driverObject.password;

    res.json({
      message: 'Login exitoso',
      token,
      user: {
        _id: driverObject._id,
        name: driverObject.name,
        email: driverObject.email,
        role: driverObject.role,
        licenseNumber: driverObject.licenseNumber,
        busNumber: driverObject.busNumber,
        active: driverObject.active
      }
    });

  } catch (error) {
    console.error('Error en login de transportista:', error);
    res.status(500).json({ message: 'Error al iniciar sesión', error: error.message });
  }
}; 