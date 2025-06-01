const Route = require('../models/Route');

// Get all routes
exports.getRoutes = async (req, res) => {
  try {
    const routes = await Route.find({ active: true })
      .populate('schedule.busId', 'plateNumber capacity model features');
    res.json(routes);
  } catch (error) {
    res.status(500).json({ message: 'Error fetching routes', error: error.message });
  }
};

// Get route by ID
exports.getRouteById = async (req, res) => {
  try {
    const route = await Route.findById(req.params.id)
      .populate('schedule.busId', 'plateNumber capacity model features');
    
    if (!route) {
      return res.status(404).json({ message: 'Route not found' });
    }
    
    res.json(route);
  } catch (error) {
    res.status(500).json({ message: 'Error fetching route', error: error.message });
  }
};

// Create new route
exports.createRoute = async (req, res) => {
  try {
    const route = new Route(req.body);
    await route.save();
    res.status(201).json(route);
  } catch (error) {
    res.status(400).json({ message: 'Error creating route', error: error.message });
  }
};

// Update route
exports.updateRoute = async (req, res) => {
  try {
    const route = await Route.findByIdAndUpdate(
      req.params.id,
      req.body,
      { new: true, runValidators: true }
    );
    
    if (!route) {
      return res.status(404).json({ message: 'Route not found' });
    }
    
    res.json(route);
  } catch (error) {
    res.status(400).json({ message: 'Error updating route', error: error.message });
  }
};

// Delete route (soft delete)
exports.deleteRoute = async (req, res) => {
  try {
    const route = await Route.findByIdAndUpdate(
      req.params.id,
      { active: false },
      { new: true }
    );
    
    if (!route) {
      return res.status(404).json({ message: 'Route not found' });
    }
    
    res.json({ message: 'Route deleted successfully' });
  } catch (error) {
    res.status(500).json({ message: 'Error deleting route', error: error.message });
  }
}; 