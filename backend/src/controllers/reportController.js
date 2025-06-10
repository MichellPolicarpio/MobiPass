const Report = require('../models/report');

// Crear un nuevo reporte
exports.createReport = async (req, res) => {
  try {
    const { driverLicense, route, complaint } = req.body;
    const report = new Report({
      driverLicense,
      route,
      complaint,
      userId: req.user._id, // El ID del usuario se obtiene del middleware de autenticación
    });

    await report.save();
    res.status(201).json({
      ...report.toObject(),
      _id: report._id.toString()
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// Obtener todos los reportes del usuario
exports.getReports = async (req, res) => {
  try {
    const reports = await Report.find({ userId: req.user._id })
      .sort({ createdAt: -1 }); // Ordenar por fecha de creación, más recientes primero
    
    // Convertir los IDs de ObjectId a String
    const formattedReports = reports.map(report => ({
      ...report.toObject(),
      _id: report._id.toString()
    }));
    
    res.json(formattedReports);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// Obtener un reporte específico
exports.getReport = async (req, res) => {
  try {
    const report = await Report.findOne({
      _id: req.params.id,
      userId: req.user._id,
    });
    
    if (!report) {
      return res.status(404).json({ message: 'Reporte no encontrado' });
    }
    
    res.json({
      ...report.toObject(),
      _id: report._id.toString()
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// Actualizar un reporte
exports.updateReport = async (req, res) => {
  try {
    const report = await Report.findOneAndUpdate(
      {
        _id: req.params.id,
        userId: req.user._id,
      },
      req.body,
      { new: true }
    );

    if (!report) {
      return res.status(404).json({ message: 'Reporte no encontrado' });
    }

    res.json({
      ...report.toObject(),
      _id: report._id.toString()
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// Eliminar un reporte
exports.deleteReport = async (req, res) => {
  try {
    const report = await Report.findOneAndDelete({
      _id: req.params.id,
      userId: req.user._id,
    });

    if (!report) {
      return res.status(404).json({ message: 'Reporte no encontrado' });
    }

    res.json({ message: 'Reporte eliminado' });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// Admin: Get all reports
exports.getAllReports = async (req, res) => {
  try {
    // Verificar si el usuario es admin
    if (req.user.role !== 'admin') {
      return res.status(403).json({ message: 'Acceso denegado' });
    }

    const reports = await Report.find()
      .sort({ createdAt: -1 })
      .populate('userId', 'name email');
    
    res.json(reports);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// Admin: Update report status
exports.updateReportStatus = async (req, res) => {
  try {
    // Verificar si el usuario es admin
    if (req.user.role !== 'admin') {
      return res.status(403).json({ message: 'Acceso denegado' });
    }

    const { status } = req.body;
    
    if (!['pendiente', 'en proceso', 'resuelto'].includes(status)) {
      return res.status(400).json({ message: 'Estado no válido' });
    }

    const report = await Report.findByIdAndUpdate(
      req.params.id,
      { status },
      { new: true }
    );

    if (!report) {
      return res.status(404).json({ message: 'Reporte no encontrado' });
    }

    res.json(report);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
}; 