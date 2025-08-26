const { Category } = require("../models/category");

/**
 * Get All Categories
 *
 * Fetches all categories from the database.
 *
 * @param {Object} _ - Unused Express request object.
 * @param {Object} res - Express response object, returns list of categories or error response.
 *
 * @returns {JSON} Various status codes (200 on success, 404 if not found, 500 on server error)
 */
exports.getCategories = async function (_, res) {
  try {
    const categories = await Category.find();
    if (!categories) {
      return res.status(404).json({ message: "Categories not found" });
    }
    return res.json(categories);
  } catch (error) {
    console.error(error);
    return res.status(500).json({ type: error.name, message: error.message });
  }
};

/**
 * Get Category by ID
 *
 * Retrieves a category by its ID.
 *
 * @param {Object} req - Express request object, expects `id` in params.
 * @param {Object} res - Express response object, returns category data or error response.
 *
 * @returns {JSON} Various status codes (200 on success, 404 if not found, 500 on server error)
 */
exports.getCategoryById = async function (req, res) {
  try {
    const category = await Category.findById(req.params.id);
    if (!category) {
      return res.status(404).json({ message: "Category not found" });
    }
    return res.json(category);
  } catch (error) {
    console.error(error);
    return res.status(500).json({ type: error.name, message: error.message });
  }
};
