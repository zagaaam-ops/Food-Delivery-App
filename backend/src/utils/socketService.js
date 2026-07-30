const express = require('express');
const http = require('http');
const socketIo = require('socket.io');
const Order = require('./models/Order');

class SocketService {
  constructor() {
    this.io = null;
    this.connectedUsers = new Map(); // userId -> socketId
    this.onlineRiders = new Set();
  }

  init(server) {
    this.io = socketIo(server, {
      cors: {
        origin: '*',
        methods: ['GET', 'POST']
      }
    });

    this.io.on('connection', (socket) => {
      console.log(`✅ Socket connected: ${socket.id}`);

      // User joins
      socket.on('user_join', ({ userId, role }) => {
        this.connectedUsers.set(userId, socket.id);
        
        if (role === 'rider') {
          this.onlineRiders.add(userId);
          this.io.emit('rider_online', { userId });
        }
        
        console.log(`User ${userId} (${role}) joined`);
      });

      // Order updates
      socket.on('order_update', async ({ orderId, status }) => {
        const order = await Order.findById(orderId)
          .populate('customer rider restaurant');
        
        if (order) {
          // Notify customer
          if (this.connectedUsers.has(order.customer._id.toString())) {
            this.io.to(this.connectedUsers.get(order.customer._id.toString()))
              .emit('order_status_changed', {
                orderId,
                status,
                estimatedTime: order.estimatedDeliveryTime
              });
          }
          
          // Notify rider
          if (order.rider && this.connectedUsers.has(order.rider._id.toString())) {
            this.io.to(this.connectedUsers.get(order.rider._id.toString()))
              .emit('order_status_changed', { orderId, status });
          }
          
          // Notify restaurant
          if (this.connectedUsers.has(order.restaurant.owner.toString())) {
            this.io.to(this.connectedUsers.get(order.restaurant.owner.toString()))
              .emit('order_status_changed', { orderId, status });
          }
        }
      });

      // Rider location update
      socket.on('rider_location', ({ userId, latitude, longitude }) => {
        // Broadcast to customers with active orders
        this.io.emit('rider_location_update', {
          userId,
          latitude,
          longitude,
          timestamp: new Date()
        });
      });

      // New order notification for nearby riders
      socket.on('new_order_for_riders', async ({ restaurantLocation, orderId }) => {
        // In a real app, you'd filter riders by proximity
        this.onlineRiders.forEach(riderId => {
          if (this.connectedUsers.has(riderId)) {
            this.io.to(this.connectedUsers.get(riderId))
              .emit('new_order_available', {
                orderId,
                restaurantLocation
              });
          }
        });
      });

      // Chat messages
      socket.on('send_message', ({ orderId, message, senderId }) => {
        // Broadcast to all parties in the order
        this.io.emit('new_message', {
          orderId,
          message,
          senderId,
          timestamp: new Date()
        });
      });

      // User disconnect
      socket.on('disconnect', () => {
        for (const [userId, socketId] of this.connectedUsers.entries()) {
          if (socketId === socket.id) {
            this.connectedUsers.delete(userId);
            
            if (this.onlineRiders.has(userId)) {
              this.onlineRiders.delete(userId);
              this.io.emit('rider_offline', { userId });
            }
            
            console.log(`User ${userId} disconnected`);
            break;
          }
        }
      });
    });

    return this.io;
  }

  // Emit order update to specific user
  emitToUser(userId, event, data) {
    if (this.connectedUsers.has(userId)) {
      this.io.to(this.connectedUsers.get(userId)).emit(event, data);
    }
  }

  // Broadcast to all connected clients
  broadcast(event, data) {
    this.io.emit(event, data);
  }

  // Get connected users count
  getStats() {
    return {
      totalConnected: this.connectedUsers.size,
      onlineRiders: this.onlineRiders.size
    };
  }
}

module.exports = new SocketService();
