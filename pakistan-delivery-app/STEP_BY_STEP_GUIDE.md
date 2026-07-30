# 🛒 Pakistan Food & Grocery Delivery App
## Complete Step-by-Step Guide for Non-Technical Users

Welcome! This guide will help you build and test your food/grocery delivery app for Pakistan **even if you have no coding experience**. The app allows:

- **Customers** to order food/groceries from local stores
- **Suppliers** (shop owners) to register and add their products with photos and prices
- Support for **Urdu and English** languages
- **Cash on Delivery** and **Card Payment** options

---

## 📋 What You Need Before Starting

### 1. Install Required Software (One-time setup)

#### A. Node.js (For the backend server) - ✅ ALREADY INSTALLED
Node.js is already installed on this system.

#### B. MongoDB (Database to store your data) - ⚠️ NEEDS SETUP

**Option 1: MongoDB Atlas (Cloud - RECOMMENDED for beginners)**
This is the easiest option - no installation needed!

1. Go to https://www.mongodb.com/cloud/atlas/register
2. Create a free account (use Google sign-in for fastest setup)
3. Click "Build a Database" → Choose "FREE" tier (M0)
4. Click "Create" (takes 2-3 minutes to provision)
5. Click "Connect" → "Connect your application"
6. Copy the connection string (looks like: `mongodb+srv://username:password@cluster...`)
7. IMPORTANT: Click "Network Access" → "Add IP Address" → "Allow Access from Anywhere" (0.0.0.0/0)

**Option 2: MongoDB Local (On this computer)**
If you prefer local database:
```bash
# Install MongoDB on this Linux system
sudo apt-get update
sudo apt-get install -y mongodb
sudo systemctl start mongodb
sudo systemctl enable mongodb
```
Connection string for local: `mongodb://localhost:27017/pakistan-delivery`

#### C. Flutter (For mobile app) - ⚠️ OPTIONAL FOR NOW
You can test the backend first without Flutter. Install later when ready for mobile testing.

#### D. Postman (For testing without mobile phone) - ✅ RECOMMENDED
Download from https://www.postman.com/downloads/ OR use curl commands in this guide.

---

## 🚀 Step 1: Set Up the Backend (Server)

The backend is like the "brain" of your app - it stores all data and handles orders.

### 1.1 Backend is Already Installed! ✅
All backend files are ready in `/workspace/pakistan-delivery-app/backend`

### 1.2 Dependencies Already Installed! ✅
Run this to verify:
```bash
cd /workspace/pakistan-delivery-app/backend
npm list
```

### 1.3 Configure MongoDB Connection

**CRITICAL STEP**: You MUST set up MongoDB before the app will work.

**If using MongoDB Atlas (Recommended):**
1. Edit the file: `/workspace/pakistan-delivery-app/backend/.env`
2. Replace the MONGODB_URI line with your Atlas connection string:
```
MONGODB_URI=mongodb+srv://YOUR_USERNAME:YOUR_PASSWORD@YOUR_CLUSTER.mongodb.net/pakistan-delivery?retryWrites=true&w=majority
```
3. Replace YOUR_USERNAME, YOUR_PASSWORD, and YOUR_CLUSTER with your actual values

**If using local MongoDB:**
The .env file already has the correct setting:
```
MONGODB_URI=mongodb://localhost:27017/pakistan-delivery
```

### 1.4 Start the Backend Server
```bash
cd /workspace/pakistan-delivery-app/backend
npm start
```

You should see:
```
MongoDB Connected: [cluster-name or localhost]
Server running on port 5000
```

✅ **Backend is now running!** Keep this window open.

⚠️ **If you see "buffering timed out" error**: MongoDB is not connected. Go back to step 1.3.

---

## 🧪 Step 2: Test the Backend APIs

Before setting up the mobile app, let's test the backend works correctly.

### 2.1 Test Health Check
Open a new terminal and run:
```bash
curl http://localhost:5000/api/health
```
Expected response: `{"status":"ok","message":"Pakistan Delivery API is running",...}`

### 2.2 Register as a Supplier (Shop Owner)

This is how local shop owners join your platform:

```bash
curl -X POST http://localhost:5000/api/stores/supplier/register \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Ali Khan",
    "phone": "03009876543",
    "email": "ali@shop.com",
    "password": "password123",
    "storeName": "Ali General Store",
    "category": "grocery",
    "address": {
      "street": "Shop #12, Main Market",
      "area": "Gulshan-e-Iqbal",
      "city": "Karachi"
    }
  }'
```

**Expected Response:**
```json
{
  "message": "Supplier registered successfully",
  "user": { "id": "...", "name": "Ali Khan", ... },
  "store": { "id": "...", "name": "Ali General Store" }
}
```

Save the `store.id` from the response - you'll need it next!

### 2.3 Add Products to the Store

