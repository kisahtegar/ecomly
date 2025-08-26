const { Schema, model } = require("mongoose");

/**
 * Category Schema
 *
 * Represents a product category used for grouping and filtering products.
 * Each category has a display name, associated colour, and image icon/banner.
 */
const categorySchema = Schema(
  {
    /** Display name of the category (e.g., "Shoes", "Electronics"). */
    name: { type: String, required: true },

    /** Colour code for styling UI elements related to this category. */
    colour: { type: String, default: "#000000" },

    /** Category image or icon (URL to asset). */
    image: { type: String, required: true },

    /** Soft delete flag. If true, category is hidden from users but preserved in the database. */
    markedForDeletion: { type: Boolean, default: false },
  },
  { timestamps: true }
);

// Enable virtuals in JSON and object outputs
categorySchema.set("toObject", { virtuals: true });
categorySchema.set("toJSON", { virtuals: true });

exports.Category = model("Category", categorySchema);
