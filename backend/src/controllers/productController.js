const express = require('express');
const router = express.Router();
const Product = require('../models/Product');
const { protect, authorize } = require('../middleware/auth');

// @desc    Get all products
// @route   GET /api/products
// @access  Public
exports.getProducts = async (req, res, next) => {
  try {
    const { restaurant, category, search, page = 1, limit = 20 } = req.query;
    
    const query = { isAvailable: true };
    
    if (restaurant) {
      query.restaurant = restaurant;
    }
    
    if (category) {
      query.category = category;
    }
    
    if (search) {
      query.name = { $regex: search, $options: 'i' };
    }
    
    const products = await Product.find(query)
      .populate('restaurant', 'name address cuisineType')
      .sort({ name: 1 })
      .limit(limit * 1)
      .skip((page - 1) * limit);
    
    const count = await Product.countDocuments(query);
    
    res.status(200).json({
      success: true,
      count: products.length,
      total: count,
      pages: Math.ceil(count / limit),
      currentPage: page,
      data: products
    });
  } catch (error) {
    next(error);
  }
};

// @desc    Get single product
// @route   GET /api/products/:id
// @access  Public
exports.getProduct = async (req, res, next) => {
  try {
    const product = await Product.findById(req.params.id)
      .populate('restaurant', 'name address phone openingHours');
    
    if (!product) {
      return res.status(404).json({
        success: false,
        message: 'Product not found'
      });
    }
    
    res.status(200).json({
      success: true,
      data: product
    });
  } catch (error) {
    next(error);
  }
};

// @desc    Create product
// @route   POST /api/products
// @access  Private (Restaurant)
exports.createProduct = async (req, res, next) => {
  try {
    // Verify user owns a restaurant
    const Restaurant = require('../models/Restaurant');
    const restaurant = await Restaurant.findOne({ owner: req.user.id });
    
    if (!restaurant) {
      return res.status(403).json({
        success: false,
        message: 'You must own a restaurant to add products'
      });
    }
    
    req.body.restaurant = restaurant._id;
    
    const product = await Product.create(req.body);
    
    res.status(201).json({
      success: true,
      message: 'Product created successfully',
      data: product
    });
  } catch (error) {
    next(error);
  }
};

// @desc    Update product
// @route   PUT /api/products/:id
// @access  Private (Restaurant owner)
exports.updateProduct = async (req, res, next) => {
  try {
    let product = await Product.findById(req.params.id);
    
    if (!product) {
      return res.status(404).json({
        success: false,
        message: 'Product not found'
      });
    }
    
    // Check ownership
    const Restaurant = require('../models/Restaurant');
    const restaurant = await Restaurant.findOne({ 
      _id: product.restaurant, 
      owner: req.user.id 
    });
    
    if (!restaurant && req.user.role !== 'admin') {
      return res.status(403).json({
        success: false,
        message: 'Not authorized to update this product'
      });
    }
    
    product = await Product.findByIdAndUpdate(req.params.id, req.body, {
      new: true,
      runValidators: true
    });
    
    res.status(200).json({
      success: true,
      message: 'Product updated successfully',
      data: product
    });
  } catch (error) {
    next(error);
  }
};

// @desc    Delete product
// @route   DELETE /api/products/:id
// @access  Private (Restaurant owner or Admin)
exports.deleteProduct = async (req, res, next) => {
  try {
    const product = await Product.findById(req.params.id);
    
    if (!product) {
      return res.status(404).json({
        success: false,
        message: 'Product not found'
      });
    }
    
    // Check ownership
    const Restaurant = require('../models/Restaurant');
    const restaurant = await Restaurant.findOne({ 
      _id: product.restaurant, 
      owner: req.user.id 
    });
    
    if (!restaurant && req.user.role !== 'admin') {
      return res.status(403).json({
        success: false,
        message: 'Not authorized to delete this product'
      });
    }
    
    await product.deleteOne();
    
    res.status(200).json({
      success: true,
      message: 'Product deleted successfully'
    });
  } catch (error) {
    next(error);
  }
};

module.exports = router;