Now add products that Ali will sell. Replace `STORE_ID` with the actual ID from previous step:

```bash
curl -X POST http://localhost:5000/api/stores/STORE_ID/products \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Basmati Rice",
    "nameUrdu": "باسمتی چاول",
    "description": "Premium quality basmati rice",
    "category": "grocery",
    "price": 250,
    "unit": "kg",
    "stockQuantity": 100
  }'
```

Add more products:

**Sugar (چینی):**
```bash
curl -X POST http://localhost:5000/api/stores/STORE_ID/products \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Sugar",
    "nameUrdu": "چینی",
    "category": "grocery",
    "price": 120,
    "unit": "kg",
    "stockQuantity": 50
  }'
```

**Flour (آٹا):**
```bash
curl -X POST http://localhost:5000/api/stores/STORE_ID/products \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Flour",
    "nameUrdu": "آٹا",
    "category": "grocery",
    "price": 90,
    "unit": "kg",
    "stockQuantity": 200
  }'
```

### 2.4 View All Products

```bash
curl http://localhost:5000/api/stores/STORE_ID/products
```

This returns all products in JSON format.

### 2.5 Register a Customer

```bash
curl -X POST http://localhost:5000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Ahmed Hassan",
    "phone": "03001234567",
    "email": "ahmed@email.com",
    "password": "customer123",
    "role": "customer"
  }'
```

### 2.6 Login as Customer

```bash
curl -X POST http://localhost:5000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "phone": "03001234567",
    "password": "customer123"
  }'
```

Save the `token` from response for authenticated requests.

---

## 📱 Step 3: Set Up the Mobile App (Optional)

The mobile app is what customers and suppliers will use on their phones.

### 3.1 Install Flutter (If not already installed)

Follow instructions at: https://docs.flutter.dev/get-started/install

### 3.2 Navigate to Mobile Folder
```bash
cd /workspace/pakistan-delivery-app/mobile
```

### 3.3 Install Flutter Dependencies
```bash
flutter pub get
```

### 3.4 Add Urdu Font
1. Download from: https://fonts.google.com/noto/specimen/Noto+Nastaliq+Urdu
2. Create folder: `assets/fonts/`
3. Place font file as: `NotoNastaliqUrdu-Regular.ttf`

### 3.5 Configure API Connection
Edit file: `mobile/lib/services/api_service.dart`
Set API URL to: `http://YOUR_COMPUTER_IP:5000/api`

### 3.6 Run the Mobile App
```bash
flutter run
```

---

## 📊 Step 4: Verify Everything Works

### Checklist:
- [ ] MongoDB is connected (no timeout errors)
- [ ] Backend server starts successfully
- [ ] Health check returns OK
- [ ] Can register as a supplier
- [ ] Can add products with Urdu names
- [ ] Can view products
- [ ] Can register as a customer
- [ ] Can login and get token

---

## 🔧 Troubleshooting Common Issues

### Issue 1: "Operation buffering timed out after 10000ms"
**This means MongoDB is NOT connected!**

**Solution for Atlas:**
1. Check your connection string in `.env` file
2. Make sure password doesn't contain special characters (encode them)
3. Verify you added 0.0.0.0/0 in Network Access
4. Wait 2-3 minutes after creating cluster

**Solution for Local MongoDB:**
```bash
sudo systemctl start mongodb
sudo systemctl status mongodb
```

### Issue 2: "Cannot connect to server"
**Solution:** 
- Make sure backend is running (`npm start`)
- Check port 5000 is not blocked by firewall

### Issue 3: "Module not found" errors
**Solution:**
```bash
cd /workspace/pakistan-delivery-app/backend
rm -rf node_modules
npm install
```

---

## 📈 Next Steps After Testing

Once everything works:

1. **Add Real Products**: Work with local shops to add their actual inventory
2. **Test Payments**: Integrate real JazzCash/EasyPaisa accounts  
3. **Deploy Backend**: Move from your computer to a cloud server
4. **Publish App**: Release on Google Play Store and Apple App Store
5. **Add Features**: 
   - Real-time order tracking
   - Push notifications
   - Rider/delivery person app
   - Admin dashboard

---

## 📞 Quick Reference Commands

**Start Backend:**
```bash
cd /workspace/pakistan-delivery-app/backend && npm start
```

**Register Supplier:**
```bash
curl -X POST http://localhost:5000/api/stores/supplier/register -H "Content-Type: application/json" -d '{"name":"Test","phone":"03009876543","email":"test@shop.com","password":"123456","storeName":"Test Store","category":"grocery","address":{"street":"Main St","area":"Test Area","city":"Karachi"}}'
```

**Check Health:**
```bash
curl http://localhost:5000/api/health
```

---

**Made with ❤️ in Pakistan** 🇵🇰

Good luck with your delivery business!
