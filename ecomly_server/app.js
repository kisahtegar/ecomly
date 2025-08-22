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

app.use(
  bodyParser.json({
    verify(req, _, buf, __) {
      if (req.path.includes("checkout/webhook")) {
        req.rawBody = buf.toString();
      }
    },
  })
);
app.use(morgan("tiny"));
app.use(cors());
app.use(authJwt());
app.use(authorizePostRequests);
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
app.use("/public", express.static(__dirname + "/public"));

// Start the server
mongoose
  .connect(env.MONGODB_CONNECTION_STRING)
  .then(() => {
    console.log("Connected to Database");
  })
  .catch((error) => {
    console.error(error);
  });

app.listen(port, hostname, () => {
  console.log(`Server running at http://${hostname}:${port}`);
});
