const { Schema, model } = require("mongoose");

/**
 * CartProduct Schema
 *
 * Represents a product item inside a user's cart. Stores a snapshot of product
 * data at the time it was added, while also linking to the actual Product
 * collection for reference.
 */
const cartProductSchema = Schema(
  {
    /**
     * Reference to the Product document.
     * Still keeps productName, productImage, productPrice as snapshot fields
     * to ensure cart remains consistent if product data later changes.
     */
    product: { type: Schema.Types.ObjectId, ref: "Product", required: true },

    /** Quantity of the product in the cart (min: 1). */
    quantity: { type: Number, min: 1, default: 1 },

    /** Selected size option. */
    selectedSize: String,

    /** Selected colour option. */
    selectedColour: String,

    /** Snapshot of product details at the time of adding to cart. */
    productName: { type: String, required: true },
    productImage: { type: String, required: true },
    productPrice: { type: Number, required: true },

    /** Used to hold time (default: 30 mins). */
    reservationExpiry: {
      type: Date,
      default: () => new Date(Date.now() + 30 * 60 * 1000),
    },

    /** flag indicating whether stock is currently reserved. */
    reserved: { type: Boolean, default: true },
  },
  { timestamps: true }
);

// Enable virtuals in JSON and object outputs
cartProductSchema.set("toObject", { virtuals: true });
cartProductSchema.set("toJSON", { virtuals: true });

exports.CartProduct = model("CartProduct", cartProductSchema);
