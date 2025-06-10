const mongoose = require('mongoose');
const Route = require('../models/Route');
const Bus = require('../models/Bus');

// Conexión a MongoDB
mongoose.connect('mongodb+srv://policarpio:policoria@mobipass.bxbu3sp.mongodb.net/?retryWrites=true&w=majority&appName=MobiPass')
  .then(() => console.log('Connected to MongoDB'))
  .catch(err => {
    console.error('Could not connect to MongoDB:', err);
    process.exit(1);
  });

// Datos de prueba
const routes = [
  {
    name: 'Ruta 1',
    origin: 'Ciudad A',
    destination: 'Ciudad B',
    price: 7.0,
    duration: 60, // minutos
  },
  {
    name: 'Ruta 2',
    origin: 'Ciudad B',
    destination: 'Ciudad C',
    price: 9.0,
    duration: 90, // minutos
  },
];

const buses = [
  {
    plateNumber: 'ABC123',
    model: 'Mercedes-Benz O500',
    capacity: 50,
  },
  {
    plateNumber: 'XYZ789',
    model: 'Volvo B7R',
    capacity: 45,
  },
];

// Función para inicializar datos
async function initData() {
  try {
    // Limpiar datos existentes
    await Route.deleteMany({});
    await Bus.deleteMany({});

    // Crear rutas
    const createdRoutes = await Route.create(routes);
    console.log('Rutas creadas:', createdRoutes);

    // Crear buses
    const createdBuses = await Bus.create(buses);
    console.log('Buses creados:', createdBuses);

    console.log('Datos inicializados exitosamente');
    process.exit(0);
  } catch (error) {
    console.error('Error al inicializar datos:', error);
    process.exit(1);
  }
}

// Ejecutar inicialización
initData(); 