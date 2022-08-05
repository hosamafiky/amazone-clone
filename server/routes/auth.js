const express = require("express");
const authRouter = express.Router();
const User = require("../models/user");
const bcryptJs = require("bcryptjs");
const jwt = require("jsonwebtoken");

// Sign up
authRouter.post("/api/signup", async (request, response) => {
  try {
    const { name, email, password } = request.body;
    const existingUser = await User.findOne({ email });
    if (existingUser) {
      return response
        .status(400)
        .json({ message: "This email is already used." });
    }

    const hashedPassword = await bcryptJs.hash(password, 8);
    let user = new User({
      name,
      email,
      password: hashedPassword,
    });

    user.save().then(() => {
      response.json(user);
    });
  } catch (error) {
    response.status(500).json({ message: error.message });
  }
});

// Sign in
authRouter.post("/api/signin", async (request, response) => {
  try {
    const { email, password } = request.body;
    const existUser = await User.findOne({ email });
    if (!existUser) {
      return response
        .status(400)
        .json({ message: "This email isn't registered, Sign up first." });
    }

    const isMatch = await bcryptJs.compare(password, existUser.password);
    if (!isMatch) {
      return response
        .status(400)
        .json({ message: "This password is incorrect." });
    }

    const token = jwt.sign({ id: existUser._id }, "passwordKey");

    response.json({ token, ...existUser._doc });
    console.log({ token, ...existUser._doc });
  } catch (error) {
    response.status(500).json({ message: error.message });
  }
});

module.exports = authRouter;
