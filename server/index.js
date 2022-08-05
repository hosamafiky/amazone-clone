const express = require("express");
const app = express();
const mongoose = require("mongoose");
const authRouter = require("./routes/auth");
const userRouter = require("./routes/user");
const productRouter = require("./routes/product");
const adminRouter = require("./routes/admin");

const PORT = process.env.PORT || 3000;
const mongooseUrl =
  "mongodb+srv://hussam:9121997h@cluster0.nogy4.mongodb.net/?retryWrites=true&w=majority";

// Middlewares
app.use(express.json());
app.use(authRouter);
app.use(userRouter);
app.use(productRouter);
app.use(adminRouter);

mongoose
  .connect(mongooseUrl)
  .then(() => {
    console.log("Connected to mongoose.");
  })
  .catch((e) => {
    console.log(e);
  });

app.listen(PORT, "0.0.0.0", () => {
  console.log("Listening on Port : " + PORT);
});
