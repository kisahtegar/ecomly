const { User } = require("../models/user");
const { Product } = require("../models/product");
const { default: mongoose } = require("mongoose");

/**
 * Get User Wishlist
 *
 * Retrieves the wishlist of a specific user. For each product in the wishlist,
 * it checks whether the product still exists and whether it is in stock.
 *
 * @param {Object} req - Express request object, expects `id` in params as user ID.
 * @param {Object} res - Express response object, returns wishlist details.
 *
 * @returns {JSON} Various status codes (200 on success, 404 if user not found, 500 on error)
 */
exports.getUserWishlist = async function (req, res) {
  try {
    const user = await User.findById(req.params.id);
    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }

    const wishlist = [];
    for (const wishProduct of user.wishlist) {
      const product = await Product.findById(wishProduct.productId);
      if (!product) {
        wishlist.push({
          ...wishProduct,
          productExists: false,
          productOutOfStock: false,
        });
      } else if (product.countInStock < 1) {
        wishlist.push({
          ...wishProduct,
          productExists: true,
          productOutOfStock: true,
        });
      } else {
        wishlist.push({
          productId: product._id,
          productImage: product.image,
          productPrice: product.price,
          productName: product.name,
          productExists: true,
          productOutOfStock: false,
        });
      }
    }
    return res.json(wishlist);
  } catch (error) {
    console.error(error);
    return res.status(500).json({ type: error.name, message: error.message });
  }
};

/**
 * Add to Wishlist
 *
 * Adds a product to a user's wishlist if it exists and is not already added.
 *
 * @param {Object} req - Express request object, expects `id` in params as user ID and `productId` in body.
 * @param {Object} res - Express response object, returns status or error response.
 *
 * @returns {JSON} Various status codes (200 on success, 404 if user/product not found, 409 if already exists, 500 on error)
 */
exports.addToWishlist = async function (req, res) {
  try {
    const user = await User.findById(req.params.id);
    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }

    const product = await Product.findById(req.body.productId);
    if (!product) {
      return res
        .status(404)
        .json({ message: "Could not add product. Product not found." });
    }

    const productAlreadyExists = user.wishlist.find((item) =>
      item.productId.equals(
        new mongoose.Types.ObjectId(`${req.body.productId}`)
      )
    );
    if (productAlreadyExists) {
      return res
        .status(409)
        .json({ message: "Product already exists in wishlist" });
    }

    user.wishlist.push({
      productId: req.body.productId,
      productImage: product.image,
      productPrice: product.price,
      productName: product.name,
    });

    await user.save();
    return res.status(200).end();
  } catch (error) {
    console.error(error);
    return res.status(500).json({ type: error.name, message: error.message });
  }
};

/**
 * Remove from Wishlist
 *
 * Removes a product from a user's wishlist if it exists.
 *
 * @param {Object} req - Express request object, expects `id` (user ID) and `productId` in params.
 * @param {Object} res - Express response object, returns status or error response.
 *
 * @returns {JSON} Various status codes (204 on success, 404 if user/product not found, 500 on error)
 */
exports.removeFromWishlist = async function (req, res) {
  try {
    const userId = req.params.id;
    const productId = req.params.productId;

    const user = await User.findById(userId);
    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }

    const index = user.wishlist.findIndex((item) =>
      item.productId.equals(new mongoose.Types.ObjectId(`${productId}`))
    );

    if (index === -1) {
      return res.status(404).json({ message: "Product not found in wishlist" });
    }
    user.wishlist.splice(index, 1);

    await user.save();
    return res.status(204).end();
  } catch (error) {
    console.error(error);
    return res.status(500).json({ type: error.name, message: error.message });
  }
};
