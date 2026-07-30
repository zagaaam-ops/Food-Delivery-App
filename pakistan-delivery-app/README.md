# Pakistan Food/Grocery Delivery App

A complete food and grocery delivery application built for Pakistan with support for Urdu/English languages and local payment methods.

## Features

### 🇵🇰 Pakistan-Specific Features
- **Languages**: Full Urdu (اردو) and English support
- **Payment Methods**:
  - Cash on Delivery (COD)
  - Credit/Debit Card (Stripe)
  - JazzCash integration
  - EasyPaisa integration
- **Cities**: Karachi, Lahore, Islamabad, Rawalpindi, Faisalabad, Multan, Peshawar, Quetta
- **Phone Validation**: Pakistani format (03XXXXXXXXX)
- **Tax**: 13% GST included in calculations

### 📱 Mobile App (Flutter)
- Modern Material Design 3 UI
- Multi-language support with real-time switching
- State management with Provider
- User authentication
- Store browsing and search
- Shopping cart management
- Order tracking
- Profile management

### 🖥️ Backend (Node.js + Express)
- RESTful API
- MongoDB database
- JWT authentication
- User roles (customer, rider, store, admin)
- Order management
- Payment processing
- Store and product management

## Project Structure

```
pakistan-delivery-app/
├── backend/
│   ├── src/
│   │   ├── config/
│   │   │   └── db.js
│   │   ├── models/
│   │   │   ├── User.js
│   │   │   ├── Store.js
│   │   │   ├── Product.js
│   │   │   └── Order.js
│   │   ├── routes/
│   │   │   ├── auth.js
│   │   │   ├── orders.js
│   │   │   ├── stores.js
│   │   │   └── payment.js
│   │   └── server.js
│   ├── package.json
│   └── .env.example
│
└── mobile/
    ├── lib/
    │   ├── main.dart
    │   ├── localization/
    │   │   └── app_localizations.dart
    │   ├── providers/
    │   │   ├── auth_provider.dart
    │   │   ├── cart_provider.dart
    │   │   └── language_provider.dart
    │   ├── screens/
    │   │   ├── splash_screen.dart
    │   │   ├── login_screen.dart
    │   │   └── home_screen.dart
    │   ├── models/
    │   ├── widgets/
    │   └── services/
    ├── assets/
    │   ├── images/
    │   ├── icons/
    │   └── fonts/
    └── pubspec.yaml
```

## Getting Started

### Backend Setup

1. Navigate to backend directory:
```bash
cd pakistan-delivery-app/backend
```

2. Install dependencies:
```bash
npm install
```

3. Create `.env` file:
```bash
cp .env.example .env
```

4. Update environment variables in `.env`:
```
PORT=5000
MONGODB_URI=mongodb://localhost:27017/pakistan-delivery
JWT_SECRET=your-secret-key
STRIPE_SECRET_KEY=your_stripe_key
```

5. Start the server:
```bash
npm run dev
```

### Mobile App Setup

1. Navigate to mobile directory:
```bash
cd pakistan-delivery-app/mobile
```

2. Install dependencies:
```bash
flutter pub get
```

3. Add Urdu font:
   - Download Noto Nastaliq Urdu font
   - Place it in `assets/fonts/NotoNastaliqUrdu-Regular.ttf`

4. Run the app:
```bash
flutter run
```

## API Endpoints

### Authentication
- `POST /api/auth/register` - Register new user
- `POST /api/auth/login` - Login user
- `GET /api/auth/me` - Get current user

### Stores
- `GET /api/stores` - Get all stores
- `GET /api/stores/:id` - Get single store with products
- `GET /api/stores/nearby` - Get nearby stores

### Orders
- `GET /api/orders` - Get user orders
- `GET /api/orders/:id` - Get single order
- `POST /api/orders` - Create new order
- `PUT /api/orders/:id/status` - Update order status
- `PUT /api/orders/:id/cancel` - Cancel order

### Payment
- `POST /api/payment/create-intent` - Create Stripe payment intent
- `POST /api/payment/jazzcash` - Process JazzCash payment
- `POST /api/payment/easypaisa` - Process EasyPaisa payment
- `POST /api/payment/verify` - Verify payment

## Technologies Used

### Backend
- Node.js
- Express.js
- MongoDB & Mongoose
- JWT for authentication
- Bcrypt for password hashing
- Stripe for card payments

### Mobile
- Flutter
- Provider (state management)
- GoRouter (navigation)
- flutter_localizations
- HTTP/Dio for API calls

## Next Steps

1. **Complete Payment Integration**: 
   - Integrate actual JazzCash API
   - Integrate actual EasyPaisa API
   - Configure Stripe for Pakistan

2. **Add More Features**:
   - Real-time order tracking with maps
   - Push notifications
   - Rider app
   - Store dashboard
   - Admin panel

3. **Deployment**:
   - Deploy backend to cloud (AWS, DigitalOcean, etc.)
   - Publish mobile apps to Play Store and App Store

## License

This project is created for demonstration purposes.

---

Made with ❤️ in Pakistan
