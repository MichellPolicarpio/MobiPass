const Driver = require('../models/driver');
const jwt = require('jsonwebtoken');
const User = require('../models/User');

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

// Obtener todos los transportistas
exports.getAllDrivers = async (req, res) => {
  try {
    const drivers = await User.find({ role: 'driver' })
      .select('-password')  // Excluir el campo password
      .sort({ createdAt: -1 });  // Ordenar por fecha de creación, más recientes primero
    
    res.json(drivers);
  } catch (error) {
    console.error('Error al obtener transportistas:', error);
    res.status(500).json({ message: 'Error al obtener transportistas', error: error.message });
  }
};

// Obtener un transportista por ID
exports.getDriverById = async (req, res) => {
  try {
    const driver = await User.findOne({ _id: req.params.id, role: 'driver' }).select('-password');
    if (!driver) {
      return res.status(404).json({ message: 'Transportista no encontrado' });
    }
    res.json(driver);
  } catch (error) {
    console.error('Error al obtener transportista:', error);
    res.status(500).json({ message: 'Error al obtener transportista', error: error.message });
  }
};

// Actualizar un transportista
exports.updateDriver = async (req, res) => {
  try {
    const { name, email, licenseNumber, busNumber } = req.body;
    const driver = await User.findOneAndUpdate(
      { _id: req.params.id, role: 'driver' },
      { name, email, licenseNumber, busNumber },
      { new: true }
    ).select('-password');

    if (!driver) {
      return res.status(404).json({ message: 'Transportista no encontrado' });
    }

    res.json(driver);
  } catch (error) {
    console.error('Error al actualizar transportista:', error);
    res.status(500).json({ message: 'Error al actualizar transportista', error: error.message });
  }
};

// Eliminar un transportista
exports.deleteDriver = async (req, res) => {
  try {
    const driver = await User.findOneAndDelete({ _id: req.params.id, role: 'driver' });
    if (!driver) {
      return res.status(404).json({ message: 'Transportista no encontrado' });
    }
    res.json({ message: 'Transportista eliminado exitosamente' });
  } catch (error) {
    console.error('Error al eliminar transportista:', error);
    res.status(500).json({ message: 'Error al eliminar transportista', error: error.message });
  }
};

// Obtener estadísticas del transportista
exports.getDriverStats = async (req, res) => {
  try {
    const driverId = req.params.id;
    
    // TODO: Implementar lógica para obtener:
    // - Número de tickets escaneados
    // - Rutas completadas
    // - Horas trabajadas
    // - etc.
    
    // Por ahora devolvemos datos de ejemplo
    res.json({
      ticketsScanned: 0,
      routesCompleted: 0,
      hoursWorked: 0,
      rating: 0,
    });
  } catch (error) {
    console.error('Error al obtener estadísticas:', error);
    res.status(500).json({ message: 'Error al obtener estadísticas', error: error.message });
  }
}; 