const express = require('express');
const Store = require('../models/Store');
const Product = require('../models/Product');
const User = require('../models/User');

const router = express.Router();

// @route   POST /api/stores/supplier/register
// @desc    Register as a supplier/store owner
// @access  Public
router.post('/supplier/register', async (req, res) => {
  try {
    const { name, phone, email, password, storeName, category, address } = req.body;
    
    // Check if user already exists
    let user = await User.findOne({ phone });
    if (user) {
      return res.status(400).json({ message: 'User already exists with this phone number' });
    }
    
    // Create new user with supplier role
    user = new User({
      name,
      phone,
      email,
      password,
      role: 'supplier'
    });
    
    await user.save();
    
    // Create store for the supplier
    const store = new Store({
      name: storeName,
      owner: user._id,
      phone,
      address,
      category: category || 'grocery'
    });
    
    await store.save();
    
    res.status(201).json({
      message: 'Supplier registered successfully',
      user: {
        id: user._id,
        name: user.name,
        phone: user.phone,
        role: user.role
      },
      store: {
        id: store._id,
        name: store.name
      }
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

// @route   POST /api/stores/:storeId/products
// @desc    Add a product to store (for suppliers)
// @access  Private (Supplier only)
router.post('/:storeId/products', async (req, res) => {
  try {
    const { name, nameUrdu, description, descriptionUrdu, category, price, discountPrice, images, unit, stockQuantity } = req.body;
    const storeId = req.params.storeId;
    
    // Verify store exists and belongs to supplier
    const store = await Store.findById(storeId);
    if (!store) {
      return res.status(404).json({ message: 'Store not found' });
    }
    
    // Create new product
    const product = new Product({
      name,
      nameUrdu,
      description,
      descriptionUrdu,
      category,
      price,
      discountPrice,
      images: images || [],
      store: storeId,
      unit,
      stockQuantity,
      inStock: stockQuantity > 0
    });
    
    await product.save();
    
    res.status(201).json({
      message: 'Product added successfully',
      product
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

// @route   GET /api/stores/supplier/:supplierId/my-stores
// @desc    Get all stores owned by a supplier
// @access  Private (Supplier only)
router.get('/supplier/:supplierId/my-stores', async (req, res) => {
  try {
    const stores = await Store.find({ owner: req.params.supplierId })
      .select('name nameUrdu category address isActive rating createdAt')
      .sort({ createdAt: -1 });
    
    res.json(stores);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

// @route   GET /api/stores/:storeId/products
// @desc    Get all products for a store
// @access  Public
router.get('/:storeId/products', async (req, res) => {
  try {
    const products = await Product.find({ store: req.params.storeId })
      .select('name nameUrdu description descriptionUrdu price discountPrice images category unit inStock stockQuantity isPopular')
      .sort({ isPopular: -1, name: 1 });
    
    res.json(products);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

// @route   PUT /api/stores/products/:productId
// @desc    Update a product (for suppliers)
// @access  Private (Supplier only)
router.put('/products/:productId', async (req, res) => {
  try {
    const { name, nameUrdu, description, descriptionUrdu, price, discountPrice, stockQuantity, inStock } = req.body;
    
    const product = await Product.findById(req.params.productId);
    if (!product) {
      return res.status(404).json({ message: 'Product not found' });
    }
    
    // Update fields
    if (name) product.name = name;
    if (nameUrdu) product.nameUrdu = nameUrdu;
    if (description) product.description = description;
    if (descriptionUrdu) product.descriptionUrdu = descriptionUrdu;
    if (price !== undefined) product.price = price;
    if (discountPrice !== undefined) product.discountPrice = discountPrice;
    if (stockQuantity !== undefined) {
      product.stockQuantity = stockQuantity;
      product.inStock = stockQuantity > 0;
    }
    if (inStock !== undefined) product.inStock = inStock;
    
    await product.save();
    
    res.json({
      message: 'Product updated successfully',
      product
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

// @route   DELETE /api/stores/products/:productId
// @desc    Delete a product (for suppliers)
// @access  Private (Supplier only)
router.delete('/products/:productId', async (req, res) => {
  try {
    const product = await Product.findByIdAndDelete(req.params.productId);
    
    if (!product) {
      return res.status(404).json({ message: 'Product not found' });
    }
    
    res.json({ message: 'Product deleted successfully' });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

module.exports = router;
