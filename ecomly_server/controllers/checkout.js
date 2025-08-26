const jwt = require("jsonwebtoken");
const stripe = require("stripe")(process.env.STRIPE_KEY);

const { User } = require("../models/user");
const { Product } = require("../models/product");
const orderController = require("./orders");
const emailSender = require("../helpers/email_sender");
const mailBuilder = require("../helpers/order_complete_email_builder");

/**
 * Checkout
 *
 * Handles Stripe checkout creation for a user. Validates product stock, replaces
 * placeholder images, manages Stripe customer creation, and creates a Stripe
 * checkout session with payment and shipping options.
 *
 * @param {Object} req - Express request object, expects `cartItems` array in body.
 * @param {Object} res - Express response object, returns checkout session URL.
 *
 * @returns {JSON} 201 - Stripe checkout session URL for frontend redirection
 */
exports.checkout = async function (req, res) {
  // Extract user ID from JWT token
  const accessToken = req.header("Authorization").replace("Bearer", "").trim();
  const tokenData = jwt.decode(accessToken);

  const user = await User.findById(tokenData.id);
  if (!user) {
    return res.status(404).json({ message: "User not found" });
  }

  // Validate product availability and replace placeholder images if needed
  for (const cartItem of req.body.cartItems) {
    const newImages = [];
    for (const image of cartItem.images) {
      if (image.includes("http:")) {
        // Replace HTTP images with a generic placeholder
        newImages.push(
          "https://img.freepik.com/free-psd/isolated-cardboard-box_125540-1169.jpg?w=1060&t=st=1705342136~exp=1705342736~hmac=3b4449a587dd227ed0f2d66f0c0eca550f75a79dc0b19284d8624b4a91f66f6a"
        );
      } else {
        newImages.push(image);
      }
    }

    cartItem.images = newImages;
    const product = await Product.findById(cartItem.productId);
    if (!product) {
      return res.status(404).json({ message: `${cartItem.name} not found` });
    } else if (!cartItem.reserved && product.countInStock < cartItem.quantity) {
      const message = `${product.name}\nOrder for ${cartItem.quantity}, but only ${product.countInStock} left in stock.`;
      return res.status(400).json({ message });
    }
  }

  // Determine Stripe customer ID or create new customer
  let customerId;
  if (user.paymentCustomerId) {
    customerId = user.paymentCustomerId;
  } else {
    const customer = await stripe.customers.create({
      metadata: { userId: tokenData.id },
    });
    customerId = customer.id;
  }

  // Create Stripe checkout session
  const session = await stripe.checkout.sessions.create({
    line_items: req.body.cartItems.map((item) => {
      return {
        price_data: {
          currency: "usd",
          product_data: {
            name: item.name,
            images: item.images,
            metadata: {
              productId: item.productId,
              cartProductId: item.cartProductId,
              selectedSize: item.selectedSize ?? undefined,
              selectedColour: item.selectedColour ?? undefined,
            },
          },
          unit_amount: (item.price * 100).toFixed(0),
        },
        quantity: item.quantity,
      };
    }),
    payment_method_options: {
      card: { setup_future_usage: "on_session" },
    },
    billing_address_collection: "auto",
    shipping_address_collection: {
      allowed_countries: [
        "AC",
        "AD",
        "AE",
        "AF",
        "AG",
        "AI",
        "AL",
        "AM",
        "AO",
        "AQ",
        "AR",
        "AT",
        "AU",
        "AW",
        "AX",
        "AZ",
        "BA",
        "BB",
        "BD",
        "BE",
        "BF",
        "BG",
        "BH",
        "BI",
        "BJ",
        "BL",
        "BM",
        "BN",
        "BO",
        "BQ",
        "BR",
        "BS",
        "BT",
        "BV",
        "BW",
        "BY",
        "BZ",
        "CA",
        "CD",
        "CF",
        "CG",
        "CH",
        "CI",
        "CK",
        "CL",
        "CM",
        "CN",
        "CO",
        "CR",
        "CV",
        "CW",
        "CY",
        "CZ",
        "DE",
        "DJ",
        "DK",
        "DM",
        "DO",
        "DZ",
        "EC",
        "EE",
        "EG",
        "EH",
        "ER",
        "ES",
        "ET",
        "FI",
        "FJ",
        "FK",
        "FO",
        "FR",
        "GA",
        "GB",
        "GD",
        "GE",
        "GF",
        "GG",
        "GH",
        "GI",
        "GL",
        "GM",
        "GN",
        "GP",
        "GQ",
        "GR",
        "GS",
        "GT",
        "GU",
        "GW",
        "GY",
        "HK",
        "HN",
        "HR",
        "HT",
        "HU",
        "ID",
        "IE",
        "IL",
        "IM",
        "IN",
        "IO",
        "IQ",
        "IS",
        "IT",
        "JE",
        "JM",
        "JO",
        "JP",
        "KE",
        "KG",
        "KH",
        "KI",
        "KM",
        "KN",
        "KR",
        "KW",
        "KY",
        "KZ",
        "LA",
        "LB",
        "LC",
        "LI",
        "LK",
        "LR",
        "LS",
        "LT",
        "LU",
        "LV",
        "LY",
        "MA",
        "MC",
        "MD",
        "ME",
        "MF",
        "MG",
        "MK",
        "ML",
        "MM",
        "MN",
        "MO",
        "MQ",
        "MR",
        "MS",
        "MT",
        "MU",
        "MV",
        "MW",
        "MX",
        "MY",
        "MZ",
        "NA",
        "NC",
        "NE",
        "NG",
        "NI",
        "NL",
        "NO",
        "NP",
        "NR",
        "NU",
        "NZ",
        "OM",
        "PA",
        "PE",
        "PF",
        "PG",
        "PH",
        "PK",
        "PL",
        "PM",
        "PN",
        "PR",
        "PS",
        "PT",
        "PY",
        "QA",
        "RE",
        "RO",
        "RS",
        "RU",
        "RW",
        "SA",
        "SB",
        "SC",
        "SE",
        "SG",
        "SH",
        "SI",
        "SJ",
        "SK",
        "SL",
        "SM",
        "SN",
        "SO",
        "SR",
        "SS",
        "ST",
        "SV",
        "SX",
        "SZ",
        "TA",
        "TC",
        "TD",
        "TF",
        "TG",
        "TH",
        "TJ",
        "TK",
        "TL",
        "TM",
        "TN",
        "TO",
        "TR",
        "TT",
        "TV",
        "TW",
        "TZ",
        "UA",
        "UG",
        "US",
        "UY",
        "UZ",
        "VA",
        "VC",
        "VE",
        "VG",
        "VN",
        "VU",
        "WF",
        "WS",
        "XK",
        "YE",
        "YT",
        "ZA",
        "ZM",
        "ZW",
        "ZZ",
      ],
    },
    phone_number_collection: { enabled: true },
    customer: customerId,
    mode: "payment",
    success_url: "https://dbestech.biz/payment-success",
    cancel_url: "https://dbestech.biz/cart",
  });

  res.status(201).json({ url: session.url });
};

