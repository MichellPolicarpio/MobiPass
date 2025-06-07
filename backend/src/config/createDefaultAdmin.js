const Admin = require('../models/Admin');

async function createDefaultAdmin() {
  try {
    // Verificar si ya existe un admin
    const existingAdmin = await Admin.findOne({ email: 'admin@mobipass.com' });
    if (existingAdmin) {
      console.log('El administrador por defecto ya existe');
      return;
    }

    // Crear admin por defecto
    const defaultAdmin = new Admin({
      name: 'Administrador',
      email: 'admin@mobipass.com',
      password: 'Admin123!',
      role: 'admin',
    });

    await defaultAdmin.save();
    console.log('Administrador por defecto creado exitosamente');
  } catch (error) {
    console.error('Error al crear el administrador por defecto:', error);
  }
}

module.exports = createDefaultAdmin; 