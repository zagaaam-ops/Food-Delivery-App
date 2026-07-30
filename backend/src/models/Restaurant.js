const mongoose = require('mongoose');

const restaurantSchema = new mongoose.Schema({
  name: {
    type: String,
    required: [true, 'Restaurant name is required'],
    trim: true
  },
  description: {
    type: String,
    maxlength: 1000
  },
  owner: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  cuisineType: [{
    type: String,
    enum: ['Pakistani', 'Chinese', 'Continental', 'Fast Food', 'Italian', 'Indian', 'BBQ', 'Desserts', 'Beverages', 'Other']
  }],
  address: {
    street: String,
    city: {
      type: String,
      enum: ['Karachi', 'Lahore', 'Islamabad', 'Rawalpindi', 'Faisalabad', 'Multan', 'Peshawar', 'Quetta', 'Other'],
      required: true
    },
    area: {
      type: String,
      required: true
    },
    latitude: Number,
    longitude: Number
  },
  phone: {
    type: String,
    required: true,
    match: [/^(\+92|0)?3\d{9}$/, 'Please enter a valid Pakistan phone number']
  },
  email: {
    type: String,
    lowercase: true,
    trim: true
  },
  images: [{
    type: String
  }],
  logo: {
    type: String
  },
  openingHours: {
    monday: { open: String, close: String },
    tuesday: { open: String, close: String },
    wednesday: { open: String, close: String },
    thursday: { open: String, close: String },
    friday: { open: String, close: String },
    saturday: { open: String, close: String },
    sunday: { open: String, close: String }
  },
  deliveryTime: {
    min: { type: Number, default: 20 },
    max: { type: Number, default: 45 }
  },
  minimumOrder: {
    type: Number,
    default: 0
  },
  deliveryFee: {
    type: Number,
    default: 0
  },
  rating: {
    type: Number,
    default: 0,
    min: 0,
    max: 5
  },
  totalReviews: {
    type: Number,
    default: 0
  },
  isActive: {
    type: Boolean,
    default: true
  },
  isVerified: {
    type: Boolean,
    default: false
  },
  documents: [{
    type: String
  }]
}, {
  timestamps: true
});

// Index for geospatial queries
restaurantSchema.index({ 'address.latitude': 1, 'address.longitude': 1 });

module.exports = mongoose.model('Restaurant', restaurantSchema);
