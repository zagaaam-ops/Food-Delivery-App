const mongoose = require('mongoose');

const storeSchema = new mongoose.Schema({
  name: {
    type: String,
    required: true,
    trim: true
  },
  nameUrdu: {
    type: String
  },
  description: {
    type: String
  },
  owner: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  phone: {
    type: String,
    required: true,
    match: [/^03\d{9}$/, 'Please enter a valid Pakistani phone number']
  },
  address: {
    street: String,
    area: {
      type: String,
      required: true
    },
    city: {
      type: String,
      required: true,
      enum: ['Karachi', 'Lahore', 'Islamabad', 'Rawalpindi', 'Faisalabad', 'Multan', 'Peshawar', 'Quetta', 'Other']
    },
    coordinates: {
      latitude: Number,
      longitude: Number
    }
  },
  category: {
    type: String,
    required: true,
    enum: ['restaurant', 'grocery', 'supermarket', 'pharmacy', 'bakery', 'other']
  },
  images: [{
    type: String
  }],
  logo: {
    type: String
  },
  openingHours: {
    open: String, // e.g., "09:00"
    close: String // e.g., "23:00"
  },
  deliveryTime: {
    min: { type: Number, default: 30 }, // minutes
    max: { type: Number, default: 60 }
  },
  minimumOrder: {
    type: Number,
    default: 0
  },
  deliveryFee: {
    type: Number,
    default: 0
  },
  isActive: {
    type: Boolean,
    default: true
  },
  rating: {
    average: {
      type: Number,
      default: 0,
      min: 0,
      max: 5
    },
    count: {
      type: Number,
      default: 0
    }
  },
  createdAt: {
    type: Date,
    default: Date.now
  }
});

module.exports = mongoose.model('Store', storeSchema);
