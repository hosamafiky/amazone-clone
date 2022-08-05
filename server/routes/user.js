const express = require("express");
const userRouter = express.Router();
const jwt = require("jsonwebtoken");
const User = require("../models/user");
const Order = require("../models/order");
const auth = require("../middlewares/auth");
const { Product } = require("../models/product");

// Validate Token
userRouter.post("/isTokenValid", auth, async (request, response) => {
  try {
    const token = request.header("x-auth-token");
    if (!token) return response.json(false);

    const verified = jwt.verify(token, "passwordKey");
    if (!verified) return response.json(false);

    const user = User.findById(verified.id);
    if (!user) return response.json(false);

    response.json(true);
  } catch (error) {
    response.status(500).json({ message: error.message });
  }
});

// Get user data
userRouter.get("/", auth, async (request, response) => {
  const user = await User.findById(request.user);
  response.json({ ...user._doc, token: request.token });
});

// Add product to Cart..
userRouter.post("/api/add-to-cart", auth, async (request, response) => {
  try {
    const { id } = request.body;

    const product = await Product.findById(id);
    let user = await User.findById(request.user);

    if (user.cart.length == 0) {
      user.cart.push({
        product,
        quantity: 1,
      });
    } else {
      let isProductFound = false;
      for (let i = 0; i < user.cart.length; i++) {
        if (user.cart[i].product._id.equals(product._id)) {
          isProductFound = true;
        }
      }
      if (isProductFound) {
        let desiredProduct = user.cart.find((desiredProduct) =>
          desiredProduct.product._id.equals(product._id)
        );
        desiredProduct.quantity += 1;
      } else {
        user.cart.push({ product, quantity: 1 });
      }
    }

    user = await user.save();
    response.json(user);
  } catch (error) {
    response.status(500).json({ message: error.message });
  }
});

// Remove product from Cart..
userRouter.delete("/api/remove-from-cart", auth, async (request, response) => {
  try {
    const { id } = request.body;

    const product = await Product.findById(id);
    let user = await User.findById(request.user);
    for (let i = 0; i < user.cart.length; i++) {
      if (user.cart[i].product._id.equals(product._id)) {
        let productToRemove = user.cart.find((productToRemove) =>
          productToRemove.product._id.equals(product._id)
        );
        if (productToRemove.quantity > 1) {
          productToRemove.quantity -= 1;
        } else {
          user.cart.splice(i, 1);
        }
      }
    }

    user = await user.save();
    response.json(user);
  } catch (error) {
    response.status(500).json({ message: error.message });
  }
});

// Update user address..
userRouter.post("/api/update-address", auth, async (request, response) => {
  try {
    const { address } = request.body;
    let user = await User.findById(request.user);

    user.address = address;

    user = await user.save();
    response.json(user);
  } catch (error) {
    response.status(500).json({ message: error.message });
  }
});

// Place an Order
userRouter.post("/api/order", auth, async (request, response) => {
  try {
    const { cart, totalAmount, address } = request.body;
    let products = [];

    for (let i = 0; i < cart.length; i++) {
      let product = await Product.findById(cart[i].product._id);
      if (product.quantity >= cart[i].quantity) {
        product.quantity -= cart[i].quantity;
        products.push({
          product,
          quantity: cart[i].quantity,
        });
        await product.save();
      } else {
        return response
          .status(400)
          .json({ message: "${producrt.name} is out of stock." });
      }
    }

    let user = await User.findById(request.user);
    user.cart = [];

    user = await user.save();

    let order = Order({
      products,
      userId: request.user,
      address,
      totalAmount,
      orderedAt: new Date().getTime(),
    });

    order = await order.save();
    response.json(order);
  } catch (error) {
    response.status(500).json({ message: error.message });
  }
});

// Get orders..
userRouter.get("/api/my-orders", auth, async (request, response) => {
  try {
    const orders = await Order.find({ userId: request.user });
    response.json(orders);
  } catch (error) {
    response.status(500).json({ message: error.message });
  }
});

module.exports = userRouter;
