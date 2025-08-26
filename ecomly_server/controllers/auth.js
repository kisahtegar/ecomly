const { validationResult } = require("express-validator");
const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");
const { User } = require("../models/user");
const { Token } = require("../models/token");
const mailSender = require("../helpers/email_sender");

/**
 * Register a new user
 *
 * Handles new user registration by validating input, hashing the password,
 * and creating a new user document in MongoDB.
 *
 * @param {Object} req - Express request object, expects `email`, `password`, and user details in body.
 * @param {Object} res - Express response object, returns newly created user or error response.
 *
 * @returns {JSON} Various status codes (200, 400, 404, 500)
 */
exports.register = async function (req, res) {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    const errorMessages = errors.array().map((error) => ({
      field: error.path,
      message: error.msg,
    }));
    return res.status(400).json({ errors: errorMessages });
  }
  try {
    let user = new User({
      ...req.body,
      passwordHash: bcrypt.hashSync(req.body.password, 8),
    });

    user = await user.save();
    if (!user) {
      return res.status(500).json({
        type: "Internal Server Error",
        message: "Could not create a new user",
      });
    }

    return res.status(201).json(user);
  } catch (error) {
    console.error(error);
    if (error.message.includes("email_1 dup key")) {
      return res.status(409).json({
        type: "AuthError",
        message: "User with that email already exists.",
      });
    }
    return res.status(500).json({ type: error.name, message: error.message });
  }
};

/**
 * Login user
 *
 * Authenticates a user by verifying email and password, then generates
 * and stores access/refresh tokens.
 *
 * @param {Object} req - Express request object, expects `email` and `password` in body.
 * @param {Object} res - Express response object, returns user data with access token or error.
 *
 * @returns {JSON} Various status codes (200, 400, 404, 500)
 */
exports.login = async function (req, res) {
  try {
    const { email, password } = req.body;
    const user = await User.findOne({ email });
    if (!user) {
      return res
        .status(404)
        .json({ message: "User not found\nCheck your email and try again." });
    }
    if (!bcrypt.compareSync(password, user.passwordHash)) {
      return res.status(400).json({ message: "Incorrect password!" });
    }

    const accessToken = jwt.sign(
      { id: user.id, isAdmin: user.isAdmin },
      process.env.ACCESS_TOKEN_SECRET,
      { expiresIn: "24h" }
    );

    const refreshToken = jwt.sign(
      { id: user.id, isAdmin: user.isAdmin },
      process.env.REFRESH_TOKEN_SECRET,
      { expiresIn: "60d" }
    );

    const token = await Token.findOne({ userId: user.id });
    if (token) await token.deleteOne();
    await new Token({
      userId: user.id,
      accessToken,
      refreshToken,
    }).save();
    user.passwordHash = undefined;
    return res.json({ ...user._doc, accessToken });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ type: error.name, message: error.message });
  }
};

/**
 * Verify JWT token
 *
 * Middleware that checks for a valid JWT in the `Authorization` header.
 * If valid, attaches the decoded user info to `req.user` and continues.
 * If invalid or missing, responds with an error.
 *
 * @param {Object} req - Express request object, expects `Authorization` header with Bearer token.
 * @param {Object} res - Express response object, returns error if token is invalid or missing.
 * @param {Function} next - Express next middleware function to pass control.
 *
 * @returns {JSON} Various status codes (200 if valid, 401/403 if invalid, 500 on error)
 */
exports.verifyToken = async function (req, res) {
  try {
    let accessToken = req.headers.authorization;
    if (!accessToken) return res.json(false);
    accessToken = accessToken.replace("Bearer", "").trim();

    const token = await Token.findOne({ accessToken });
    if (!token) return res.json(false);

    const tokenData = jwt.decode(token.refreshToken);

    const user = await User.findById(tokenData.id);
    if (!user) return res.json(false);

    const isValid = jwt.verify(
      token.refreshToken,
      process.env.REFRESH_TOKEN_SECRET
    );
    if (!isValid) return res.json(false);
    return res.json(true);
  } catch (error) {
    console.error(error);
    return res.status(500).json({ type: error.name, message: error.message });
  }
};

/**
 * Forgot Password
 *
 * Generates and sends a password reset OTP to the user's email.
 *
 * @param {Object} req - Express request object, expects `email` in body.
 * @param {Object} res - Express response object, returns success message or error.
 *
 * @returns {JSON} Various status codes (200 on success, 400/404 for errors, 500 on server error)
 */
exports.forgotPassword = async function (req, res) {
  try {
    const { email } = req.body;

    const user = await User.findOne({ email });

    if (!user) {
      return res
        .status(404)
        .json({ message: "User with that email does NOT exist!" });
    }

    const otp = Math.floor(1000 + Math.random() * 9000);

    user.resetPasswordOtp = otp;
    user.resetPasswordOtpExpires = Date.now() + 600000;

    await user.save();

    const response = await mailSender.sendMail(
      email,
      "Password Reset OTP",
      `Your OTP for password reset is: ${otp}`
    );
    return res.json({ message: response });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ type: error.name, message: error.message });
  }
};

/**
 * Verify Password Reset OTP
 *
 * Validates the OTP entered by the user against the one stored in the database.
 *
 * @param {Object} req - Express request object, expects `email` and `otp` in body.
 * @param {Object} res - Express response object, returns verification result.
 *>
 * @returns {JSON} Various status codes (200 if OTP valid, 400/404 for errors, 500 on server error)
 */
exports.verifyPasswordResetOTP = async function (req, res) {
  try {
    const { email, otp } = req.body;

    const user = await User.findOne({ email });
    if (!user) {
      return res.status(404).json({ message: "User not found!" });
    }

    if (
      user.resetPasswordOtp !== +otp ||
      Date.now() > user.resetPasswordOtpExpires
    ) {
      return res.status(401).json({ message: "Invalid or expired OTP" });
    }
    user.resetPasswordOtp = 1;
    user.resetPasswordOtpExpires = undefined;

    await user.save();
    return res.json({ message: "OTP confirmed successfully." });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ type: error.name, message: error.message });
  }
};

/**
 * Reset Password
 *
 * Allows user to reset password after successful OTP verification.
 *
 * @param {Object} req - Express request object, expects `email` and new `password` in body.
 * @param {Object} res - Express response object, returns confirmation message or error.
 *
 * @returns {JSON} Various status codes (200 on success, 400/404 for errors, 500 on server error)
 */
exports.resetPassword = async function (req, res) {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    const errorMessages = errors.array().map((error) => ({
      field: error.path,
      message: error.msg,
    }));
    return res.status(400).json({ errors: errorMessages });
  }
  try {
    const { email, newPassword } = req.body;

    const user = await User.findOne({ email });
    if (!user) {
      return res.status(404).json({ message: "User not found!" });
    }

    if (user.resetPasswordOtp !== 1) {
      return res
        .status(401)
        .json({ message: "Confirm OTP before resetting password." });
    }

    user.passwordHash = bcrypt.hashSync(newPassword, 8);
    user.resetPasswordOtp = undefined;
    await user.save();

    return res.json({ message: "Password reset successfully" });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ type: error.name, message: error.message });
  }
};
