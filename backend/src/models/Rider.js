const mongoose = require('mongoose');

const riderSchema = new mongoose.Schema({
  user: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  vehicleType: {
    type: String,
    enum: ['Motorcycle', 'Scooter', 'Bicycle', 'Car'],
    default: 'Motorcycle'
  },
  vehicleNumber: {
    type: String,
    required: [true, 'Vehicle number is required']
  },
  licenseNumber: String,
  cnic: {
    type: String,
    required: [true, 'CNIC is required'],
    match: [/^\d{5}-\d{7}-\d$/, 'Please enter a valid CNIC (e.g., 12345-1234567-1)']
  },
  currentLocation: {
    latitude: Number,
    longitude: Number,
    lastUpdated: Date
  },
  isAvailable: {
    type: Boolean,
    default: true
  },
  isOnline: {
    type: Boolean,
    default: false
  },
  rating: {
    type: Number,
    default: 0,
    min: 0,
    max: 5
  },
  totalDeliveries: {
    type: Number,
    default: 0
  },
  completedOrders: {
    type: Number,
    default: 0
  },
  cancelledOrders: {
    type: Number,
    default: 0
  },
  currentOrder: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Order'
  },
  documents: [{
    type: String
  }],
  bankDetails: {
    accountTitle: String,
    accountNumber: String,
    bankName: String,
    iban: String
  },
  earnings: {
    total: { type: Number, default: 0 },
    pending: { type: Number, default: 0 },
    withdrawn: { type: Number, default: 0 }
  }
}, {
  timestamps: true
});

riderSchema.index({ 'currentLocation.latitude': 1, 'currentLocation.longitude': 1 });

module.exports = mongoose.model('Rider', riderSchema);
