const mongoose = require('mongoose');

const config = {
  env: process.env.NODE_ENV || 'development',
  port: process.env.PORT || 5000,
  mongodbUri: process.env.MONGODB_URI || 'mongodb://localhost:27017/pakistan_food_delivery',
  jwtSecret: process.env.JWT_SECRET || 'default_secret_change_in_production',
  jwtExpire: process.env.JWT_EXPIRE || '7d',
  
  // Payment Gateway Config
  jazzcash: {
    merchantId: process.env.JAZZCASH_MERCHANT_ID,
    password: process.env.JAZZCASH_PASSWORD,
    integritySalt: process.env.JAZZCASH_INTEGRITY_SALT,
    sandbox: process.env.NODE_ENV === 'development'
  },
  
  easypaisa: {
    storeId: process.env.EASYPAISA_STORE_ID,
    sandbox: process.env.NODE_ENV === 'development'
  },
  
  stripe: {
    secretKey: process.env.STRIPE_SECRET_KEY
  },
  
  // File Upload
  maxFileSize: parseInt(process.env.MAX_FILE_SIZE) || 5 * 1024 * 1024,
  uploadPath: process.env.UPLOAD_PATH || 'public/uploads',
  
  // SMS Config (for Pakistan numbers)
  sms: {
    apiKey: process.env.SMS_API_KEY
  },
  
  // Google Maps
  googleMapsApiKey: process.env.GOOGLE_MAPS_API_KEY,
  
  // Cities we operate in
  cities: ['Karachi', 'Lahore', 'Islamabad', 'Rawalpindi', 'Faisalabad', 'Multan', 'Peshawar', 'Quetta'],
  
  // Cuisine Types
  cuisineTypes: ['Pakistani', 'Chinese', 'Continental', 'Fast Food', 'Italian', 'Indian', 'BBQ', 'Desserts', 'Beverages'],
  
  // Delivery Settings
  defaultDeliveryFee: 150, // PKR
  freeDeliveryAbove: 2000, // PKR
  defaultDeliveryTime: 30, // minutes
  
  // Rate Limiting
  rateLimit: {
    windowMs: 15 * 60 * 1000, // 15 minutes
    maxRequests: 100
  }
};

module.exports = config;
