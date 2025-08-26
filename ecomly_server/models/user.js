const { Schema, model } = require("mongoose");

/**
 * User Schema
 *
 * Represents an application user. Stores personal details, authentication info,
 * shopping cart items, wishlist, and account settings. Supports both normal users
 * and administrators via the `isAdmin` flag.
 */
const userSchema = Schema(
  {
    /** Full name of the user. */
    name: { type: String, required: true, trim: true },

    /** Unique email address (used for login & communication). */
    email: { type: String, required: true, trim: true },

    /** Hashed password (never store plain text passwords). */
    passwordHash: { type: String, required: true },

    /**
     * Reference to external payment provider's customer ID (e.g., Stripe).
     * Allows storing billing/payment profiles.
     */
    paymentCustomerId: String,

    /** Street address (optional). */
    street: String,

    /** Apartment/suite/unit number (optional). */
    apartment: String,

    /** City of residence. */
    city: String,

    /** Postal or ZIP code. */
    postalCode: String,

    /** Country of residence. */
    country: String,

    /** Phone number for contact and order confirmation. */
    phone: { type: String, required: true, trim: true },

    /** Flag to indicate whether the user has admin privileges. */
    isAdmin: { type: Boolean, default: false },

    /** One-time password (OTP) for password reset. */
    resetPasswordOtp: Number,

    /** Expiration date/time for the password reset OTP. */
    resetPasswordOtpExpires: Date,

    /** Shopping cart items belonging to this user. */
    cart: [{ type: Schema.Types.ObjectId, ref: "CartProduct" }],

    /**
     * Stores snapshots of products user is interested in. ach item
     * captures product reference and fixed details at the time.
     */
    wishlist: [
      {
        /** Reference to the Product document. */
        productId: {
          type: Schema.Types.ObjectId,
          ref: "Product",
          required: true,
        },

        /** Snapshot of product name at the time it was added. */
        productName: { type: String, required: true },

        /** Snapshot of product image (URL). */
        productImage: { type: String, required: true },

        /** Snapshot of product price when added to wishlist. */
        productPrice: { type: Number, required: true },
      },
    ],
  },
  { timestamps: true }
);

// Ensure email is unique for each user
userSchema.index({ email: 1 }, { unique: true });

// Enable virtuals in JSON and object outputs
userSchema.set("toObject", { virtuals: true });
userSchema.set("toJSON", { virtuals: true });

exports.User = model("User", userSchema);
