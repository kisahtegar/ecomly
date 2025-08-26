const { Schema, model } = require("mongoose");

/**
 * Product Schema
 *
 * Represents an item available for sale in the store, including details,
 * variants, reviews, and inventory tracking.
 */
const productSchema = Schema(
  {
    /** Basic details */
    name: { type: String, required: true, trim: true },
    description: { type: String, required: true },
    price: { type: Number, required: true, min: 0 },

    /** Rating & reviews */
    rating: { type: Number, default: 0.0 },
    reviews: [{ type: Schema.Types.ObjectId, ref: "Review" }],
    numberOfReviews: { type: Number, default: 0 },

    /** Variants */
    colours: [{ type: String }],
    sizes: [{ type: String }],

    /** Images (primary + gallery) */
    image: { type: String, required: true },
    images: [{ type: String }],

    /** Category linkage */
    category: { type: Schema.Types.ObjectId, ref: "Category", required: true },

    /** Gender/Age filter */
    genderAgeCategory: {
      type: String,
      enum: ["men", "women", "unisex", "kids"],
    },

    /** Stock management */
    countInStock: { type: Number, required: true, min: 0, max: 255 },

    /** Metadata */
    dateAdded: { type: Date, default: Date.now },
  },
  { timestamps: true }
);

// Pre-save hook: auto calculate rating & review count
productSchema.pre("save", async function (next) {
  if (this.reviews.length > 0) {
    await this.populate("reviews");
    const totalRating = this.reviews.reduce(
      (acc, review) => acc + review.rating,
      0
    );
    this.rating = parseFloat((totalRating / this.reviews.length).toFixed(1));
    this.numberOfReviews = this.reviews.length;
  }
  next();
});

// Text index for search functionality
productSchema.index({ name: "text", description: "text" });

// Include virtuals in JSON and object outputs
productSchema.set("toObject", { virtuals: true });
productSchema.set("toJSON", { virtuals: true });

exports.Product = model("Product", productSchema);
