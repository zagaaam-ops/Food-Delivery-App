const express = require('express');
const stripe = require('stripe');

const router = express.Router();

// Initialize Stripe (for card payments)
let stripeInstance;
if (process.env.STRIPE_SECRET_KEY) {
  stripeInstance = stripe(process.env.STRIPE_SECRET_KEY);
}

// @route   POST /api/payment/create-intent
// @desc    Create payment intent for card payment
// @access  Private
router.post('/create-intent', async (req, res) => {
  try {
    const { amount, orderId } = req.body;

    if (!stripeInstance) {
      return res.status(500).json({ 
        message: 'Payment gateway not configured' 
      });
    }

    const paymentIntent = await stripeInstance.paymentIntents.create({
      amount: Math.round(amount * 100), // Convert to cents
      currency: 'pkr',
      metadata: {
        orderId
      },
      payment_method_types: ['card']
    });

    res.json({
      clientSecret: paymentIntent.client_secret,
      paymentIntentId: paymentIntent.id
    });
  } catch (error) {
    res.status(500).json({ 
      message: error.message 
    });
  }
});

// @route   POST /api/payment/jazzcash
// @desc    Process JazzCash payment
// @access  Private
router.post('/jazzcash', async (req, res) => {
  try {
    const { amount, orderId, phoneNumber } = req.body;

    // Mock JazzCash integration
    // In production, integrate with actual JazzCash API
    console.log(`Processing JazzCash payment: PKR ${amount} for order ${orderId}`);
    
    // Simulate payment request
    const mockResponse = {
      status: 'pending',
      transactionId: `JC${Date.now()}`,
      message: 'Payment request sent to customer phone'
    };

    res.json(mockResponse);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

// @route   POST /api/payment/easypaisa
// @desc    Process EasyPaisa payment
// @access  Private
router.post('/easypaisa', async (req, res) => {
  try {
    const { amount, orderId, phoneNumber } = req.body;

    // Mock EasyPaisa integration
    // In production, integrate with actual EasyPaisa API
    console.log(`Processing EasyPaisa payment: PKR ${amount} for order ${orderId}`);
    
    const mockResponse = {
      status: 'pending',
      transactionId: `EP${Date.now()}`,
      message: 'Payment request sent to customer phone'
    };

    res.json(mockResponse);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

// @route   POST /api/payment/verify
// @desc    Verify payment status
// @access  Private
router.post('/verify', async (req, res) => {
  try {
    const { transactionId, paymentMethod } = req.body;

    // Mock verification
    // In production, verify with respective payment gateway
    const mockVerification = {
      success: true,
      status: 'paid',
      transactionId
    };

    res.json(mockVerification);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

module.exports = router;
