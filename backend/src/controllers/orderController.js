const express = require('express');
const router = express.Router();
const Order = require('../models/Order');
const Product = require('../models/Product');
const Restaurant = require('../models/Restaurant');
const Rider = require('../models/Rider');
const { protect, authorize } = require('../middleware/auth');

// @desc    Create new order
// @route   POST /api/orders
// @access  Private (Customer)
exports.createOrder = async (req, res, next) => {
  try {
    const { items, deliveryAddress, paymentMethod, specialInstructions } = req.body;

    // Validate items
    if (!items || items.length === 0) {
      return res.status(400).json({
        success: false,
        message: 'Please add at least one item to your order'
      });
    }

    // Get restaurant from first item
    const firstItem = await Product.findById(items[0].product);
    if (!firstItem) {
      return res.status(404).json({
        success: false,
        message: 'Product not found'
      });
    }

    // Calculate subtotal
    let subtotal = 0;
    for (const item of items) {
      const product = await Product.findById(item.product);
      if (!product) {
        return res.status(404).json({
          success: false,
          message: `Product ${item.product} not found`
        });
      }
      subtotal += product.price * item.quantity;
      // Add customization prices
      if (item.customizations) {
        item.customizations.forEach(custom => {
          subtotal += custom.additionalPrice || 0;
        });
      }
    }

    // Get restaurant details
    const restaurant = await Restaurant.findById(firstItem.restaurant);
    if (!restaurant) {
      return res.status(404).json({
        success: false,
        message: 'Restaurant not found'
      });
    }

    // Calculate fees
    const deliveryFee = restaurant.deliveryFee || 150;
    const tax = subtotal * 0.13; // 13% GST (Pakistan standard)
    const totalAmount = subtotal + deliveryFee + tax;

    // Create order
    const order = await Order.create({
      customer: req.user.id,
      restaurant: firstItem.restaurant,
      items,
      deliveryAddress,
      subtotal,
      deliveryFee,
      tax,
      totalAmount,
      paymentMethod: paymentMethod || 'Cash on Delivery',
      specialInstructions,
      estimatedDeliveryTime: new Date(Date.now() + (restaurant.deliveryTime?.max || 45) * 60000)
    });

    // Update product order count
    for (const item of items) {
      await Product.findByIdAndUpdate(item.product, {
        $inc: { totalOrders: item.quantity }
      });
    }

    res.status(201).json({
      success: true,
      message: 'Order placed successfully',
      data: order
    });
  } catch (error) {
    next(error);
  }
};

// @desc    Get customer orders
// @route   GET /api/orders/my-orders
// @access  Private (Customer)
exports.getMyOrders = async (req, res, next) => {
  try {
    const { status, page = 1, limit = 10 } = req.query;
    
    const query = { customer: req.user.id };
    
    if (status) {
      query.status = status;
    }
    
    const orders = await Order.find(query)
      .populate('restaurant', 'name address images cuisineType')
      .populate('rider', 'user phone vehicleType')
      .sort({ createdAt: -1 })
      .limit(limit * 1)
      .skip((page - 1) * limit);
    
    const count = await Order.countDocuments(query);
    
    res.status(200).json({
      success: true,
      count: orders.length,
      total: count,
      pages: Math.ceil(count / limit),
      currentPage: page,
      data: orders
    });
  } catch (error) {
    next(error);
  }
};

// @desc    Get single order
// @route   GET /api/orders/:id
// @access  Private
exports.getOrder = async (req, res, next) => {
  try {
    const order = await Order.findById(req.params.id)
      .populate('customer', 'name phone email')
      .populate('restaurant', 'name address phone')
      .populate('rider', 'user phone vehicleType currentLocation')
      .populate('items.product', 'name images');
    
    if (!order) {
      return res.status(404).json({
        success: false,
        message: 'Order not found'
      });
    }
    
    // Check authorization
    if (
      order.customer._id.toString() !== req.user.id &&
      req.user.role !== 'admin' &&
      (order.rider && order.rider.user.toString() !== req.user.id)
    ) {
      return res.status(403).json({
        success: false,
        message: 'Not authorized to view this order'
      });
    }
    
    res.status(200).json({
      success: true,
      data: order
    });
  } catch (error) {
    next(error);
  }
};

// @desc    Update order status
// @route   PUT /api/orders/:id/status
// @access  Private (Restaurant, Rider, Admin)
exports.updateOrderStatus = async (req, res, next) => {
  try {
    const { status } = req.body;
    
    const order = await Order.findById(req.params.id)
      .populate('restaurant')
      .populate('rider');
    
    if (!order) {
      return res.status(404).json({
        success: false,
        message: 'Order not found'
      });
    }
    
    // Check authorization
    const isRestaurant = order.restaurant.owner.toString() === req.user.id;
    const isRider = order.rider && order.rider.user.toString() === req.user.id;
    const isAdmin = req.user.role === 'admin';
    
    if (!isRestaurant && !isRider && !isAdmin) {
      return res.status(403).json({
        success: false,
        message: 'Not authorized to update this order'
      });
    }
    
    order.status = status;
    
    if (status === 'Delivered') {
      order.actualDeliveryTime = new Date();
    }
    
    await order.save();
    
    res.status(200).json({
      success: true,
      message: 'Order status updated successfully',
      data: order
    });
  } catch (error) {
    next(error);
  }
};

// @desc    Cancel order
// @route   PUT /api/orders/:id/cancel
// @access  Private (Customer, Admin)
exports.cancelOrder = async (req, res, next) => {
  try {
    const { reason } = req.body;
    
    const order = await Order.findById(req.params.id);
    
    if (!order) {
      return res.status(404).json({
        success: false,
        message: 'Order not found'
      });
    }
    
    // Only allow cancellation if order is still pending or confirmed
    if (!['Pending', 'Confirmed', 'Preparing'].includes(order.status)) {
      return res.status(400).json({
        success: false,
        message: 'Order cannot be cancelled at this stage'
      });
    }
    
    // Check authorization
    if (order.customer.toString() !== req.user.id && req.user.role !== 'admin') {
      return res.status(403).json({
        success: false,
        message: 'Not authorized to cancel this order'
      });
    }
    
    order.status = 'Cancelled';
    order.cancellationReason = reason;
    await order.save();
    
    res.status(200).json({
      success: true,
      message: 'Order cancelled successfully',
      data: order
    });
  } catch (error) {
    next(error);
  }
};

// @desc    Rate order
// @route   POST /api/orders/:id/rate
// @access  Private (Customer)
exports.rateOrder = async (req, res, next) => {
  try {
    const { value, comment } = req.body;
    
    const order = await Order.findById(req.params.id);
    
    if (!order) {
      return res.status(404).json({
        success: false,
        message: 'Order not found'
      });
    }
    
    if (order.customer.toString() !== req.user.id) {
      return res.status(403).json({
        success: false,
        message: 'Not authorized to rate this order'
      });
    }
    
    if (order.status !== 'Delivered') {
      return res.status(400).json({
        success: false,
        message: 'Can only rate delivered orders'
      });
    }
    
    order.rating = { value, comment };
    await order.save();
    
    // Update restaurant rating
    const Review = require('../models/Review');
    await Review.create({
      order: order._id,
      customer: req.user.id,
      restaurant: order.restaurant,
      rider: order.rider,
      rating: value,
      comment: comment,
      isApproved: true
    });
    
    res.status(200).json({
      success: true,
      message: 'Order rated successfully',
      data: order
    });
  } catch (error) {
    next(error);
  }
};

module.exports = router;
