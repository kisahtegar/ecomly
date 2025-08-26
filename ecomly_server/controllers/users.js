const { User } = require("../models/user");
const stripe = require("stripe")(process.env.STRIPE_KEY);

/**
 * Get All Users
 *
 * Fetches a list of all users from the database with selected fields.
 *
 * @param {Object} _ - Unused Express request object.
 * @param {Object} res - Express response object, returns user list or error response.
 *
 * @returns {JSON} Various status codes (200 on success, 404 if not found, 500 on server error)
 */
exports.getUsers = async (_, res) => {
  try {
    const users = await User.find().select("name email id isAdmin");
    if (!users) {
      return res.status(404).json({ message: "Users not found" });
    }
    return res.json(users);
  } catch (error) {
    console.error(error);
    return res.status(500).json({ type: error.name, message: error.message });
  }
};

/**
 * Get User by ID
 *
 * Retrieves a single user by ID, excluding sensitive fields.
 *
 * @param {Object} req - Express request object, expects `id` in params.
 * @param {Object} res - Express response object, returns user data or error response.
 *
 * @returns {JSON} Various status codes (200 on success, 404 if not found, 500 on server error)
 */
exports.getUserById = async (req, res) => {
  try {
    const user = await User.findById(req.params.id).select(
      "-passwordHash -resetPasswordOtp -resetPasswordOtpExpires -cart"
    );
    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }
    return res.json(user);
  } catch (error) {
    console.error(error);
    return res.status(500).json({ type: error.name, message: error.message });
  }
};

/**
 * Update User
 *
 * Updates a user's basic information (name, email, phone).
 *
 * @param {Object} req - Express request object, expects `id` in params and `name`, `email`, `phone` in body.
 * @param {Object} res - Express response object, returns updated user or error response.
 *
 * @returns {JSON} Various status codes (200 on success, 404 if not found, 500 on server error)
 */
exports.updateUser = async (req, res) => {
  try {
    const { name, email, phone } = req.body;
    const user = await User.findByIdAndUpdate(
      req.params.id,
      { name, email, phone },
      { new: true }
    );
    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }
    user.passwordHash = undefined;
    user.cart = undefined;
    return res.json(user);
  } catch (error) {
    console.error(error);
    return res.status(500).json({ type: error.name, message: error.message });
  }
};

/**
 * Get Payment Profile
 *
 * Retrieves Stripe billing portal session link for a user with a payment profile.
 *
 * @param {Object} req - Express request object, expects `id` in params.
 * @param {Object} res - Express response object, returns billing portal URL or error response.
 *
 * @returns {JSON} Various status codes (200 on success, 404 if not found, 500 on server error)
 */
exports.getPaymentProfile = async (req, res) => {
  try {
    const user = await User.findById(req.params.id);
    if (!user) {
      return res.status(404).json({ message: "User not found" });
    } else if (!user.paymentCustomerId) {
      return res.status(404).json({
        message:
          "You do not have a payment profile yet. Complete an order to see your payment profile.",
      });
    }
    const session = await stripe.billingPortal.sessions.create({
      customer: user.paymentCustomerId,
      return_url: "https://dbestech.biz/ecomly",
    });

    return res.json({ url: session.url });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ type: error.name, message: error.message });
  }
};
