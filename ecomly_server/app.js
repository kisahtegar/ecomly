const bodyParser = require("body-parser");
const cors = require("cors");
require("dotenv/config");
const express = require("express");
const morgan = require("morgan");
const mongoose = require("mongoose");

const authJwt = require("./middlewares/jwt");
const errorHandler = require("./middlewares/error_handler");
const authorizePostRequests = require("./middlewares/authorization");

const app = express();
const env = process.env;

const API = env.API_URL;
const hostname = env.HOST;
const port = env.PORT;

/**
 * Middleware: Body parser for JSON requests.
 * Special handling for Stripe webhook which requires raw body.
 */
app.use(
  bodyParser.json({
    verify(req, _, buf, __) {
      if (req.path.includes("checkout/webhook")) {
        // Keep raw body for Stripe validation
        req.rawBody = buf.toString();
      }
    },
  })
);

// Logging middleware for HTTP requests
app.use(morgan("tiny"));

// Enable CORS for cross-origin requests
app.use(cors());

// JWT authentication middleware
app.use(authJwt());

// Custom middleware to authorize specific POST requests
app.use(authorizePostRequests);

// Centralized error handler middleware
app.use(errorHandler);

const authRouter = require("./routes/auth");
const usersRouter = require("./routes/users");
const adminRouter = require("./routes/admin");
const categoriesRouter = require("./routes/categories");
const productsRouter = require("./routes/products");
const checkoutRouter = require("./routes/checkout");
const ordersRouter = require("./routes/orders");

app.use(`${API}/`, authRouter);
app.use(`${API}/users`, usersRouter);
app.use(`${API}/admin`, adminRouter);
app.use(`${API}/categories`, categoriesRouter);
app.use(`${API}/products`, productsRouter);
app.use(`${API}/checkout`, checkoutRouter);
app.use(`${API}/orders`, ordersRouter);

// Static file serving for public assets
app.use("/public", express.static(__dirname + "/public"));

// Database Connection Using Mongoose to connect with MongoDB
mongoose
  .connect(env.MONGODB_CONNECTION_STRING)
  .then(() => {
    console.log("✅ Connected to Database");
  })
  .catch((error) => {
    console.error("❌ Database connection error:", error);
  });

// Start the Express server
app.listen(port, hostname, () => {
  console.log(`🚀 Server running at http://${hostname}:${port}`);
});
