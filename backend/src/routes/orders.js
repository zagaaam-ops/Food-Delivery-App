const express = require('express');
const router = express.Router();
const { protect } = require('../middleware/auth');
const {
  createOrder,
  getMyOrders,
  getOrder,
  updateOrderStatus,
  cancelOrder,
  rateOrder
} = require('../controllers/orderController');

router.use(protect);

router.route('/')
  .post(createOrder);

router.get('/my-orders', getMyOrders);

router.route('/:id')
  .get(getOrder);

router.put('/:id/status', updateOrderStatus);
router.put('/:id/cancel', cancelOrder);
router.post('/:id/rate', rateOrder);

module.exports = router;
