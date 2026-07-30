require('dotenv').config();
const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const morgan = require('morgan');
const compression = require('compression');
const rateLimit = require('express-rate-limit');
const http = require('http');

const connectDB = require('./config/db');
const config = require('./config');
const { errorHandler, notFound } = require('./middleware/error');
const socketService = require('./utils/socketService');

// Import routes
const authRoutes = require('./routes/auth');
const restaurantRoutes = require('./routes/restaurants');
const productRoutes = require('./routes/products');
const orderRoutes = require('./routes/orders');

// Initialize Express app
const app = express();

// Create HTTP server
const server = http.createServer(app);

// Initialize Socket.IO
socketService.init(server);

// Connect to database
connectDB();

// Middleware
app.use(helmet()); // Security headers
app.use(cors()); // Enable CORS
app.use(compression()); // Compress responses
app.use(morgan('dev')); // Logging
app.use(express.json()); // Parse JSON
app.use(express.urlencoded({ extended: true })); // Parse URL-encoded data

// Rate limiting
const limiter = rateLimit({
  windowMs: config.rateLimit.windowMs,
  max: config.rateLimit.maxRequests,
  message: 'Too many requests from this IP, please try again later.'
});
app.use('/api', limiter);

// Routes
app.use('/api/auth', authRoutes);
app.use('/api/restaurants', restaurantRoutes);
app.use('/api/products', productRoutes);
app.use('/api/orders', orderRoutes);

// Health check endpoint
app.get('/api/health', (req, res) => {
  res.status(200).json({
    success: true,
    message: 'Pakistan Food Delivery API is running',
    timestamp: new Date().toISOString(),
    environment: config.env
  });
});

// Socket stats endpoint
app.get('/api/socket-stats', (req, res) => {
  res.status(200).json({
    success: true,
    data: socketService.getStats()
  });
});

// Error handling
app.use(notFound);
app.use(errorHandler);

// Start server
const PORT = config.port || 5000;

server.listen(PORT, () => {
  console.log(`
╔═══════════════════════════════════════════════════════════╗
║                                                           ║
║   🚀 Pakistan Food & Grocery Delivery API                 ║
║                                                           ║
║   Server running on port ${PORT}                            ║
║   Environment: ${config.env.padEnd(36)}║
║   Time: ${new Date().toLocaleString('en-PK').padEnd(41)}║
║                                                           ║
║   Supported Cities:                                       ║
║   • Karachi • Lahore • Islamabad • Rawalpindi            ║
║   • Faisalabad • Multan • Peshawar • Quetta              ║
║                                                           ║
║   Payment Methods:                                        ║
║   • Cash on Delivery • JazzCash • EasyPaisa              ║
║                                                           ║
╚═══════════════════════════════════════════════════════════╝
  `);
});

module.exports = { app, server };
