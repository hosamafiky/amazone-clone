const express = require("express");
const productRouter = express.Router();
const auth = require("../middlewares/auth");
const { Product } = require("../models/product");

// Get Deal of day..
productRouter.get("/api/dealofday", auth, async (request, response) => {
  try {
    let products = await Product.find({});

    products = products.sort((a, b) => {
      let aSum = 0;
      let bSum = 0;
      for (let i = 0; i < a.rating.length; i++) {
        aSum += a.rating[i].rating;
      }
      for (let i = 0; i < b.rating.length; i++) {
        bSum += b.rating[i].rating;
      }

      return aSum < bSum ? 1 : -1;
    });

    response.json(products[0]);
  } catch (error) {
    response.status(500).json({ message: error.message });
  }
});

// Get Category Products..
productRouter.get("/api/products", auth, async (request, response) => {
  try {
    const products = await Product.find({ category: request.query.category });
    response.json(products);
  } catch (error) {
    response.status(500).json({ message: error.message });
  }
});

// Search for Products
productRouter.get("/api/products/search", auth, async (request, response) => {
  try {
    const products = await Product.find({
      name: { $regex: request.query.name, $options: "i" },
    });
    response.json(products);
  } catch (error) {
    response.status(500).json({ message: error.message });
  }
});

//Rate Product
productRouter.post("/api/rateProduct", auth, async (request, response) => {
  try {
    const { id, rating } = request.body;
    let product = await Product.findById(id);

    for (let i = 0; i < product.rating.length; i++) {
      if (product.rating[i].userId == request.user) {
        product.rating.splice(i, 1);
        break;
      }
    }

    const ratingSchema = {
      userId: request.user,
      rating,
    };

    product.rating.push(ratingSchema);
    product = await product.save();
    response.json(product);
  } catch (error) {
    response.status(500).json({ message: error.message });
  }
});

module.exports = productRouter;
