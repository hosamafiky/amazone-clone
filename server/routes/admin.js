const express = require("express");
const adminRouter = express.Router();
const admin = require("../middlewares/admin");
const { Product } = require("../models/product");

// Get Products..
adminRouter.get("/admin/getProducts", admin, async (request, response) => {
  try {
    const products = await Product.find({});
    response.json(products);
  } catch (error) {
    response.status(500).json({ message: error.message });
  }
});

// Add Product
adminRouter.post("/admin/addProduct", admin, async (request, response) => {
  try {
    const { name, description, images, price, quantity, category } =
      request.body;

    let product = Product({
      name,
      description,
      images,
      price,
      quantity,
      category,
    });

    product = await product.save();
    response.json(product);
  } catch (error) {
    response.status(500).json({ message: error.message });
  }
});

// Delete Product
adminRouter.post("/admin/deleteProduct", admin, async (request, response) => {
  try {
    const { id } = request.body;

    let product = await Product.findByIdAndDelete(id);
    response.json(product);
  } catch (error) {
    response.status(500).json({ message: error.message });
  }
});

module.exports = adminRouter;
