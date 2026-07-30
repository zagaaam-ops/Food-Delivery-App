const express = require('express');
const router = express.Router();
const {
  getRestaurants,
  getRestaurant,
  createRestaurant,
  updateRestaurant,
  deleteRestaurant
} = require('../controllers/restaurantController');
const { protect, authorize } = require('../middleware/auth');

router.route('/')
  .get(getRestaurants)
  .post(protect, authorize('restaurant', 'admin'), createRestaurant);

router.route('/:id')
  .get(getRestaurant)
  .put(protect, authorize('restaurant', 'admin'), updateRestaurant)
  .delete(protect, authorize('admin'), deleteRestaurant);

module.exports = router;