/**
 * Stripe Webhook
 *
 * Handles Stripe webhook events, specifically `checkout.session.completed`. Retrieves
 * the customer, extracts purchased items, creates orders in the database, updates user
 * Stripe customer ID if necessary, and sends order confirmation emails.
 *
 * @param {Object} request - Express request object, expects raw body and Stripe signature header.
 * @param {Object} res - Express response object, returns 200/400 depending on webhook processing.
 *
 * @returns {JSON} 200 - Successfully processed webhook
 * @returns {JSON} 400 - Webhook signature validation failed or unhandled event type
 */
exports.webhook = function (request, res) {
  const sig = request.headers["stripe-signature"];
  const endpointSecret = process.env.STRIPE_WEBHOOK_SECRET;

  let event;

  try {
    // Verify the Stripe webhook signature
    event = stripe.webhooks.constructEvent(
      request.rawBody,
      sig,
      endpointSecret
    );
  } catch (err) {
    console.error("Webhook Error:", err.message);
    res.status(400).send(`Webhook Error: ${err.message}`);
    return;
  }

  if (event.type === "checkout.session.completed") {
    const session = event.data.object;

    // Retrieve Stripe customer to get metadata
    stripe.customers
      .retrieve(session.customer)
      .then(async (customer) => {
        // Get purchased items from the checkout session
        const lineItems = await stripe.checkout.sessions.listLineItems(
          session.id,
          { expand: ["data.price.product"] }
        );

        // Map line items to order items for database
        const orderItems = lineItems.data.map((item) => ({
          quantity: item.quantity,
          product: item.price.product.metadata.productId,
          cartProductId: item.price.product.metadata.cartProductId,
          productPrice: item.price.unit_amount / 100,
          productName: item.price.product.name,
          productImage: item.price.product.images[0],
          selectedSize: item.price.product.metadata.selectedSize ?? undefined,
          selectedColour:
            item.price.product.metadata.selectedColour ?? undefined,
        }));

        // Determine shipping address
        const address =
          session.shipping_details?.address ?? session.customer_details.address;

        // Create order in database
        const order = await orderController.addOrder({
          orderItems: orderItems,
          shippingAddress:
            address.line1 === "N/A" ? address.line2 : address.line1,
          city: address.city,
          postalCode: address.postal_code,
          country: address.country,
          phone: session.customer_details.phone,
          totalPrice: session.amount_total / 100,
          user: customer.metadata.userId,
          paymentId: session.payment_intent,
        });

        // Update user's Stripe customer ID if missing
        let user = await User.findById(customer.metadata.userId);
        if (user && !user.paymentCustomerId) {
          user = await User.findByIdAndUpdate(
            customer.metadata.userId,
            { paymentCustomerId: session.customer },
            { new: true }
          );
        }

        // Send order confirmation email
        const leanOrder = order.toObject();
        leanOrder["orderItems"] = orderItems;
        await emailSender.sendMail(
          session.customer_details.email ?? user.email,
          "Your Ecomly Order",
          mailBuilder.buildEmail(
            user.name,
            leanOrder,
            session.customer_details.name
          )
        );
      })
      .catch((error) => console.error("WEBHOOK ERROR CATCHER:", error.message));
  } else {
    console.log(`Unhandled event type ${event.type}`);
  }

  res.send().end();
};
