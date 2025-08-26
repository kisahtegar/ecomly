const jwt = require("jsonwebtoken");
const { default: mongoose } = require("mongoose");

/**
 * Authorization Middleware
 *
 * Ensures that for certain POST requests, the user making the request matches
 * the user specified in the request body or URL.
 *
 * Workflow:
 * - Skips if request method is not POST.
 * - Skips for `/admin` endpoints (handled separately).
 * - Skips for public endpoints (`/login`, `/register`, `/forgot-password`, `/verify-otp`, `/reset-password`).
 * - If an Authorization header is present, decodes the JWT.
 * - Validates that the `req.body.user` or the `:id` parameter in the `/users/:id/...` route
 *   matches the `id` from the token.
 * - If mismatch occurs, responds with `401 Unauthorized`.
 *
 * This helps prevent one user from performing actions on behalf of another.
 */
async function authorizePostRequests(req, res, next) {
  // Only apply to POST requests
  if (req.method !== "POST") return next();

  const API = process.env.API_URL;

  // Skip admin endpoints (authorization handled separately)
  if (req.originalUrl.startsWith(`${API}/admin`)) return next();

  // Define endpoints that do not require authorization
  const endpoints = [
    `${API}/login`,
    `${API}/register`,
    `${API}/forgot-password`,
    `${API}/verify-otp`,
    `${API}/reset-password`,
  ];

  // Skip if the current request matches a public endpoint
  const isMatchingEndpoint = endpoints.some((endpoint) =>
    req.originalUrl.includes(endpoint)
  );
  if (isMatchingEndpoint) return next();

  // Error message for user mismatch
  const message =
    "User conflict!\nThe user making the request doesn't match the user in the request.";

  // Extract Authorization header
  const authHeader = req.header("Authorization");
  if (!authHeader) return next();

  // Extract and decode token
  const accessToken = authHeader.replace("Bearer", "").trim();
  const tokenData = jwt.decode(accessToken);

  /**
   * Case 1: User ID in request body must match the token's user ID
   */
  if (req.body.user && tokenData.id !== req.body.user) {
    return res.status(401).json({ message });
  } else if (/\/users\/([^/]+)\//.test(req.originalUrl)) {
    /**
     * Case 2: User ID in URL (e.g., /users/:id/...) must match the token's user ID
     */
    const parts = req.originalUrl.split("/");
    const usersIndex = parts.indexOf("users");
    const id = parts[usersIndex + 1];

    // Validate ObjectId format
    if (!mongoose.isValidObjectId(id)) return next();

    if (tokenData.id !== id) {
      return res.status(401).json({ message });
    }
  }

  // If all checks pass, proceed
  return next();
}

module.exports = authorizePostRequests;
