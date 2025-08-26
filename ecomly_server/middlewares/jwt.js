const { expressjwt: expjwt } = require("express-jwt");
const { Token } = require("../models/token");

/**
 * JWT Authentication Middleware
 *
 * Provides route protection using JSON Web Tokens (JWT) with support for:
 * - Token validation (signature + expiration).
 * - Revocation check against stored tokens in the database.
 * - Admin route restriction.
 * - Whitelisted routes that bypass authentication.
 *
 * Usage:
 *   const authJwt = require("./middlewares/jwt");
 *   app.use(authJwt());
 *
 * Workflow:
 * - Protects all routes except those listed in `unless`.
 * - Extracts JWT from Authorization header (`Bearer <token>`).
 * - Checks if the token exists in the `Token` collection (i.e., not revoked).
 * - Denies access if token is invalid, missing, revoked, or if a non-admin user
 *   attempts to access admin routes.
 */
function authJwt() {
  const API = process.env.API_URL;

  return expjwt({
    secret: process.env.ACCESS_TOKEN_SECRET, // secret key for token verification
    algorithms: ["HS256"], // supported algorithm
    isRevoked: isRevoked, // custom revocation logic
  }).unless({
    path: [
      // Public endpoints (accessible without authentication)
      `${API}/login`,
      `${API}/login/`,

      `${API}/register`,
      `${API}/register/`,

      `${API}/forgot-password`,
      `${API}/forgot-password/`,

      `${API}/verify-otp`,
      `${API}/verify-otp/`,

      `${API}/reset-password`,
      `${API}/reset-password/`,

      // Payment webhook (must be public)
      `${API}/checkout/webhook`,

      // Static public files
      { url: /\/public\/.*/, methods: ["GET", "OPTIONS"] },
    ],
  });
}

/**
 * Token Revocation Check
 *
 * Determines whether a token should be considered invalid:
 * - Token must be present in the `Token` collection.
 * - Token must match the current access token stored in DB.
 * - If request is for `/admin/*` routes, user must have `isAdmin` flag.
 *
 * @param {Object} req - Express request object
 * @param {Object} jwt - Decoded JWT payload
 * @returns {Boolean} `true` if revoked, `false` if valid
 */
async function isRevoked(req, jwt) {
  const authHeader = req.header("Authorization");

  // Reject if missing or malformed Authorization header
  if (!authHeader || !authHeader.startsWith("Bearer ")) {
    return true;
  }

  // Extract access token from header
  const accessToken = authHeader.replace("Bearer", "").trim();

  // Verify token exists in database (not revoked)
  const token = await Token.findOne({ accessToken });

  // Restrict non-admin users from accessing /admin/* routes
  const adminRouteRegex = /^\/api\/v1\/admin\//i;
  const adminFault =
    !jwt.payload.isAdmin && adminRouteRegex.test(req.originalUrl);

  return adminFault || !token;
}

module.exports = authJwt;
