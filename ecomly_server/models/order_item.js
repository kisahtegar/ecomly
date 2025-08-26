const { Schema, model } = require("mongoose");

/**
 * OrderItem Schema
 *
 * Represents a single product entry inside an Order. Stores a snapshot of
 * product details (name, image, price) at the time of purchase to ensure
 * historical accuracy, even if the product later changes in the catalog.
 */
const orderItemSchema = Schema(
  {
    /**
     * Reference to the Product document.
     * Used mainly for relational lookups, while snapshot fields store fixed values.
     */
    product: { type: Schema.Types.ObjectId, ref: "Product", required: true },

    /** Snapshot of product name at purchase time. */
    productName: { type: String, required: true },

    /** Snapshot of product image (URL). */
    productImage: { type: String, required: true },

    /** Snapshot of product price (frozen at purchase time). */
    productPrice: { type: Number, required: true },

    /** Quantity of the product in this order (must be at least 1). */
    quantity: { type: Number, min: 1, default: 1 },

    /** Selected size option, if applicable. */
    selectedSize: String,

    /** Selected colour option, if applicable. */
    selectedColour: String,
  },
  { timestamps: true }
);

// Enable virtuals in JSON and object outputs
orderItemSchema.set("toObject", { virtuals: true });
orderItemSchema.set("toJSON", { virtuals: true });

exports.OrderItem = model("OrderItem", orderItemSchema);
