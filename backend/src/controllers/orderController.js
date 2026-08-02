const Order = require('../models/Order');
const Restaurant = require('../models/Restaurant');

exports.getOrders = async (req, res, next) => {
  try {
    let query = {};
    if (req.user.role === 'user') query.user = req.user.id;
    if (req.user.role === 'restaurant') {
      const restaurant = await Restaurant.findOne({ owner: req.user.id });
      if (restaurant) query.restaurant = restaurant._id;
    }
    if (req.user.role === 'rider') query.rider = req.user.id;

    const orders = await Order.find(query)
      .populate('user', 'name phone email')
      .populate('restaurant', 'name address')
      .populate('rider', 'name phone')
      .sort({ createdAt: -1 });

    res.status(200).json({ success: true, count: orders.length, data: orders });
  } catch (error) { next(error); }
};

exports.getOrder = async (req, res, next) => {
  try {
    const order = await Order.findById(req.params.id)
      .populate('user', 'name phone email')
      .populate('restaurant', 'name address phone')
      .populate('rider', 'name phone');
    
    if (!order) return res.status(404).json({ success: false, message: 'Order not found' });
    res.status(200).json({ success: true, data: order });
  } catch (error) { next(error); }
};

exports.createOrder = async (req, res, next) => {
  try {
    req.body.user = req.user.id;
    const order = await Order.create(req.body);
    res.status(201).json({ success: true, message: 'Order created successfully', data: order });
  } catch (error) { next(error); }
};

exports.updateOrderStatus = async (req, res, next) => {
  try {
    const { status } = req.body;
    const order = await Order.findById(req.params.id);
    if (!order) return res.status(404).json({ success: false, message: 'Order not found' });
    
    order.status = status;
    if (status === 'accepted' && req.user.role === 'rider') order.rider = req.user.id;
    
    await order.save();
    res.status(200).json({ success: true, message: 'Order status updated', data: order });
  } catch (error) { next(error); }
};

exports.cancelOrder = async (req, res, next) => {
  try {
    const order = await Order.findById(req.params.id);
    if (!order) return res.status(404).json({ success: false, message: 'Order not found' });
    if (order.user.toString() !== req.user.id && req.user.role !== 'admin') {
      return res.status(403).json({ success: false, message: 'Not authorized' });
    }
    order.status = 'cancelled';
    await order.save();
    res.status(200).json({ success: true, message: 'Order cancelled', data: order });
  } catch (error) { next(error); }
};

exports.rateOrder = async (req, res, next) => {
  try {
    const { rating, review } = req.body;
    const order = await Order.findById(req.params.id);
    if (!order) return res.status(404).json({ success: false, message: 'Order not found' });
    if (order.user.toString() !== req.user.id) {
      return res.status(403).json({ success: false, message: 'Not authorized' });
    }
    order.rating = rating;
    order.review = review;
    await order.save();
    res.status(200).json({ success: true, message: 'Order rated successfully', data: order });
  } catch (error) { next(error); }
};

exports.getMyOrders = async (req, res, next) => {
  try {
    const orders = await Order.find({ user: req.user.id })
      .populate('restaurant', 'name address')
      .populate('rider', 'name phone')
      .sort({ createdAt: -1 });
    
    res.status(200).json({ success: true, count: orders.length, data: orders });
  } catch (error) {
    next(error);
  }
};
