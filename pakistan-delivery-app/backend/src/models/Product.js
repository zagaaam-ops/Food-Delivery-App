const mongoose = require('mongoose');

const productSchema = new mongoose.Schema({
  name: {
    type: String,
    required: true,
    trim: true
  },
  nameUrdu: {
    type: String, // Urdu translation
    trim: true
  },
  description: {
    type: String,
    trim: true
  },
  descriptionUrdu: {
    type: String
  },
  category: {
    type: String,
    required: true,
    enum: ['grocery', 'food', 'vegetables', 'fruits', 'dairy', 'bakery', 'beverages', 'snacks', 'other']
  },
  price: {
    type: Number,
    required: true,
    min: 0
  },
  discountPrice: {
    type: Number,
    min: 0
  },
  images: [{
    type: String
  }],
  store: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Store',
    required: true
  },
  inStock: {
    type: Boolean,
    default: true
  },
  stockQuantity: {
    type: Number,
    default: 0
  },
  unit: {
    type: String,
    enum: ['piece', 'kg', 'g', 'liter', 'ml', 'dozen'],
    default: 'piece'
  },
  isPopular: {
    type: Boolean,
    default: false
  },
  createdAt: {
    type: Date,
    default: Date.now
  }
});

productSchema.index({ name: 'text', nameUrdu: 'text' });

module.exports = mongoose.model('Product', productSchema);
