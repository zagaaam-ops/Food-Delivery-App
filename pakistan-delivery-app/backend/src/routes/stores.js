const express = require('express');
const Store = require('../models/Store');
const Product = require('../models/Product');

const router = express.Router();

// @route   GET /api/stores
// @desc    Get all stores with filters
// @access  Public
router.get('/', async (req, res) => {
  try {
    const { city, category, search } = req.query;

    let query = { isActive: true };
    
    if (city) query['address.city'] = city;
    if (category) query.category = category;
    
    if (search) {
      query.$or = [
        { name: { $regex: search, $options: 'i' } },
        { nameUrdu: { $regex: search, $options: 'i' } }
      ];
    }

    const stores = await Store.find(query)
      .select('name nameUrdu logo category address openingHours rating deliveryTime minimumOrder deliveryFee')
      .sort({ 'rating.average': -1 });

    res.json(stores);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

// @route   GET /api/stores/:id
// @desc    Get single store with products
// @access  Public
router.get('/:id', async (req, res) => {
  try {
    const store = await Store.findById(req.params.id);
    
    if (!store) {
      return res.status(404).json({ message: 'Store not found' });
    }

    const products = await Product.find({ store: store._id, inStock: true })
      .select('name nameUrdu description descriptionUrdu price discountPrice images category unit isPopular');

    res.json({
      ...store.toObject(),
      products
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

// @route   GET /api/stores/nearby
// @desc    Get stores near coordinates (simplified)
// @access  Public
router.get('/nearby', async (req, res) => {
  try {
    const { lat, lng, city } = req.query;

    let query = { isActive: true };
    
    if (city) {
      query['address.city'] = city;
    }

    // In production, use MongoDB geospatial queries
    const stores = await Store.find(query)
      .limit(20)
      .select('name nameUrdu logo category address rating deliveryTime');

    res.json(stores);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

module.exports = router;
