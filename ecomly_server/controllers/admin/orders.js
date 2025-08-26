const { Order } = require("../../models/order");
const { OrderItem } = require("../../models/order_item");

/**
 * Get Orders
 *
 * Retrieves all orders with populated user information and order items,
 * including product name and category name. Excludes the `statusHistory` field.
 *
 * @param {Object} _ - Express request object (unused).
 * @param {Object} res - Express response object, returns JSON array of orders or error.
 *
 * @returns {JSON} Status codes 200 on success, 404 if no orders, 500 on error
 */
exports.getOrders = async function (_, res) {
  try {
    const orders = await Order.find()
      .select("-statusHistory")
      .populate("user", "name email")
      .sort({ dateOrdered: -1 })
      .populate({
        path: "orderItems",
        populate: {
          path: "product",
          select: "name",
          populate: { path: "category", select: "name" },
        },
      });
    if (!orders) {
      return res.status(404).json({ message: "Orders not found" });
    }

    return res.json(orders);
  } catch (error) {
    console.error(error);
    return res.status(500).json({ type: error.name, message: error.message });
  }
};

/**
 * Get Orders Count
 *
 * Returns the total number of orders in the database.
 *
 * @param {Object} _ - Express request object (unused).
 * @param {Object} res - Express response object, returns JSON with orders count or error.
 *
 * @returns {JSON} Status codes 200 on success, 500 on error
 */
exports.getOrdersCount = async function (_, res) {
  try {
    const count = await Order.countDocuments();
    if (!count) {
      return res.status(500).json({ message: "Could not count orders!" });
    }
    return res.json({ count });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ type: error.name, message: error.message });
  }
};

/**
 * Change Order Status
 *
 * Updates the status of a specific order and appends previous status
 * to the `statusHistory` array if not already present.
 *
 * @param {Object} req - Express request object, expects order `id` in params and `status` in body.
 * @param {Object} res - Express response object, returns updated order or error.
 *
 * @returns {JSON} Status codes 200 on success, 400 if order not found, 500 on error
 */
exports.changeOrderStatus = async function (req, res) {
  try {
    const orderId = req.params.id;
    const newStatus = req.body.status;

    let order = await Order.findById(orderId);
    if (!order) {
      return res.status(400).json({ message: "Order not found" });
    }

    if (!order.statusHistory.includes(order.status)) {
      order.statusHistory.push(order.status);
    }
    order.status = newStatus;
    order = await order.save();
    return res.json(order);
  } catch (error) {
    console.error(error);
    return res.status(500).json({ type: error.name, message: error.message });
  }
};

/**
 * Delete Order
 *
 * Deletes an order and all associated order items from the database.
 *
 * @param {Object} req - Express request object, expects order `id` in params.
 * @param {Object} res - Express response object, returns 204 on success, 404 if order not found, 500 on error.
 *
 * @returns {JSON} Status codes 204 on success, 404/500 on error
 */
exports.deleteOrder = async function (req, res) {
  try {
    const order = await Order.findByIdAndDelete(req.params.id);
    if (!order) {
      return res.status(404).json({ message: "Order not found" });
    }
    for (const orderItemId of order.orderItems) {
      await OrderItem.findByIdAndDelete(orderItemId);
    }
    return res.status(204).end();
  } catch (error) {
    console.error(error);
    return res.status(500).json({ type: error.name, message: error.message });
  }
};
