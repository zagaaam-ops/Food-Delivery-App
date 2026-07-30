const mongoose = require('mongoose');

const orderSchema = new mongoose.Schema({
  customer: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  store: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Store',
    required: true
  },
  rider: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User'
  },
  items: [{
    product: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'Product',
      required: true
    },
    name: String, // Snapshot of product name at order time
    nameUrdu: String,
    quantity: {
      type: Number,
      required: true,
      min: 1
    },
    price: {
      type: Number,
      required: true
    },
    total: {
      type: Number,
      required: true
    }
  }],
  deliveryAddress: {
    label: String,
    street: String,
    area: String,
    city: {
      type: String,
      required: true
    },
    houseNumber: String,
    coordinates: {
      latitude: Number,
      longitude: Number
    },
    phone: {
      type: String,
      required: true
    }
  },
  subtotal: {
    type: Number,
    required: true
  },
  deliveryFee: {
    type: Number,
    default: 0
  },
  tax: {
    type: Number,
    default: 0
  },
  discount: {
    type: Number,
    default: 0
  },
  totalAmount: {
    type: Number,
    required: true
  },
  paymentMethod: {
    type: String,
    required: true,
    enum: ['cod', 'card', 'jazzcash', 'easypaisa']
  },
  paymentStatus: {
    type: String,
    enum: ['pending', 'paid', 'failed'],
    default: 'pending'
  },
  paymentTransactionId: String,
  status: {
    type: String,
    enum: ['placed', 'confirmed', 'preparing', 'ready', 'picked_up', 'on_the_way', 'delivered', 'cancelled'],
    default: 'placed'
  },
  statusHistory: [{
    status: String,
    timestamp: {
      type: Date,
      default: Date.now
    },
    note: String
  }],
  specialInstructions: String,
  specialInstructionsUrdu: String,
  estimatedDeliveryTime: Date,
  actualDeliveryTime: Date,
  rating: {
    customer: {
      stars: Number,
      comment: String,
      commentUrdu: String
    },
    rider: {
      stars: Number,
      comment: String
    }
  },
  createdAt: {
    type: Date,
    default: Date.now
  }
});

// Add status to history when status changes
orderSchema.pre('save', function(next) {
  if (this.isModified('status')) {
    this.statusHistory.push({
      status: this.status,
      timestamp: new Date()
    });
  }
  next();
});

module.exports = mongoose.model('Order', orderSchema);
