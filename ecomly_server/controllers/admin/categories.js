const util = require("util");
const media_helper = require("../../helpers/media_helper");
const { Category } = require("../../models/category");

/**
 * Add Category
 *
 * Handles creation of a new category, including uploading a category image.
 *
 * @param {Object} req - Express request object, expects category data in body and an image file.
 * @param {Object} res - Express response object, returns the created category or error response.
 *
 * @returns {JSON} Various status codes (201 on success, 404 if no file found, 500 on error)
 */
exports.addCategory = async function (req, res) {
  try {
    const uploadImage = util.promisify(
      media_helper.upload.fields([{ name: "image", maxCount: 1 }])
    );
    try {
      await uploadImage(req, res);
    } catch (error) {
      console.error(error);
      return res.status(500).json({
        type: error.code,
        message: `${error.message}{${err.field}}`,
        storageErrors: error.storageErrors,
      });
    }
    const image = req.files["image"][0];
    if (!image) return res.status(404).json({ message: "No file found!" });

    req.body["image"] = `${req.protocol}://${req.get("host")}/${image.path}`;
    let category = new Category(req.body);

    category = category.save();
    if (!category) {
      return res
        .status(500)
        .json({ message: "The category could not be created" });
    }
    return res.status(201).json(category);
  } catch (error) {
    console.error(error);
    return res.status(500).json({ type: error.name, message: error.message });
  }
};

/**
 * Edit Category
 *
 * Updates an existing category's name, icon, or colour.
 *
 * @param {Object} req - Express request object, expects `id` in params and updated category data in body.
 * @param {Object} res - Express response object, returns updated category or error response.
 *
 * @returns {JSON} Various status codes (200 on success, 404 if category not found, 500 on error)
 */
exports.editCategory = async function (req, res) {
  try {
    const { name, icon, colour } = req.body;
    const category = await Category.findByIdAndUpdate(
      req.params.id,
      { name, icon, colour },
      { new: true }
    );
    if (!category) {
      return res.status(404).json({ message: "Category not found!" });
    }
    return res.json(category);
  } catch (error) {
    console.error(error);
    return res.status(500).json({ type: error.name, message: error.message });
  }
};

/**
 * Delete Category
 *
 * Marks a category for deletion instead of permanently removing it.
 *
 * @param {Object} req - Express request object, expects `id` in params.
 * @param {Object} res - Express response object, returns success or error response.
 *
 * @returns {JSON} Various status codes (204 on success, 404 if category not found, 500 on error)
 */
exports.deleteCategory = async function (req, res) {
  try {
    const category = await Category.findById(req.params.id);
    if (!category) {
      return res.status(404).json({ message: "Category not found!" });
    }
    category.markedForDeletion = true;
    await category.save();
    return res.status(204).end();
  } catch (error) {
    console.error(error);
    return res.status(500).json({ type: error.name, message: error.message });
  }
};
