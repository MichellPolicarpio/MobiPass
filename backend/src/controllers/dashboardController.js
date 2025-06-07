const User = require('../models/User');
const Ticket = require('../models/Ticket');

exports.getDashboardStats = async (req, res) => {
  try {
    // Contar usuarios por rol
    const userCount = await User.countDocuments({ role: 'user' });
    const driverCount = await User.countDocuments({ role: 'driver' });
    
    // Contar tickets totales y activos
    const totalTickets = await Ticket.countDocuments();
    const activeTickets = await Ticket.countDocuments({ status: 'active' });

    // Obtener estadísticas de los últimos 7 días
    const sevenDaysAgo = new Date();
    sevenDaysAgo.setDate(sevenDaysAgo.getDate() - 7);

    const recentTickets = await Ticket.countDocuments({
      createdAt: { $gte: sevenDaysAgo }
    });

    const recentUsers = await User.countDocuments({
      createdAt: { $gte: sevenDaysAgo },
      role: 'user'
    });

    res.json({
      totalUsers: userCount,
      totalDrivers: driverCount,
      totalTickets,
      activeTickets,
      recentTickets,
      recentUsers,
    });
  } catch (error) {
    console.error('Error al obtener estadísticas del dashboard:', error);
    res.status(500).json({ message: 'Error al obtener estadísticas', error: error.message });
  }
}; 