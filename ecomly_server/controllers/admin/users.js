const { User } = require("../../models/user");
const { Order } = require("../../models/order");
const { OrderItem } = require("../../models/order_item");
const { CartProduct } = require("../../models/cart_product");
const { Token } = require("../../models/token");

/**
 * Get User Count
 *
 * Retrieves the total number of users in the system.
 *
 * @param {Object} _ - Unused parameter (placeholder for request object)
 * @param {Object} res - Express response object, returns the user count or error.
 *
 * @returns {JSON} Various status codes (200 on success, 500 on error)
 */
exports.getUserCount = async function (_, res) {
  try {
    const userCount = await User.countDocuments();
    if (!userCount) {
      return res.status(500).json({ message: "Could not count users." });
    }
    return res.json({ userCount });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ type: error.name, message: error.message });
  }
};

/**
 * Delete User
 *
 * Deletes a user and all associated data including orders, order items, cart products, and tokens.
 *
 * @param {Object} req - Express request object, expects `id` in params.
 * @param {Object} res - Express response object, returns success or error response.
 *
 * @returns {JSON} Various status codes (204 on success, 404 if user not found, 500 on error)
 */
exports.deleteUser = async function (req, res) {
  try {
    const userId = req.params.id;

    const user = await User.findById(userId);
    if (!user) return res.status(404).json({ message: "User not found!" });

    // Delete all orders and their associated order items
    const orders = await Order.find({ user: userId });
    const orderItemIds = orders.flatMap((order) => order.orderItems);
    await Order.deleteMany({ user: userId });
    await OrderItem.deleteMany({ _id: { $in: orderItemIds } });

    // Delete user's cart products
    await CartProduct.deleteMany({ _id: { $in: user.cart } });

    // Remove cart references from the user document
    await User.findByIdAndUpdate(userId, {
      $pull: { cart: { $exists: true } },
    });

    // Delete the user's authentication token
    await Token.deleteOne({ userId: userId });

    // Finally, delete the user
    await User.deleteOne({ _id: userId });

    return res.status(204).end();
  } catch (error) {
    console.error(error);
    return res.status(500).json({ type: error.name, message: error.message });
  }
};
