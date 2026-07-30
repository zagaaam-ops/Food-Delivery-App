const express = require('express');
const Order = require('../models/Order');
const Product = require('../models/Product');
const Store = require('../models/Store');

const router = express.Router();

// Middleware to protect routes (simplified version)
const protect = async (req, res, next) => {
  // In production, add JWT verification here
  next();
};

// @route   GET /api/orders
// @desc    Get all orders for a user or all orders (admin)
// @access  Private
router.get('/', protect, async (req, res) => {
  try {
    const { userId, status } = req.query;
    
    let query = {};
    if (userId) query.customer = userId;
    if (status) query.status = status;

    const orders = await Order.find(query)
      .populate('customer', 'name phone')
      .populate('store', 'name nameUrdu')
      .populate('rider', 'name phone')
      .sort({ createdAt: -1 });

    res.json(orders);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

// @route   GET /api/orders/:id
// @desc    Get single order
// @access  Private
router.get('/:id', protect, async (req, res) => {
  try {
    const order = await Order.findById(req.params.id)
      .populate('customer', 'name phone email')
      .populate('store', 'name nameUrdu address phone')
      .populate('rider', 'name phone');

    if (!order) {
      return res.status(404).json({ message: 'Order not found' });
    }

    res.json(order);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

// @route   POST /api/orders
// @desc    Create new order
// @access  Private
router.post('/', protect, async (req, res) => {
  try {
    const {
      storeId,
      items,
      deliveryAddress,
      paymentMethod,
      specialInstructions,
      specialInstructionsUrdu
    } = req.body;

    // Get store details
    const store = await Store.findById(storeId);
    if (!store) {
      return res.status(404).json({ message: 'Store not found' });
    }

    // Calculate totals
    let subtotal = 0;
    const orderItems = [];

    for (const item of items) {
      const product = await Product.findById(item.productId);
      if (!product || !product.inStock) {
        return res.status(400).json({ 
          message: `Product ${item.name} is not available` 
        });
      }

      const total = product.price * item.quantity;
      subtotal += total;

      orderItems.push({
        product: product._id,
        name: product.name,
        nameUrdu: product.nameUrdu,
        quantity: item.quantity,
        price: product.price,
        total
      });
    }

    const tax = subtotal * 0.13; // 13% GST in Pakistan
    const totalAmount = subtotal + tax + store.deliveryFee;

    // Create order
    const order = await Order.create({
      customer: req.user._id, // From JWT middleware
      store: storeId,
      items: orderItems,
      deliveryAddress,
      subtotal,
      tax,
      deliveryFee: store.deliveryFee,
      totalAmount,
      paymentMethod,
      specialInstructions,
      specialInstructionsUrdu,
      estimatedDeliveryTime: new Date(Date.now() + store.deliveryTime.max * 60000)
    });

    const populatedOrder = await Order.findById(order._id)
      .populate('customer', 'name phone')
      .populate('store', 'name nameUrdu');

    res.status(201).json(populatedOrder);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

// @route   PUT /api/orders/:id/status
// @desc    Update order status
// @access  Private (Store/Rider/Admin)
router.put('/:id/status', protect, async (req, res) => {
  try {
    const { status, note } = req.body;

    const order = await Order.findById(req.params.id);
    if (!order) {
      return res.status(404).json({ message: 'Order not found' });
    }

    order.status = status;
    if (note) {
      order.statusHistory.push({ status, note, timestamp: new Date() });
    }

    if (status === 'delivered') {
      order.actualDeliveryTime = new Date();
    }

    await order.save();

    const updatedOrder = await Order.findById(order._id)
      .populate('customer', 'name phone')
      .populate('store', 'name nameUrdu');

    res.json(updatedOrder);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

// @route   PUT /api/orders/:id/cancel
// @desc    Cancel order
// @access  Private
router.put('/:id/cancel', protect, async (req, res) => {
  try {
    const order = await Order.findById(req.params.id);
    
    if (!order) {
      return res.status(404).json({ message: 'Order not found' });
    }

    if (order.status !== 'placed' && order.status !== 'confirmed') {
      return res.status(400).json({ 
        message: 'Cannot cancel order at this stage' 
      });
    }

    order.status = 'cancelled';
    await order.save();

    res.json({ message: 'Order cancelled successfully' });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

module.exports = router;
