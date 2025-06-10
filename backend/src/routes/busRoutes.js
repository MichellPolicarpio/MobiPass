const express = require('express');
const router = express.Router();
const Bus = require('../models/Bus');

// Create or update bus
router.post('/', async (req, res) => {
  try {
    const { plateNumber, model, capacity, driver } = req.body;
    
    // Try to find existing bus by plate number
    let bus = await Bus.findOne({ plateNumber });
    
    if (bus) {
      // Update existing bus
      bus = await Bus.findOneAndUpdate(
        { plateNumber },
        { model, capacity, driver },
        { new: true }
      );
    } else {
      // Create new bus
      bus = new Bus({
        plateNumber,
        model,
        capacity,
        driver
      });
      await bus.save();
    }
    
    res.status(201).json(bus);
  } catch (error) {
    console.error('Error creating/updating bus:', error);
    res.status(500).json({ message: 'Error creating/updating bus', error: error.message });
  }
});

module.exports = router; 