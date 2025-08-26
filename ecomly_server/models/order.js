const { Schema, model } = require("mongoose");

/**
 * Order Schema
 *
 * Represents a customer's order, containing references to ordered items,
 * shipping details, payment info, and status tracking.
 */
const orderSchema = Schema(
  {
    /**
     * List of items in the order.
     * Each is a reference to an OrderItem document, which holds a product snapshot.
     */
    orderItems: [
      { type: Schema.Types.ObjectId, ref: "OrderItem", required: true },
    ],

    /** Shipping information */
    shippingAddress: { type: String, required: true },
    city: { type: String, required: true },
    postalCode: { type: String },
    country: { type: String, required: true },
    phone: { type: String, required: true },

    /** Payment reference ID from provider (e.g., Stripe, PayPal) */
    paymentId: { type: String },

    /** Current status of the order */
    status: {
      type: String,
      required: true,
      default: "pending",
      enum: [
        "pending",
        "processed",
        "shipped",
        "out-for-delivery",
        "delivered",
        "cancelled",
        "on-hold",
        "expired",
      ],
    },

    /**
     * History of statuses over time.
     * Used for order tracking and auditing.
     */
    statusHistory: {
      type: [String],
      enum: [
        "pending",
        "processed",
        "shipped",
        "out-for-delivery",
        "delivered",
        "cancelled",
        "on-hold",
        "expired",
      ],
      required: true,
      default: ["pending"],
    },

    /** Final calculated price of the entire order */
    totalPrice: { type: Number, required: true },

    /** The user who placed the order */
    user: { type: Schema.Types.ObjectId, ref: "User", required: true },

    /** Order creation date (default = now) */
    dateOrdered: { type: Date, default: Date.now },
  },
  { timestamps: true }
);

// Enable virtuals in JSON and object outputs
orderSchema.set("toObject", { virtuals: true });
orderSchema.set("toJSON", { virtuals: true });

exports.Order = model("Order", orderSchema);
