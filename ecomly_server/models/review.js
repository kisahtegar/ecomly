const { Schema, model } = require("mongoose");

/**
 * Review Schema
 *
 * Represents a product review submitted by a user. Each review stores the
 * rating, optional comment, and user details at the time of submission.
 * Reviews are linked to products and used to calculate average product ratings.
 */
const reviewSchema = Schema({
  /**
   * Reference to the User who created the review.
   * Helps identify ownership of the review.
   */
  user: { type: Schema.Types.ObjectId, ref: "User", required: true },

  /** Snapshot of the user's name at the time of review submission. */
  userName: { type: String, required: true },

  /** Optional written feedback about the product. */
  comment: { type: String, trim: true },

  /** Numeric rating value (commonly 1–5). */
  rating: { type: Number, required: true },

  /** Timestamp when the review was created. Defaults to current date/time. */
  date: { type: Date, default: Date.now },
});

// Enable virtuals in JSON and object outputs
reviewSchema.set("toJSON", { virtuals: true });
reviewSchema.set("toObject", { virtuals: true });

exports.Review = model("Review", reviewSchema);
