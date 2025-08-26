const jwt = require("jsonwebtoken");
const { Token } = require("../models/token");
const { User } = require("../models/user");

/**
 * Global Error Handler Middleware
 *
 * Intercepts errors across the app and provides structured JSON responses.
 * Special handling is implemented for JWT expiration errors:
 * - Attempts to refresh access tokens using stored refresh tokens.
 * - Issues a new access token and updates both response headers and DB.
 *
 * Workflow:
 * - If error is "UnauthorizedError" but not due to expiration → respond with 401.
 * - If expired JWT → try refreshing with refresh token.
 * - If refresh succeeds → replace Authorization header with new token and continue.
 * - If refresh fails → respond with 401 Unauthorized.
 * - All other errors → return 404 with error details.
 */
async function errorHandler(error, req, res, next) {
  console.log("ERROR OCCURRED");

  if (error.name === "UnauthorizedError") {
    // Unauthorized but not because of expiration
    if (!error.message.includes("jwt expired")) {
      return res
        .status(error.status)
        .json({ type: error.name, message: error.message });
    }

    // Access token expired, try refresh
    try {
      const tokenHeader = req.header("Authorization");
      const accessToken = tokenHeader?.split(" ")[1];

      // Find token document that contains a refreshToken
      const token = await Token.findOne({
        accessToken,
        refreshToken: { $exists: true },
      });

      if (!token) {
        return res
          .status(401)
          .json({ type: "Unauthorized", message: "Token does not exist." });
      }

      // Verify refresh token
      const userData = jwt.verify(
        token.refreshToken,
        process.env.REFRESH_TOKEN_SECRET
      );

      // Ensure user still exists
      const user = await User.findById(userData.id);
      if (!user) {
        return res.status(404).json({ message: "Invalid user!" });
      }

      // Generate new access token
      const newAccessToken = jwt.sign(
        { id: user.id, isAdmin: user.isAdmin },
        process.env.ACCESS_TOKEN_SECRET,
        { expiresIn: "24h" }
      );

      // Inject new token into request + response + DB
      req.headers["authorization"] = `Bearer ${newAccessToken}`;
      await Token.updateOne(
        { _id: token.id },
        { accessToken: newAccessToken }
      ).exec();

      res.set("Authorization", `Bearer ${newAccessToken}`);

      // Allow request to continue
      return next();
    } catch (refreshError) {
      return res
        .status(401)
        .json({ type: "Unauthorized", message: refreshError.message });
    }
  }

  // Fallback: Unknown errors
  console.error(error);
  return res.status(404).json({ type: error.name, message: error.message });
}

module.exports = errorHandler;
