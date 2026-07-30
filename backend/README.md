# Pakistan Food & Grocery Delivery App - Backend

A complete backend API for a food and grocery delivery service tailored for Pakistan.

## 🚀 Features

### Core Features
- **User Authentication** - JWT-based auth with email/phone login
- **Multi-role System** - Customer, Restaurant, Rider, Admin
- **Restaurant Management** - CRUD operations for restaurants
- **Product/Menu Management** - Full menu management with categories
- **Order Management** - Complete order lifecycle tracking
- **Real-time Updates** - Socket.IO for live order status and rider tracking
- **Pakistan-specific** - Cities, phone numbers, CNIC validation, local payment methods

### Payment Methods
- Cash on Delivery (COD)
- JazzCash
- EasyPaisa
- Credit/Debit Cards (Stripe)

### Supported Cities
- Karachi
- Lahore
- Islamabad
- Rawalpindi
- Faisalabad
- Multan
- Peshawar
- Quetta

## 📁 Project Structure

```
backend/
├── src/
│   ├── config/
│   │   ├── index.js          # App configuration
│   │   └── db.js             # Database connection
│   ├── controllers/
│   │   ├── authController.js
│   │   ├── restaurantController.js
│   │   ├── productController.js
│   │   └── orderController.js
│   ├── models/
│   │   ├── User.js
│   │   ├── Restaurant.js
│   │   ├── Product.js
│   │   ├── Order.js
│   │   ├── Rider.js
│   │   ├── Review.js
│   │   └── Coupon.js
│   ├── routes/
│   │   ├── auth.js
│   │   ├── restaurants.js
│   │   ├── products.js
│   │   └── orders.js
│   ├── middleware/
│   │   ├── auth.js           # JWT authentication
│   │   └── error.js          # Error handling
│   ├── utils/
│   │   └── socketService.js  # Socket.IO service
│   └── server.js             # Entry point
├── public/
│   └── uploads/              # File uploads
├── .env.example
├── package.json
└── README.md
```

## 🛠️ Installation

### Prerequisites
- Node.js (v14 or higher)
- MongoDB (v4.4 or higher)
- npm or yarn

### Setup Steps

1. **Clone the repository**
```bash
cd backend
```

2. **Install dependencies**
```bash
npm install
```

3. **Configure environment variables**
```bash
cp .env.example .env
```

Edit `.env` file with your credentials:
```env
PORT=5000
NODE_ENV=development
MONGODB_URI=mongodb://localhost:27017/pakistan_food_delivery
JWT_SECRET=your_super_secret_jwt_key
JAZZCASH_MERCHANT_ID=your_jazzcash_merchant_id
EASYPAISA_STORE_ID=your_easypaisa_store_id
GOOGLE_MAPS_API_KEY=your_google_maps_api_key
```

4. **Start MongoDB**
```bash
# On macOS
brew services start mongodb-community

# On Ubuntu
sudo systemctl start mongod

# Or using Docker
docker run -d -p 27017:27017 --name mongodb mongo:latest
```

5. **Run the server**
```bash
# Development mode
npm run dev

# Production mode
npm start
```

The server will start on `http://localhost:5000`

## 📡 API Endpoints

### Authentication
| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/auth/register` | Register new user |
| POST | `/api/auth/login` | Login user |
| GET | `/api/auth/me` | Get current user |
| PUT | `/api/auth/profile` | Update profile |

### Restaurants
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/restaurants` | Get all restaurants |
| GET | `/api/restaurants/:id` | Get single restaurant |
| POST | `/api/restaurants` | Create restaurant |
| PUT | `/api/restaurants/:id` | Update restaurant |
| DELETE | `/api/restaurants/:id` | Delete restaurant |

### Products
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/products` | Get all products |
| GET | `/api/products/:id` | Get single product |
| POST | `/api/products` | Create product |
| PUT | `/api/products/:id` | Update product |
| DELETE | `/api/products/:id` | Delete product |

### Orders
| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/orders` | Create order |
| GET | `/api/orders/my-orders` | Get user orders |
| GET | `/api/orders/:id` | Get single order |
| PUT | `/api/orders/:id/status` | Update order status |
| PUT | `/api/orders/:id/cancel` | Cancel order |
| POST | `/api/orders/:id/rate` | Rate order |

## 🔌 Socket.IO Events

### Client → Server
- `user_join` - User connects with userId and role
- `order_update` - Update order status
- `rider_location` - Update rider location
- `send_message` - Send chat message

### Server → Client
- `order_status_changed` - Order status updated
- `rider_location_update` - Rider location changed
- `new_order_available` - New order for riders
- `new_message` - New chat message

## 🧪 Testing

```bash
npm test
```

## 📝 Data Models

### User
- name, email, phone (Pakistan format)
- role (customer/restaurant/rider/admin)
- address with geolocation
- city (Pakistan cities)

### Restaurant
- name, description, cuisineType
- owner (ref to User)
- address with geolocation
- openingHours, deliveryTime
- rating, reviews

### Product
- name, description, category
- price, images
- customizations options
- availability status

### Order
- customer, restaurant, rider
- items with customizations
- deliveryAddress
- paymentMethod (COD/JazzCash/EasyPaisa)
- status tracking
- ratings

## 🔐 Security Features

- Password hashing with bcryptjs
- JWT authentication
- Role-based authorization
- Rate limiting
- Helmet security headers
- Input validation
- CORS protection

## 🌟 Pakistan-Specific Features

1. **Phone Validation** - Pakistan mobile number format (03XX-XXXXXXX)
2. **CNIC Validation** - Pakistan ID card format (XXXXX-XXXXXXX-X)
3. **Cities** - Major Pakistani cities predefined
4. **Payment** - JazzCash and EasyPaisa integration ready
5. **Currency** - PKR (Pakistani Rupee)
6. **Tax** - 13% GST configured
7. **Language** - English with Urdu support ready

## 📄 License

MIT License

## 👥 Support

For support, email support@pakfooddelivery.com
